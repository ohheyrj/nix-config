{ pkgs, ... }:

{
  home = {
    username = "richard";
    homeDirectory = "/Users/richard";
    packages = [
      pkgs.ripgrep
      pkgs.age-plugin-yubikey
      pkgs.sops
    ];

    sessionVariables = {
      EDITOR = "nvim";
      NPM_CONFIG_PREFIX = "$HOME/.npm-global";
      SOPS_AGE_KEY_FILE = "~/.config/sops/age/keys.txt";
    };

    sessionPath = [
      "$HOME/.npm-global/bin"
      "/Users/richard/.lmstudio/bin"
      "/Users/richard/.bin"
      "$HOME/.local/bin"
    ];

    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;

  imports = [
    ./git.nix
    ./podman.nix
    ./mcp.nix
    ./ai/claude-code.nix
    ./shell/fzf.nix
  ];

  sops.age.keyFile = "/Users/richard/Library/Application Support/sops/age/keys.txt";
  sops.defaultSopsFile = ../secrets.yaml;
}
