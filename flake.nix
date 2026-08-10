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

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      home-manager,
      sops-nix,
      pre-commit-hooks,
      ...
    }@inputs:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        inherit
          (pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixfmt.enable = true;
              deadnix.enable = true;
              statix.enable = true;
            };
          })
          shellHook
          ;
      };

      darwinConfigurations.evilcorp = nix-darwin.lib.darwinSystem {
        modules = [
          ./hosts/evilcorp.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.richard = import ./home/richard.nix;
              sharedModules = [ sops-nix.homeManagerModules.sops ];
              backupFileExtension = "nix-backup";
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
    };
}
