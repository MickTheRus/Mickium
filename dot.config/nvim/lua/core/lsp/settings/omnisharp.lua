return { -- see ~/.omnisharp/omnisharp.json
	handlers = {
		["textDocument/definition"] = require("omnisharp_extended").handler,
	},
}
