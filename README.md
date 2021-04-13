A template Rust project with fully functional and no-frills Nix support, as well as builtin VSCode configuration to get IDE support without doing anything (open in VSCode and accept the suggestions).

See [Nix-ifying Rust projects](https://notes.srid.ca/rust-nix) for details.

## Adapting this template

- Change `name` in Cargo.toml and flake.nix. Also change `description` in flake.nix.
- There are two CI workflows, and one of them uses Nix which is slower (unless you configure a cache) than the other that is based on rustup. Pick one or the other depending on your trade-offs.

## Development (Flakes)

This repo uses [Flakes](https://nixos.wiki/wiki/Flakes) from the get-go, but compat is provided for traditional nix-shell/nix-build as well (see the section below).

```bash
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

```bash
# Dev shell
nix-shell

# run via cargo
nix-shell --run 'cargo run'

# build
nix-build
```

There is a also a `bin/run` script which starts 'cargo watch'; and it is used by VSCode as well (`Ctrl+Shift+B`).
