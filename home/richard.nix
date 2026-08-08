{ pkgs, ... }:

{
  home.username = "richard";
  home.homeDirectory = "/Users/richard";

  home.packages = [
    pkgs.ripgrep
  ];

  programs.home-manager.enable = true;

  # Compatibility value for Home Manager; change only after reading its release notes.
  home.stateVersion = "26.05";
  imports = [
    ./git.nix
  ];
}
