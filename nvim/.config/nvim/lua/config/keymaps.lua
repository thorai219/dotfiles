-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap.set

local function keymapOptions(desc)
  return {
    noremap = true,
    silent = true,
    nowait = true,
    desc = desc,
  }
end

-- Exit to normal mode quickly
keymap("i", "kj", "<Esc>", keymapOptions(""))
keymap("v", "kj", "<Esc>", keymapOptions(""))
