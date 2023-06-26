{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";

    # Rust
    dream2nix.url = "github:nix-community/dream2nix";

    # Dev tools
    treefmt-nix.url = "github:numtide/treefmt-nix";
    mission-control.url = "github:Platonic-Systems/mission-control";
    flake-root.url = "github:srid/flake-root";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        inputs.dream2nix.flakeModuleBeta
        inputs.treefmt-nix.flakeModule
        inputs.mission-control.flakeModule
        inputs.flake-root.flakeModule
      ];
      perSystem = { config, self', pkgs, lib, system, ... }: {
        # Rust project definition
        # cf. https://github.com/nix-community/dream2nix
        dream2nix.inputs."rust-nix-template" = {
          source = lib.sourceFilesBySuffices ./. [
            ".rs"
            "Cargo.toml"
            "Cargo.lock"
          ];
          projects."rust-nix-template" = { name, ... }: {
            inherit name;
            subsystem = "rust";
            translator = "cargo-lock";
          };
        };

        # Flake outputs
        packages = config.dream2nix.outputs.rust-nix-template.packages;
        devShells.default = pkgs.mkShell {
          inputsFrom = [
            config.dream2nix.outputs.rust-nix-template.devShells.default
            config.treefmt.build.devShell
            config.mission-control.devShell
            config.flake-root.devShell
          ];
          shellHook = ''
            # For rust-analyzer 'hover' tooltips to work.
            export RUST_SRC_PATH=${pkgs.rustPlatform.rustLibSrc}
          '';
          nativeBuildInputs = [
            pkgs.cargo-watch
            pkgs.rust-analyzer
          ];
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

        # Makefile'esque but in Nix. Add your dev scripts here.
        # cf. https://github.com/Platonic-Systems/mission-control
        mission-control.scripts = {
          fmt = {
            exec = config.treefmt.build.wrapper;
            description = "Auto-format project tree";
          };

          run = {
            exec = ''cargo run'';
            description = "Run the project executable";
          };

          watch = {
            exec = ''cargo watch -x run'';
            description = "Watch for changes and run the project executable";
          };
        };
      };
    };
}
