{
  description = "bouncy";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem 
      (system: 
        let pkgs = import nixpkgs {
          inherit system;
          overlays = [rust-overlay.overlay ];
        }; in {
          devShell = pkgs.mkShell {
            nativeBuildInputs = [
              pkgs.rust-bin.stable.latest.default
            ];
          };
        }
      );
}
