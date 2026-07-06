{
  description = "NixOS configuration for ThinkPad X1";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, hyprland, rust-overlay, stylix, ... }@inputs:
  {
    nixosConfigurations.thinkpad-x1 = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ({ ... }: {
          nixpkgs.hostPlatform    = "x86_64-linux";
          nixpkgs.overlays        = [ rust-overlay.overlays.default ];
          nixpkgs.config.allowUnfree = true;
        })

        stylix.nixosModules.stylix

        ./hosts/thinkpad-x1/default.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.chris = import ./home/default.nix;
        }
      ];
    };

  };
}
