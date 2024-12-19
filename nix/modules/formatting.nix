{ inputs, ... }:
{
  imports = [
    (inputs.git-hooks + /flake-module.nix)
    inputs.treefmt-nix.flakeModule
  ];
  perSystem = { config, self', pkgs, lib, ... }: {
    pre-commit.settings = {
      hooks = {
        nixpkgs-fmt.enable = true;
        rustfmt.enable = true;
        cargo-check.enable = true;
      };
    };

    # Add your auto-formatters here.
    # cf. https://nixos.asia/en/treefmt
    treefmt.config = {
      projectRootFile = "flake.nix";
      programs = {
        nixpkgs-fmt.enable = true;
        rustfmt.enable = true;
      };
    };
  };
}
