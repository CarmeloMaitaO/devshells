{
  description = "Nim development environment with a Nimble config";
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
task compile, "Compiles":
  let target = "x86_64-linux-gnu "
  let d = "-d:release "
  let cc = "--cc:clang "
  let exe = "--clang.exe=\"zigcc\" "
  let linker = "--clang.linkerexe=\"zigcc\" "
  let cmd = "nim c " & d & cc & exe & linker
  exec cmd
      '';
    };

    check = ''
      file=''${PWD##*/}
      file=''${file:-/}
      file=''${file}.nimble
      if [ ! -e $file ]
        then
	  nimble init
	  cat ${configFile} >> ''${file}
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
