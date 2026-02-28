-- Relative line numbers
vim.opt.relativenumber = true

-- Mouse support
vim.opt.mouse = "a"

-- Better splitting
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Undo file
vim.opt.undofile = true

-- Faster completion
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Show whitespace
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live
vim.opt.inccommand = "split"

-- Highlight cursor line
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below cursor
vim.opt.scrolloff = 10
