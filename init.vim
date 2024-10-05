" Specify where Vim-Plug plugins will be stored
call plug#begin('~/.local/share/nvim/plugged')

" Theme: Catppuccin
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

" File explorer: NvimTree
Plug 'kyazdani42/nvim-tree.lua'

" Syntax highlighting and more: Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" LSP for JavaScript and TypeScript
Plug 'neovim/nvim-lspconfig'

" Icons for file types
Plug 'kyazdani42/nvim-web-devicons'

" Lualine for breadcrumbs and statusline
Plug 'nvim-lualine/lualine.nvim'

" Autocompletion engine
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

" Snippet engine for autocompletion
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" Bracket auto-completion
Plug 'windwp/nvim-autopairs'

" Vim-Test for running tests
Plug 'vim-test/vim-test'

" Vim-Commentary for code commenting
Plug 'tpope/vim-commentary'

" Smart refactor
Plug 'nvim-treesitter/nvim-treesitter-refactor'

" Neogit for Git integration
Plug 'nvim-lua/plenary.nvim'  " Required dependency
Plug 'TimUntersberger/neogit'

call plug#end()

" Enable true color support
set termguicolors

" Enable relative and absolute line numbers
set relativenumber
set number

" Set colorscheme to Catppuccin
colorscheme catppuccin

" Basic keybindings for better navigation
nnoremap <C-n> :NvimTreeToggle<CR>

" Remap <leader> to space
let mapleader = " "

" Keybinding to open Neogit
nnoremap <leader>g :Neogit<CR>

" Set up Vim-Test to use Jest
let test#javascript#jest#executable = 'npm test --'
let test#javascript#jest#file_pattern = '\v(test|spec)\.js$'

" Force the test runner to be Jest
let test#javascript#runner = 'jest'

" Set the strategy to Neovim terminal for test execution
let test#strategy = 'neovim'

" Vim-Test keybindings for running tests
nnoremap <silent> <leader>t :TestNearest<CR>
nnoremap <silent> <leader>T :TestFile<CR>
nnoremap <silent> <leader>r :TestLast<CR>
nnoremap <silent> <leader>a :TestSuite<CR>

" Set up NvimTree (file explorer)
lua << EOF
require'nvim-tree'.setup {}
EOF

" Set up Treesitter for enhanced syntax highlighting
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "javascript", "typescript" }, -- Install JavaScript and TypeScript parsers
  highlight = { enable = true }, -- Enable syntax highlighting
}
EOF

" Set up LSP for JavaScript and TypeScript using ts_ls
lua << EOF
require'lspconfig'.ts_ls.setup{}
EOF

" Set up Lualine for breadcrumbs and statusline
lua << EOF
require('lualine').setup {
  options = {
    theme = 'auto',  -- Use current theme colors
    section_separators = {'', ''},
    component_separators = {'', ''},
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {
      {'filename', path = 1},  -- Show full path for breadcrumbs
    },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
}
EOF

" Autocompletion setup
lua << EOF
local cmp = require'cmp'
local luasnip = require'luasnip'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/`
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for `:`
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
EOF

" Auto bracket completion setup
lua << EOF
require('nvim-autopairs').setup{}
EOF

" Smart refactor config
lua << EOF
require'nvim-treesitter.configs'.setup {
  refactor = {
    highlight_definitions = { enable = true },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "gr",  -- Rename keybinding
      },
    },
  },
}
EOF

" Neogit configuration
lua << EOF
require('neogit').setup{}
EOF

" Enter brackets after insertion
inoremap { {}<Left>
inoremap ( ()<Left>
inoremap [ []<Left>

" Copy current line and paste below in insert mode
inoremap <C-d> <Esc>YpA

" Remap window navigation to simpler keys
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Keybinding to swap contents of vertical splits
nnoremap <leader>s :wincmd r<CR>

" Keybinding to highlight all with Ctrl-a
nnoremap <C-a> ggVG

" Indent selected lines with Tab in Visual Mode
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Set the width of a tab character to 4 spaces
set tabstop=4

" Number of spaces that a <Tab> in the file counts for
set shiftwidth=4

" Use spaces instead of tabs
set expandtab

" Make <Tab> behave like 4 spaces
set softtabstop=4

" Allow screen to scroll past bottom of file
set virtualedit=onemore

" Automatically change the working directory to the file's directory
autocmd BufEnter * silent! lcd %:p:h

" Set directory for swap files
set directory=~/.config/nvim/swap//

" Set directory for backup files
set backupdir=~/.config/nvim/backup//

" Set directory for undo files
set undodir=~/.config/nvim/undo//
set undofile

" Allow insert highlighting and Ctrl-C/Ctrl-V
set mouse=a
set clipboard=unnamedplus
