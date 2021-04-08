{
  description = "bouncy";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    gitignore = { 
      url = "github:hercules-ci/gitignore"; 
      flake=false; 
    };
    rust-overlay.url = "github:oxalica/rust-overlay";
    crate2nix = {
      url = "github:balsoft/crate2nix/tools-nix-version-comparison";
      flake = false;
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, utils, gitignore, rust-overlay, crate2nix, ... }:
    utils.lib.eachDefaultSystem
      (system:
        let 
          pkgs = import nixpkgs { 
            inherit system; 
            overlays = [ 
              rust-overlay.overlay
              (self: super: {
                # Because rust-overlay bundles multiple rust packages into one
                # derivation, specify that mega-bundle here, so that naersk
                # will use them automatically.
                rustc = self.rust-bin.stable.latest.default;
                cargo = self.rust-bin.stable.latest.default;
              })
            ];
          };
          inherit (import "${crate2nix}/tools.nix" { inherit pkgs; })
            generatedCargoNix;
          inherit (import gitignore { inherit (pkgs) lib; }) gitignoreSource;
          project = pkgs.callPackage (generatedCargoNix {
            name = "bouncy";
            src = gitignoreSource ./.;
          }) {
            # Individual crate overrides go here
            # Example: https://github.com/balsoft/simple-osd-daemons/blob/6f85144934c0c1382c7a4d3a2bbb80106776e270/flake.nix#L28-L50
          };
        in rec {
          packages.bouncy = project.rootCrate.build;

          # `nix build`
          defaultPackage = packages.bouncy;

          # `nix run`
          apps.bouncy = utils.lib.mkApp {
            name = "bouncy";
            drv = packages.bouncy;
          };
          defaultApp = apps.bouncy;

          # `nix develop`
          devShell = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [ rustc cargo ];
            RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
          };
        }
      );
}
