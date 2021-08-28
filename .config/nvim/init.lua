local chad_modules = {
    "options",
    "mappings"
}

for i = 1, #chad_modules, 1 do
    pcall(require, chad_modules[i])
end

-- local cmd = vim.cmd
-- local g = vim.g
-- 
-- g.mapleader = " "
-- g.auto_save = 0
-- 
-- -- colorscheme related stuff
-- cmd "syntax on"
-- cmd "10new +terminal | setlocal nobuflisted"
-- cmd "NvimTreeToggle"
