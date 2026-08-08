# Secrets management: sops-nix + YubiKey

How secrets (API keys, tokens, etc.) are handled in this flake. Secrets are
encrypted at rest and committed to the repo as ciphertext; they're decrypted
automatically during `darwin-rebuild switch`, using an age identity that
lives on a YubiKey rather than a plaintext key file on disk.

Motivating example used throughout: the `context7` MCP server in
`home/mcp.nix` needs a `CONTEXT7_API_KEY`.

## Why hardware-backed

A plain `age` key file on disk (`~/Library/Application Support/sops/age/keys.txt`)
is the simpler setup, but the private key material sits unencrypted on the
machine. Backing it with a YubiKey means the private key never leaves the
device — decryption happens *on* the YubiKey, gated by a physical touch (and
optionally a PIN).

**Trade-off to accept going in:** sops-nix decrypts secrets on every
home-manager activation, so **every** `darwin-rebuild switch` — even one
that only touches unrelated files like `git.nix` — will prompt for a
YubiKey touch. Touch presence can be cached for ~15s (`--touch-policy
cached`), but the PIN prompt can't really be avoided since the plugin
process is short-lived. This is deliberate friction in exchange for the key
never being exfiltratable from the Mac itself.

## Prerequisites

- A YubiKey with PIV support (YubiKey 4/5 series).
- `age-plugin-yubikey` available — add it declaratively via nix rather than
  installing out of band:

  ```nix
  # e.g. in home/richard.nix
  home.packages = [
    pkgs.age-plugin-yubikey
    pkgs.sops
  ];
  ```
- `ykman` (YubiKey Manager) is handy for inspecting the key but not required
  for the steps below.

## One-time setup

### 1. Generate the hardware-backed age identity

```sh
age-plugin-yubikey --generate --touch-policy cached --name sops-evilcorp
```

This talks to the YubiKey over PIV, creates a new key in an unused PIV
slot, and prints two things — keep both, but note only one is secret:

- An **identity** (`AGE-PLUGIN-YUBIKEY-...`) — a *pointer* to the hardware
  slot, not the private key itself. Safe-ish to have on disk, but treat it
  as "this file lets whoever's holding the physical YubiKey decrypt" — so
  don't publish it needlessly.
- A **recipient** (`age1yubikey1...`) — the public key. This is what goes
  in `.sops.yaml`; fine to commit.

Save the identity output to the same path sops-nix normally uses for a
software key, so the rest of the setup (`sops.age.keyFile`) doesn't need to
know the difference:

```sh
mkdir -p "$HOME/Library/Application Support/sops/age"
age-plugin-yubikey --identity --serial <SERIAL> --slot 1 \
  > "$HOME/Library/Application Support/sops/age/keys.txt"
```

(`age-plugin-yubikey --list` shows the serial/slot if you forget them.)

### 2. Set up a backup recipient

**Important:** if this YubiKey is the only recipient and it's lost or dies,
`secrets.yaml` becomes permanently undecryptable. Generate a second
identity — either a second YubiKey (`--serial` picks which device) or a
plain software age key kept somewhere safe (e.g. a password manager) —
and add its recipient alongside the primary one in `.sops.yaml` (step 4).
Every recipient listed can decrypt independently; sops encrypts to all of
them.

### 3. Add sops-nix as a flake input

In `flake.nix`:

```nix
inputs.sops-nix.url = "github:Mic92/sops-nix";
inputs.sops-nix.inputs.nixpkgs.follows = "nixpkgs";
```

And wire the home-manager module into the `evilcorp` configuration, next
to the existing `home-manager.users.richard` block:

```nix
home-manager.sharedModules = [ sops-nix.homeManagerModules.sops ];
```

(`sops-nix` needs to be destructured in the `outputs = { ... }:` argument
list alongside `nix-darwin` and `home-manager`.)

### 4. Create `.sops.yaml` (repo root)

```yaml
keys:
  - &yubikey_primary age1yubikey1...   # recipient from step 1
  - &backup age1...                    # recipient from step 2
creation_rules:
  - path_regex: secrets\.yaml$
    key_groups:
      - age:
          - *yubikey_primary
          - *backup
```

### 5. Create and encrypt `secrets.yaml` (repo root)

```sh
cat > secrets.yaml <<'EOF'
context7_api_key: replace-with-real-key
EOF

sops --encrypt --in-place secrets.yaml
```

`sops` reads `.sops.yaml` to know who to encrypt for. The file on disk
after this is ciphertext — safe to `git add`/commit even if the repo were
public. To edit a secret later: `sops secrets.yaml` (opens your `$EDITOR`
with the plaintext, re-encrypts on save — touch/PIN required, same as any
other decrypt).

### 6. Wire it into home-manager

`sops.age.keyFile` and `sops.defaultSopsFile` are global to the whole
home-manager config — every `sops.secrets.*` declaration in every file
uses them — so they belong in `home/richard.nix`, not scoped to MCP:

```nix
# home/richard.nix
{
  sops.age.keyFile = "/Users/richard/Library/Application Support/sops/age/keys.txt";
  sops.defaultSopsFile = ../secrets.yaml;
  # ...existing content (home.packages, imports, etc.)
}
```

`sops.age.keyFile` points at the *identity* file from step 1 — the same
path whether it holds a software key or a YubiKey pointer, which is why
nothing else here needs to change for the hardware-backed setup.

The secret declaration and the thing that actually uses it stay together
in `home/mcp.nix` (needs `config` in scope now):

```nix
{ config, ... }:
{
  sops.secrets.context7_api_key = { };

  programs.mcp.servers.context7 = {
    command = "npx";
    args = [ "-y" "@upstash/context7-mcp" ];
    env.CONTEXT7_API_KEY = { file = config.sops.secrets.context7_api_key.path; };
  };
}
```

### 7. Apply

```sh
darwin-rebuild switch --flake .#evilcorp
```

Expect a YubiKey touch prompt (and PIN, if one's set on the PIV applet)
during the home-manager activation step, before `context7`'s
`CONTEXT7_API_KEY` env file gets materialized.

## Adding another secret later

1. `sops secrets.yaml` → add a new `key: value` line → save (encrypts on
   write).
2. Declare it: `sops.secrets.<name> = { };` in whichever `home/*.nix` file
   needs it.
3. Reference `config.sops.secrets.<name>.path` wherever that file/value is
   needed (e.g. another `programs.mcp.servers.<x>.env.<VAR> = { file = ...; }`).
4. `darwin-rebuild switch`.

No changes needed to `.sops.yaml` or the age setup for additional secrets
in the same `secrets.yaml` — the recipients are file-level, not per-key.

## Troubleshooting

- **No touch prompt appears / decrypt hangs**: `age-plugin-yubikey --list`
  to confirm the key is detected; try re-plugging.
- **"no identity matched any of the recipients"**: `sops.age.keyFile`
  doesn't match a recipient in `.sops.yaml` — check you saved the right
  identity/recipient pair from step 1, and that both got added before
  running `sops --encrypt`.
- **Lost the YubiKey**: decrypt with the backup recipient from step 2, then
  generate a new hardware identity and re-encrypt `secrets.yaml` for it
  (`sops updatekeys secrets.yaml` after editing `.sops.yaml`).
