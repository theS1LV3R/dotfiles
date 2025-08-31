-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local set = vim.keymap.set
local del = vim.keymap.del

-- Setup LuaSnip
local ls = require("luasnip")

set({"i"}, "<Tab>", function() ls.expand() end, {silent = true})
set({"i", "s"}, "<Tab>", function() ls.jump( 1) end, {silent = true})
set({"i", "s"}, "<S-Tab>", function() ls.jump(-1) end, {silent = true})

set({"i", "s"}, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})
