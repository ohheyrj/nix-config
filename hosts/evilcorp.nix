_:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.zsh.enable = true;
  security.pam.services.sudo_local = {
    touchIdAuth = true;
  };
  users.users.richard.home = "/Users/richard";

  # Compatibility value for nix-darwin; change only after reading its changelog.
  system.stateVersion = 6;
}
