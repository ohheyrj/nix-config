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

    claude-plugins-official = {
      url = "github:anthropics/claude-plugins-official";
      flake = false;
    };

    agent-toolkit-for-aws = {
      url = "github:aws/agent-toolkit-for-aws";
      flake = false;
    };

    claude-code-warp = {
      url = "github:warpdotdev/claude-code-warp";
      flake = false;
    };
  };



  outputs =
    { nix-darwin, home-manager, sops-nix, ... }@inputs:
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
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
}
