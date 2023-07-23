A template Rust project with fully functional and no-frills Nix support, as well as builtin VSCode configuration to get IDE experience without any manual setup (just open in VSCode and accept the suggestions).

Note: If you are looking for the original template based on [this blog post](https://srid.ca/rust-nix)'s use of `crate2nix`, browse from [this tag](https://github.com/srid/rust-nix-template/tree/crate2nix).

## Adapting this template

- Run `nix develop` to have a working shell ready before name change (Workaround for [an issue](https://github.com/srid/rust-nix-template/issues/7#issuecomment-1097182528)
- Change `name` in Cargo.toml and flake.nix. Also change `description` in flake.nix.
- Run `cargo generate-lockfile` in the nix shell
- There are two CI workflows, and one of them uses Nix which is slower (unless you configure a cache) than the other that is based on rustup. Pick one or the other depending on your trade-offs.

## Development (Flakes)

This repo uses [Flakes](https://nixos.wiki/wiki/Flakes) from the get-go.

```bash
# Dev shell
nix develop

# or run via cargo
nix develop -c cargo run

# build
nix build
```

There are also [mission-control](https://github.com/Platonic-Systems/mission-control) shell commands provided in the devShell.
