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
  };

  outputs = inputs@{ nixpkgs, disko, stylix, home-manager, nixos-generators,... }: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    nixosConfigurations.pentest = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        testBool = "enabled";
      };
      modules = [
        stylix.nixosModules.stylix
        disko.nixosModules.disko
        ./configuration.nix
        home-manager.nixosModules.home-manager
          {
            #home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.lapinou = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
      ];
    };
    packages.x86_64-linux = {
    iso = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        modules = [
          stylix.nixosModules.stylix
        disko.nixosModules.disko
        ./configuration.nix
        home-manager.nixosModules.home-manager
          {
            #home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.lapinou = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
        format = "iso";
        specialArgs = { testBool = "disabled"; };
    };
    };
  };
}
