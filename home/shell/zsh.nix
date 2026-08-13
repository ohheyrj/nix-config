{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    shellAliases = {
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      update-nix = "darwin-rebuild switch --flake ~/nix";
      update-nix-trace = "darwin-rebuild switch --flake ~/nix --show-trace";
      assume = "source assume";
      docker = "podman";
      ns = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
    };
    syntaxHighlighting = {
      enable = true;
    };
    autosuggestion = {
      enable = true;
    };
    history = {
      append = true;
      findNoDups = true;
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
      saveNoDups = true;
      share = true;
    };
    plugins = [
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "aws"
        "kubectl"
        "kubectx"
        "command-not-found"
        "terraform"
        "vscode"
      ];
    };
    initContent = ''
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

      load_secret() {
        echo "Loading Digital Ocean Token"
        export DIGITALOCEAN_TOKEN=$(op read "op://Private/DigitalOcean Personal Access Token/token")
        echo "Loading Cloudflare Token"
        export CLOUDFLARE_API_TOKEN=$(op read "op://Private/Cloudflare Personal/token")
        echo "Loading Vault Token"
        export VAULT_TOKEN=$(op read "op://Private/Vault Token/token")
        echo "Loading Authentik Token"
        export AUTHENTIK_TOKEN=$(op read "op://Private/Authentik Token/token")
      }
    '';
  };
}
