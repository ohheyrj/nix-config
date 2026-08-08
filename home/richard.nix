{ pkgs, ... }:

{
  home.username = "richard";
  home.homeDirectory = "/Users/richard";

  home.packages = [
    pkgs.ripgrep
    pkgs.age-plugin-yubikey
    pkgs.sops
  ];

  programs.home-manager.enable = true;

  # Compatibility value for Home Manager; change only after reading its release notes.
  home.stateVersion = "26.05";
  imports = [
    ./git.nix
    ./podman.nix
    ./mcp.nix
  ];

  sops.age.keyFile = "/Users/richard/Library/Application Support/sops/age/keys.txt";
  sops.defaultSopsFile = ../secrets.yaml;
}
