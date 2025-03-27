{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      disko,
      stylix,
      home-manager,
      nixos-generators,
      systems,
      treefmt-nix,
      impermanence,
      ...
    }:
    let
      # Small tool to iterate over each systems
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      # for `nix fmt`
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
      # for `nix flake check`
      checks = eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });

      nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit self;
        };
        modules = [
          stylix.nixosModules.stylix
          disko.nixosModules.disko
          ./hosts/vm/configuration.nix
          ./nixosModules
          inputs.home-manager.nixosModules.default
          impermanence.nixosModules.impermanence
        ];
      };
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit self;
        };
        modules = [
          stylix.nixosModules.stylix
          disko.nixosModules.disko
          ./hosts/laptop/configuration.nix
          ./nixosModules
          inputs.home-manager.nixosModules.default
        ];
      };
      nixosConfigurations.work = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit self;
        };
        modules = [
          stylix.nixosModules.stylix
          disko.nixosModules.disko
          ./hosts/work/configuration.nix
          ./nixosModules
          inputs.home-manager.nixosModules.default
        ];
      };
      packages.x86_64-linux = {
        iso = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          specialArgs = {
            inherit self;
          };
          modules = [
            stylix.nixosModules.stylix
            disko.nixosModules.disko
            ./hosts/iso/configuration.nix
            ./nixosModules
            inputs.home-manager.nixosModules.default
          ];
          format = "iso";
        };
      };
    };
}
