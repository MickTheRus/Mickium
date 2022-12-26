local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
	return
end

dap.adapters.coreclr = {
	type = "executable",
	command = vim.fn.expandcmd("~/.local/share/nvim/mason/bin/netcoredbg"),
	args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
	{
		type = "coreclr",
		name = "launch - netcoredbg",
		request = "launch",
		program = function()
			return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/net*/*.dll", "file")
		end,
	},
}
