{
  description = "bouncy";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    crate2nix = {
      url = "github:balsoft/crate2nix/tools-nix-version-comparison";
      flake = false;
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, utils, crate2nix, ... }:
    utils.lib.eachDefaultSystem
      (system:
        let 
          pkgs = import nixpkgs { inherit system; };
          inherit (import "${crate2nix}/tools.nix" { inherit pkgs; })
            generatedCargoNix;
          project = pkgs.callPackage (generatedCargoNix {
            name = "bouncy";
            src = ./.;
          }) {
            # Overrides go here
          };
          membersList = builtins.attrValues (builtins.mapAttrs (name: member: {
            inherit name;
            value = member.build;
          }) project.workspaceMembers);
          # naersk-lib = naersk.lib."${system}";
        in rec {
          packages = builtins.listToAttrs membersList;

          defaultPackage = packages.bouncy;

          # `nix develop`
          devShell = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [ rustc cargo ];
            RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
            inputsFrom = builtins.attrValues packages.bouncy;
          };
        }
      );
}
