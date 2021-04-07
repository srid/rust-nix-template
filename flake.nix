{
  description = "bouncy";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nmattia/naersk";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, utils, rust-overlay, naersk, ... }:
    utils.lib.eachDefaultSystem
      (system:
        /* let pkgs = import nixpkgs {
          inherit system;
          overlays = [ rust-overlay.overlay ];
        }; */
        let 
          pkgs = nixpkgs.legacyPackages."${system}";
          naersk-lib = naersk.lib."${system}";
        in rec {
          # `nix build`
          packages.bouncy = naersk-lib.buildPackage {
            pname = "bouncy";
            root = ./.;
          };
          defaultPackage = packages.bouncy;

          # `nix run`
          apps.bouncy = utils.lib.mkApp {
            drv = packages.bouncy;
          };
          defaultApp = apps.bouncy;

          # `nix develop`
          devShell = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [ rustc cargo ];
            RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
          };
          /* devShell = pkgs.mkShell {
            nativeBuildInputs = [
              (pkgs.rust-bin.stable.latest.default.override {
                extensions = [
                  "rust-src"
                  "cargo"
                  "rustc"
                  "rls"
                  "rust-analysis"
                  "rustfmt"
                  "clippy"
                ];
              })
            ];
          }; */
        }
      );
}
