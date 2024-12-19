default:
    @just --list

# Auto-format the source tree
fmt:
    treefmt

# Runs pre-commit
pre-commit:
	pre-commit run -a

# Run 'cargo run' on the project
run *ARGS:
    cargo run {{ARGS}}

# Run 'bacon' to run the project (auto-recompiles)
watch *ARGS:
	bacon --job run -- -- {{ ARGS }}
