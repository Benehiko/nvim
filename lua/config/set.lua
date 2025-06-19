vim.opt.wrap = false
vim.opt.signcolumn = "yes:2"
vim.opt.colorcolumn = "80"
vim.opt.updatetime = 50
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.mouse = "nv" -- Enable mouse in normal and visual modes only

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		local winid = vim.api.nvim_get_current_win()

		-- Detect floating window
		local ok, config = pcall(vim.api.nvim_win_get_config, winid)
		if ok and config.relative ~= "" then
			-- Set <Esc> to close this floating window
			vim.keymap.set("n", "<Esc>", function()
				if vim.api.nvim_win_is_valid(winid) then
					vim.api.nvim_win_close(winid, true)
				end
			end, { buffer = bufnr, silent = true })
		end
	end,
})
