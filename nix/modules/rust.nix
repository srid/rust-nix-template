{ inputs, ... }:
{
  imports = [
    inputs.rust-flake.flakeModules.default
    inputs.rust-flake.flakeModules.nixpkgs
  ];
  perSystem = { config, self', pkgs, lib, ... }: {
    rust-project.crates."rust-nix-template".crane.args = {
      # On darwin, you may need framework dependencies like IOKit.
      # The default SDK now provides these automatically - no need to specify them.
      # buildInputs = lib.optionals pkgs.stdenv.isDarwin [ pkgs.apple-sdk ];
    };
    packages.default = self'.packages.rust-nix-template;
  };
}
