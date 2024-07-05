source $VIMRUNTIME/defaults.vim

set number
set noswapfile
set visualbell

set tabstop=2
set shiftwidth=2
set expandtab

set path=**
cnoreabbrev E Explore

set hlsearch
noremap <C-l> <Cmd>nohlsearch<CR><C-l>

colorscheme habamax

let jetpack_dir = expand('~/.vim/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim')
if !filereadable(jetpack_dir)
  echomsg 'Installing vim-jetpack...'
  let jetpack_url = 'https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim'
  call system('curl -fLo ' . jetpack_dir . ' --create-dirs ' . jetpack_url)
endif
packadd vim-jetpack

call jetpack#begin()

Jetpack 'tani/vim-jetpack', {'opt': 1}

Jetpack 'github/copilot.vim'
Jetpack 'madox2/vim-ai'

Jetpack 'yegappan/lsp'
Jetpack 'yegappan/mru'
Jetpack 'yegappan/grep'

call jetpack#end()

let g:copilot_filetypes = {
      \ '*': v:true,
      \ }

nmap <space>h <Cmd>MRU<CR>
" brew install ripgrep
nmap <space>r <Cmd>Rg<CR>

set signcolumn=yes
nmap ]g <Cmd>LspDiag next<CR>
nmap [g <Cmd>LspDiag prev<CR>

function s:lsp_on_attached() abort
  setlocal tagfunc=lsp#lsp#TagFunc

  nmap <buffer> ga <Cmd>LspCodeAction<CR>
  nmap <buffer> rn <Cmd>LspRename<CR>
  nmap <buffer> gr <Cmd>LspPeekReferences<CR>
  nmap <buffer> gi <Cmd>LspGotoImpl<CR>
  nmap <buffer> <space>q <Cmd>LspDiagShow<CR>
  nmap <buffer> K <Cmd>LspHover<CR>
  nmap <buffer> <leader>o <Cmd>LspOutline<CR>

  augroup lsp_format
    autocmd!

    autocmd BufWritePre *.go,*.ts,*.tsx :LspFormat
  augroup END
endfunction

augroup lsp
  autocmd!

  autocmd User LspAttached call s:lsp_on_attached()

  autocmd User LspSetup call LspOptionsSet(#{
        \   outlineWinSize: 80,
        \ })

  autocmd User LspSetup call LspAddServer([
        \   #{
        \     name: 'gopls',
        \     filetype: ['go'],
        \     path: 'gopls',
        \     args: ['serve'],
        \   },
        \   #{
        \     name: 'vimls',
        \     filetype: ['vim'],
        \     path: 'vim-language-server',
        \     args: ['--stdio'],
        \   },
        \   #{
        \     name: 'tsserver',
        \     filetype: ['typescript', 'typescriptreact'],
        \     path: 'typescript-language-server',
        \     args: ['--stdio'],
        \   },
        \   #{
        \     name: 'terraform',
        \     filetype: ['terraform'],
        \     path: 'terraform-ls',
        \     args: ['serve'],
        \   }
        \ ])

"""     \   #{
"""     \     name: 'prisma-language-server',
"""     \     filetype: ['prisma'],
"""     \     path: 'prisma-language-server',
"""     \     args: ['--stdio'],
"""     \   },

augroup END

let g:aichat_openai_api_key = readfile(expand("~/.config/openai.token"))[0]

let s:initial_chat_prompt =<< trim END
  >>> system

  You are a great web developer.
  If you attach a code block add syntax type after ``` to enable syntax highlighting.
  Answer my question in Japanese.
END

let g:vim_ai_chat = {
      \   "options": {
      \     "model": "gpt-4o",
      \     "temperature": 0.2,
      \     "initial_prompt": s:initial_chat_prompt,
      \   },
      \ }

let g:vim_ai_complete = {
      \   "options": {
      \     "model": "gpt-3.5-turbo-instruct",
      \     "temperature": 0.2,
      \   },
      \ }
