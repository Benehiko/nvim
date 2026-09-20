# NeoVim configs

## Quickstart

```console
cd ~/.config
git clone git@github.com:Benehiko/nvim.git
```

### Requirements

- [Neovim](https://neovim.io/) 
- [Nerdfonts](https://www.nerdfonts.com/)
- [RipGrep](https://github.com/BurntSushi/ripgrep)
- [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter) (for parser builds)

## Tests

Headless regression tests live in `tests/`. They check that the config starts
clean and that treesitter parsers load for the languages in use.

```console
tests/run.sh            # run tests
tests/run.sh --update   # update parsers first, then run tests
```

The suite exits non-zero on failure, so it works as a pre-commit or CI check.

