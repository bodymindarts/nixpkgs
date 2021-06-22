colorscheme jellybeans

set hidden
set autoindent
set autoread                       " auto reload when file changes
set autowrite                      " Automatically :write before running commands
set backspace=indent,eol,start     " allow backspace over eol etc.
set colorcolumn=91                 " line width delimiter
set cursorline                     " highlight line at cursor set hlsearch set ignorecase set incsearch
set expandtab                      " use n times <space> instead of <tab>
set foldmethod=manual              " no automatic folding
set hlsearch                       " highlight all search results
set ignorecase                     " ignore case when searching
set incsearch                      " highlight while typing search
set laststatus=2                   " line for status of window
set list                           " show symbols for <eol> and <tab>
set listchars=tab:▸\ ,eol:¬        " set symbols for <eol> and <tab>
set nobackup                       " no backups, no swapfiles
set nofoldenable                   " no automatic folding
set noswapfile                     " no backups, no swapfiles
set nowritebackup                  " no backups, no swapfiles
set number                         " line number
set runtimepath+=~/.vim/xpt-personal
set shiftwidth=2
set showtabline=2                  " always have tab line
set smartcase                      " search is case sensitive when word starts with uppercase
set softtabstop=2
set splitbelow                     " split opens new window below
set splitright                     " vsplit opens new window to the right
set statusline=%f\ %m%r%y%=%3l,%2c
set tabstop=2                      " spaces per tab
set tags+=.git/tags,./.tags
set undodir=~/.config/nvim/undo//
set undofile
set undolevels=1000
set undoreload=10000
set visualbell                     " no beeping
set wildmenu                       " show menu of complete option
let g:vimsyn_embed = 'l'

let mapleader=" "
let maplocalleader=","

nnoremap <cr> :nohlsearch<cr>
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

nnoremap <leader>ev :tabe ~/.config/nixpkgs/programs/neovim/default.nix<cr>
nnoremap <leader>eh :tabe ~/.config/nixpkgs/home.nix<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>ez :tabe ~/.config/nixpkgs/programs/zsh/default.nix<cr>

nnoremap <leader>x :w<cr>:!chmod +x %<cr>:edit!<cr>
nnoremap <leader>m :!mkdir -p %:p:h<cr>
nnoremap <leader>w :w<cr>
inoremap UU <esc>u
inoremap jj <esc>
" Quicker window movement
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
" Quicker open alternate
nnoremap <leader><leader> <c-^>
" split window and reset to last
nnoremap vv <c-w>v<c-w>h<c-^>

function! GetBufferList()
    redir =>buflist
    silent! ls
    redir END
    return buflist
endfunction

function! BufferIsOpen(bufname)
    let buflist = GetBufferList()
    for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
        if bufwinnr(bufnum) != -1
            return 1
        endif
    endfor
    return 0
endfunction

function! ToggleQuickfix()
    if BufferIsOpen("Quickfix List")
        cclose
    else
        call OpenQuickfix()
    endif
endfunction

function! OpenQuickfix()
    botright cwindow
    if &ft == "qf"
        cc
    endif
endfunction

nnoremap <leader>q :call ToggleQuickfix()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>N :call RenameFile()<cr>

lua << EOF
local nvim_lsp = require("lspconfig")
local format_async = function(err, _, result, _, bufnr)
    if err ~= nil or result == nil then return end
    if not vim.api.nvim_buf_get_option(bufnr, "modified") then
        local view = vim.fn.winsaveview()
        vim.lsp.util.apply_text_edits(result, bufnr)
        vim.fn.winrestview(view)
        if bufnr == vim.api.nvim_get_current_buf() then
            vim.api.nvim_command("noautocmd :update")
        end
    end
end
vim.lsp.handlers["textDocument/formatting"] = format_async
_G.lsp_organize_imports = function()
    local params = {
        command = "_typescript.organizeImports",
        arguments = {vim.api.nvim_buf_get_name(0)},
        title = ""
    }
    vim.lsp.buf.execute_command(params)
end
local on_attach = function(client, bufnr)
    local buf_map = vim.api.nvim_buf_set_keymap
    vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
    vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
    vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
    vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
    vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
    vim.cmd("command! LspOrganize lua lsp_organize_imports()")
    vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
    vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
    vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
    vim.cmd("command! LspDiagPrev lua vim.lsp.diagnostic.goto_prev()")
    vim.cmd("command! LspDiagNext lua vim.lsp.diagnostic.goto_next()")
    vim.cmd(
        "command! LspDiagLine lua vim.lsp.diagnostic.show_line_diagnostics()")
    vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")
buf_map(bufnr, "n", "gd", ":LspDef<CR>", {silent = true})
    buf_map(bufnr, "n", "gr", ":LspRename<CR>", {silent = true})
    buf_map(bufnr, "n", "gR", ":LspRefs<CR>", {silent = true})
    buf_map(bufnr, "n", "gy", ":LspTypeDef<CR>", {silent = true})
    buf_map(bufnr, "n", "K", ":LspHover<CR>", {silent = true})
    buf_map(bufnr, "n", "gs", ":LspOrganize<CR>", {silent = true})
    buf_map(bufnr, "n", "[a", ":LspDiagPrev<CR>", {silent = true})
    buf_map(bufnr, "n", "]a", ":LspDiagNext<CR>", {silent = true})
    buf_map(bufnr, "n", "ga", ":LspCodeAction<CR>", {silent = true})
    buf_map(bufnr, "n", "<Leader>a", ":LspDiagLine<CR>", {silent = true})
    buf_map(bufnr, "i", "<C-x><C-x>", "<cmd> LspSignatureHelp<CR>",
              {silent = true})
if client.resolved_capabilities.document_formatting then
        vim.api.nvim_exec([[
         augroup LspAutocommands
             autocmd! * <buffer>
             autocmd BufWritePost <buffer> LspFormatting
         augroup END
         ]], true)
    end
end
nvim_lsp.tsserver.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        on_attach(client)
    end
}
local filetypes = {
    typescript = "eslint",
    typescriptreact = "eslint",
}
local linters = {
    eslint = {
        sourceName = "eslint",
        command = "eslint_d",
        rootPatterns = {".eslintrc.js", "package.json"},
        debounce = 100,
        args = {"--stdin", "--stdin-filename", "%filepath", "--format", "json"},
        parseJson = {
            errorsRoot = "[0].messages",
            line = "line",
            column = "column",
            endLine = "endLine",
            endColumn = "endColumn",
            message = "${message} [${ruleId}]",
            security = "severity"
        },
        securities = {[2] = "error", [1] = "warning"}
    }
}
local formatters = {
    prettier = {command = "prettier", args = {"--stdin-filepath", "%filepath"}}
}
local formatFiletypes = {
    typescript = "prettier",
    typescriptreact = "prettier"
}
nvim_lsp.diagnosticls.setup {
    on_attach = on_attach,
    filetypes = vim.tbl_keys(filetypes),
    init_options = {
        filetypes = filetypes,
        linters = linters,
        formatters = formatters,
        formatFiletypes = formatFiletypes
    }
}
EOF
