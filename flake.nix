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
    {
      nixpkgs,
      nix-darwin,
      home-manager,
      sops-nix,
      ...
    }@inputs:
    let
      system = "aarch64-darwin";
      localOverlay = final: _prev: {
        obsidian-mcp = final.callPackage ./packages/obsidian-mcp.nix { };
      };
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ localOverlay ];
      };
    in
    {
      packages.${system}.obsidian-mcp = pkgs.obsidian-mcp;

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.deadnix
          pkgs.nixfmt
          pkgs.statix
        ];
      };

      darwinConfigurations.evilcorp = nix-darwin.lib.darwinSystem {
        modules = [
          ./hosts/evilcorp.nix
          home-manager.darwinModules.home-manager
          {
            nixpkgs.overlays = [ localOverlay ];

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
