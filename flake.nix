{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    rust-flake.url = "github:juspay/rust-flake";
    rust-flake.inputs.nixpkgs.follows = "nixpkgs";

    # Dev tools
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };


  outputs = { self, nixpkgs, flake-parts, systems, rust-flake, treefmt-nix }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;
      imports = [
        treefmt-nix.flakeModule
        rust-flake.flakeModules.default
        rust-flake.flakeModules.nixpkgs
      ];
      perSystem = { config, self', pkgs, lib, system, ... }: {
        rust-project.crane.args = {
          buildInputs = with pkgs; lib.optionals stdenv.isDarwin (
            with darwin.apple_sdk.frameworks; [
              IOKit
            ]
          );
        };

        # Add your auto-formatters here.
        # cf. https://numtide.github.io/treefmt/
        treefmt.config = {
          projectRootFile = "flake.nix";
          programs = {
            nixpkgs-fmt.enable = true;
            rustfmt.enable = true;
          };
        };

        devShells.default = with pkgs; mkShell {
          inputsFrom = [ self'.devShells.rust-nix-template ];
          packages = [ cargo-watch ];
        };
        packages.default = self'.packages.rust-nix-template;
      };
    };
}
