local g = vim.g
local o = vim.o

-- Number of screen lines to keep above and below the cursor
o.scrolloff = 8

o.number = true
o.relativenumber = true
o.cursorline = true

-- o.termguicolors = true

-- Better editing experience
o.smartindent = true
o.noexpandtab = true
o.tabstop = 4
o.shiftwidth = 4
o.wrap = true

-- Display whitespace characters
o.listchars = [[eol:¬,tab:>=,trail:~,extends:>,precedes:<,space:·]]
o.list = true

-- folding blocks
-- o.foldmethod = 'indent'
o.foldmarker = '{,}'
-- o.foldlevel = 2

-- Makes neovim and host OS clipboard play nicely with each other
o.clipboard = 'unnamedplus'

-- Undo and backup options
o.backup = false
o.writebackup = false
o.undofile = false
o.swapfile = false
-- o.backupdir = '/tmp/'
-- o.directory = '/tmp/'
-- o.undodir = '/tmp/'

-- Remember 32 items in commandline history
o.history = 32

-- Map <leader> to space
g.mapleader = ' '
g.maplocalleader = ' '
