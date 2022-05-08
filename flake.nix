# This file is pretty general, and you can adapt it in your project replacing
# only `name` and `description` below.

{
  description = "My awesome Rust project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    nci.url = "github:yusdacra/nix-cargo-integration";
    nci.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nci, ... }:
    nci.lib.makeOutputs {
      # Documentation and examples:
      # https://github.com/yusdacra/rust-nix-templater/blob/master/template/flake.nix
      root = ./.;
      overrides = {
        shell = common: prev: {
          packages = prev.packages ++ [
            common.pkgs.rust-analyzer
            common.pkgs.cargo-watch
          ];
        };
      };
    };
}
