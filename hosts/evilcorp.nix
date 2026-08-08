{ ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.zsh.enable = true;

  users.users.richard.home = "/Users/richard";

  # Compatibility value for nix-darwin; change only after reading its changelog.
  system.stateVersion = 6;
}
