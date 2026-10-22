-- lazy.nvim
return {
	"chrisgrieser/nvim-origami",
	commit = "4a76d70a23b59ec082eb370821cd33d988d99568",
	event = "BufReadPost",
	config = function()
		require("config.origami")
	end,
}
