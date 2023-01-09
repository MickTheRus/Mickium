vim.g.coq_settings = {
	["auto_start"] = "shut-up",
	["match.unifying_chars"] = { "-", "_" },
	["clients.lsp.weight_adjust"] = 1.3,
}

local coq = require("coq")
coq.Now()
