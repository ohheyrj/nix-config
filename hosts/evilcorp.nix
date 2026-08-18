{ pkgs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";

  fonts.packages = [
    pkgs.nerd-fonts.hurmit
  ];
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPath = [ "/etc/profiles/per-user/richard/bin" ];

  programs.zsh.enable = true;
  security.pam.services.sudo_local = {
    touchIdAuth = true;
  };
  users.users.richard.home = "/Users/richard";

  # Compatibility value for nix-darwin; change only after reading its changelog.
  system.stateVersion = 6;
}
