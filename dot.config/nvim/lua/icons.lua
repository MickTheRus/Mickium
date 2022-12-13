local M = {
	Add = " ",
	Array = " ",
	ArrowDown = " ",
	ArrowLeft = " ",
	ArrowRight = " ",
	ArrowUp = " ",
	BigCircle = " ",
	BigUnfilledCircle = " ",
	BookMark = " ",
	Boolean = " ",
	Branch = " ",
	Buffer = "﬘ ",
	Bug = " ",
	Calendar = "  ",
	Check = " ",
	ChevronDown = " ",
	ChevronLeft = " ",
	ChevronRight = " ",
	ChevronUp = " ",
	Circle = " ",
	Class = " ",
	Close = "",
	CloseAll = " ",
	Code = " ",
	Collapsed = " ",
	Color = " ",
	Comment = " ",
	Constant = " ",
	Constructor = " ",
	Copilot = " ",
	Create = " ",
	Dashboard = " ",
	Diff = " ",
	Enum = " ",
	EnumMember = " ",
	Error = " ",
	Event = " ",
	Field = "ﴲ ",
	File = " ",
	Fire = " ",
	Folder = " ",
	Function = " ",
	Gear = " ",
	Goto = " ",
	Hint = " ",
	History = " ",
	Ignore = " ",
	Information = " ",
	Interface = " ",
	Key = " ",
	Keyword = " ",
	Lightbulb = " ",
	List = " ",
	Lock = " ",
	Menu = " ",
	Method = " ",
	Misc = " ",
	Mod = " ",
	Module = " ",
	Namespace = " ",
	NewFile = " ",
	NoHighlight = " ",
	Note = " ",
	Null = " ",
	Number = " ",
	NvimTree = " ",
	Object = " ",
	OpenFolder = " ",
	Operator = " ",
	Package = " ",
	Pencil = " ",
	Project = " ",
	Property = "凌 ",
	Question = " ",
	Reference = " ",
	Remove = " ",
	Rename = " ",
	Repo = " ",
	Robot = "ﮧ ",
	Rocket = " ",
	Save = " ",
	Search = " ",
	SearchCode = " ",
	SignIn = " ",
	SignOut = " ",
	Snippet = " ",
	Squirrel = " ",
	String = " ",
	Struct = " ",
	SymlinkFile = " ",
	SymlinkFolder = " ",
	Table = " ",
	Tag = " ",
	Telescope = " ",
	Terminal = " ",
	Text = " ",
	TypeParameter = " ",
	Unit = " ",
	Untracked = " ",
	Value = " ",
	Variable = " ",
	Warning = " ",
	Watch = " ",
	Window = " ",
}

local unspaced = {}

for name, icon in pairs(M) do
	unspaced[name] = icon:sub(1, -2)
end

M.unspaced = unspaced

return M