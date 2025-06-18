-- lazy.nvim
return {
	"chrisgrieser/nvim-origami",
	event = "BufReadPost",
	config = function()
		require("config.origami")
	end,
}
