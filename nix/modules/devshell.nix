{ inputs, ... }:
{
  perSystem = { config, self', pkgs, lib, ... }: {
    devShells.default = pkgs.mkShell {
      inputsFrom = [
        self'.devShells.rust
        config.treefmt.build.devShell
      ];
      packages = [
        pkgs.cargo-watch
        config.process-compose.cargo-doc-live.outputs.package
      ];
    };
  };
}
