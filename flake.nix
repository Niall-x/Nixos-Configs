{
  description = "Nixos flake config, common accross all hostsystems";

  inputs = {

    ### UNIVERSAL FLAKE INPUTS ###

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### MACHINE SPECIFIC FLAKE INPUTS ###

    ### nialls-laptop (framework 13: officialy suported)###
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### nialls-pc (ESP32 IR remote — CEC alternative) ###
    esp32-ir-remote = {
      url = "github:Niall-x/ESP32-IR-CEC-Alternative";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    mkHost = { hostname }: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/${hostname}/configuration.nix
        home-manager.nixosModules.default
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs hostname; };
          home-manager.users.niall = ./home.nix;
        }
      ];
    };
  in
  {
    nixosConfigurations.nialls-pc     = mkHost { hostname = "nialls-pc"; };
    nixosConfigurations.nialls-laptop = mkHost { hostname = "nialls-laptop"; };
    nixosConfigurations.nialls-surface = mkHost { hostname = "nialls-surface"; };
  };
}
