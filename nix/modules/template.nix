{ inputs, ... }:

{
  flake.templates.default = {
    description = "A batteries-included Rust project template for Nix";
    path = builtins.path { path = inputs.self; };
  };
}
