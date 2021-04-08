{
  description = "bouncy";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    gitignore = { 
      url = "github:hercules-ci/gitignore"; 
      flake=false; 
    };
    crate2nix = {
      url = "github:balsoft/crate2nix/tools-nix-version-comparison";
      flake = false;
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, utils, gitignore, crate2nix, ... }:
    utils.lib.eachDefaultSystem
      (system:
        let 
          pkgs = import nixpkgs { inherit system; };
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
          packages = builtins.mapAttrs (name: member: member.build) project.workspaceMembers;
        in rec {
          inherit packages;

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
