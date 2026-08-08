{
  description = "Richard's macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };



  outputs =
    { nix-darwin, home-manager, sops-nix, ... }:
    {
      darwinConfigurations.evilcorp = nix-darwin.lib.darwinSystem {
        modules = [
          ./hosts/evilcorp.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.richard = import ./home/richard.nix;
            home-manager.sharedModules = [ sops-nix.homeManagerModules.sops ];
            home-manager.backupFileExtension = "nix-backup";
          }
        ];
      };
    };
}
