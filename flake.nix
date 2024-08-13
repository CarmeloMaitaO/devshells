{
  description = "Nix flakes templates for development environments in the languages I use";
  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # Latest commit in the branch nixos-24.05
    nixpkgs.url = "github:nixos/nixpkgs/a781ff33ae258bbcfd4ed6e673860c3e923bf2cc";
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    templates.nim = {
      path = ./nim;
      description = "Nim devshell";
    };
    templates.js = {
      path = ./js;
      description = "JS devshell";
    };
  };
}
