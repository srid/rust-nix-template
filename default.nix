let 
    pkgs = import ./dep/nixpkgs { overlays = [ (import ./dep/rust-overlay) ]; };
    rust = pkgs.rust-bin.stable.latest.rust;
in 
    pkgs.mkShell {
        buildInputs = [
            rust
        ];
    }
