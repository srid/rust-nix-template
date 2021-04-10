A template Rust project with fully functional and no-frills Nix support, as well as builtin VSCode configuration to get IDE support without doing anything (open in VSCode and accept the suggestions).

## Adapting this template

Change `name` in Cargo.toml and flake.nix. Also change `description` in flake.nix.

## Development (Flakes)

This repo uses [Flakes](https://nixos.wiki/wiki/Flakes) from the get-go, but compat is provided for traditional nix-shell/nix-build as well (see the section below).

```
# Dev shell
nix develop

# or just run directly
nix run

# or run via cargo
nix develop -c cargo run

# build
nix build
```

## Development (Legacy Nix)

```
# Dev shell
nix-shell

# run via cargo
nix-shell --run 'cargo run'

# build
nix-build
```
