{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.gpg = {
    enable = true;
    mutableKeys = true;
    mutableTrust = true;
    scdaemonSettings = {
      # Use PC/SC instead of direct CCID so gpg-agent can share the YubiKey
      # with Yubico Authenticator (which holds CCID exclusively otherwise)
      disable-ccid = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    # GitKraken's OpenPGP helper submits an empty PIN in loopback mode and
    # leaves the smartcard operation open indefinitely. Reject loopback PIN
    # requests so they fail fast instead of blocking normal Git signing.
    extraConfig = "no-allow-loopback-pinentry";
    pinentry.package = pkgs.pinentry_mac;
  };

  # Home Manager's launchd socket is created under /private/var/run, but
  # gpgconf expects it in ~/.gnupg. Let GnuPG start the managed agent on
  # demand so every client uses the socket it actually advertises.
  launchd.agents.gpg-agent.enable = lib.mkForce false;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Richard Annand";
        email = "richard@ohheyrj.co.uk";
        signingKey = "7FA00C301979455214E4294865212690666E56A5!";
      };
      init.defaultBranch = "main";
      ghq.root = "/Users/richard/repos";
      pull.ff = "only";
      push.autoSetupRemote = true;
      core.editor = "nvim";
    };
    lfs = {
      enable = true;
    };
    signing = {
      format = "openpgp";
      signer = "${config.programs.gpg.package}/bin/gpg";
      signByDefault = true;
    };
  };
}
