{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    webcord.url = "github:fufexan/webcord-flake";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix.url = "github:the-argus/spicetify-nix";
  };
  outputs = { self, nixpkgs, hyprland, webcord, home-manager, spicetify-nix, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        hyprland.nixosModules.default
        { programs.hyprland.enable = true; }
        ./configuration.nix
      ];
    };
    homeConfigurations = {
      "ash_17@nixos" = home-manager.lib.homeManagerConfiguration {
       # system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home-manager/home.nix spicetify-nix.homeManagerModule ];
      };
    };
  };  
}
