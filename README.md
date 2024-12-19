A template Rust project with fully functional and no-frills Nix support, as well as builtin VSCode configuration to get IDE experience without any manual setup (just [install direnv](https://nixos.asia/en/direnv), open in VSCode and accept the suggestions). It uses [crane](https://crane.dev/), via [rust-flake](https://github.com/juspay/rust-flake).

> [!NOTE]
> If you are looking for the original template based on [this blog post](https://srid.ca/rust-nix)'s use of `crate2nix`, browse from [this tag](https://github.com/srid/rust-nix-template/tree/crate2nix). The evolution of this template can be gleaned from [releases](https://github.com/srid/rust-nix-template/releases).

## Usage

You can use [omnix](https://omnix.page/om/init.html)[^omnix] to initialize this template:
```
nix --accept-flake-config run github:juspay/omnix -- init github:srid/rust-nix-template -o ~/my-rust-project
```

[^omnix]: If initializing manually, make sure to:
    - Change `name` in Cargo.toml.
    - Run `cargo generate-lockfile` in the nix shelld

## Adapting this template

- There are two CI workflows, and one of them uses Nix which is slower (unless you configure a cache) than the other one based on rustup. Pick one or the other depending on your trade-offs.

## Development (Flakes)

This repo uses [Flakes](https://nixos.asia/en/flakes) from the get-go.

```bash
# Dev shell
nix develop

# or run via cargo
nix develop -c cargo run

# build
nix build
```

We also provide a [`justfile`](https://just.systems/) for Makefile'esque commands to be run inside of the devShell.

## Tips

- Run `nix flake update` to update all flake inputs.
- Run `nix --accept-flake-config run github:juspay/omnix ci` to build _all_ outputs.
- [pre-commit] hooks will automatically be setup in Nix shell. You can also run `pre-commit run -a` manually to run the hooks (e.g.: to autoformat the project tree using `rustfmt`, `nixpkgs-fmt`, etc. as well run programs like `cargo check`).

## Discussion

- [Zulip](https://nixos.zulipchat.com/#narrow/stream/413950-nix)

## See Also

- [nixos.wiki: Packaging Rust projects with nix](https://nixos.wiki/wiki/Rust#Packaging_Rust_projects_with_nix)
