#!/usr/bin/env bash
# Run the headless test suite against this Neovim config.
#
#   tests/run.sh            # run tests
#   tests/run.sh --update   # also update installed treesitter parsers first
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "${1:-}" == "--update" ]]; then
	NVIM_CONFIG_ROOT="$root" nvim --headless -u "$root/init.lua" \
		"+lua vim.fn.system('true'); require('nvim-treesitter').update():wait(300000)" \
		"+qa!" >/dev/null
fi

NVIM_CONFIG_ROOT="$root" nvim --headless -u "$root/init.lua" "+lua dofile('$root/tests/run.lua')"