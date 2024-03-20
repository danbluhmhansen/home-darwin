{
  description = "Darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    stylix.url = "github:danth/stylix";
    devenv.url = "github:cachix/devenv";
    helix.url = "github:helix-editor/helix";
    zjstatus.url = "github:dj95/zjstatus";
  };

  outputs = {
    home-manager,
    darwin,
    nixpkgs-firefox-darwin,
    nur,
    stylix,
    devenv,
    zjstatus,
    ...
  }: {
    darwinConfigurations.Kathleens-MacBook-Air = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          nixpkgs.overlays = [
            nixpkgs-firefox-darwin.overlay
            (final: prev: {zjstatus = zjstatus.packages.${prev.system}.default;})
          ];
          home-manager.users.danbluhmhansen.imports = [
            ./home.nix
            ./zellij.nix
            ./firefox.nix
            ./helix.nix
            ./gpg.nix
            nur.hmModules.nur
            stylix.homeManagerModules.stylix
          ];

          # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          home-manager.extraSpecialArgs = {
            inherit devenv;
          };
        }
      ];
    };
  };
}
