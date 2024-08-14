{
  description = "Nim development environment with a Nimscript config and Zigcc";
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
    nixpkgs.url = "github:nixos/nixpkgs/63dacb46bf939521bdc93981b4cbb7ecb58427a0";
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    configFile = pkgs.writeTextFile {
      name = "";
      text = /*nimscript*/ ''
import std/os
let nimbleDir = getHomeDir() & "/.nimble/bin"
let zigcc = nimbleDir & "/zigcc"

switch("path", nimbleDir)
switch("define", "release")
switch("cc", "clang")
switch("clang.exe", "zigcc")
switch("clang.linkerexe", "zigcc")
      '';
    };

    check = ''
      file="config.nims"
      if [ ! -e $file ]
        then
	  cat ${configFile} > ''${file}
      fi
    '';

  in {
    devShells.${system}.default = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        nim
	nimble
	zig
      ];

      shellHook = ''
        export PATH+=":~/.nimble/bin"
	${check}
      '';

    };
  };
}
