{ pkgs, ... }:

{
  home = {
    username = "richard";
    homeDirectory = "/Users/richard";
    packages = [
      pkgs.ripgrep
      pkgs.age-plugin-yubikey
      pkgs.opencommit
      pkgs.sops
      pkgs.podman-compose
    ];

    sessionVariables = {
      EDITOR = "nvim";
      NPM_CONFIG_PREFIX = "$HOME/.npm-global";
      SOPS_AGE_KEY_FILE = "~/.config/sops/age/keys.txt";
      OCO_AI_PROVIDER = "ollama";
      OCO_API_URL = "http://localhost:11434";
      OCO_MODEL = "kimi-k2.7-code:cloud";
      OCO_API_KEY = "ollama";
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
    ./ai
    ./gh.nix
    ./git.nix
    ./podman.nix
    ./shell
    ./ssh.nix
    ./uv.nix
  ];

  sops.age.keyFile = "/Users/richard/Library/Application Support/sops/age/machine-key.txt";
  sops.defaultSopsFile = ../secrets.yaml;
}
