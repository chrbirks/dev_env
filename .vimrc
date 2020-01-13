" Use Powerline for vim
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
" Make sure powerline is always enabled
set laststatus=2
let g:powerline_pycmd='py3'
"set rtp+=/usr/lib/python3/dist-packages/powerline/bindings/vim
"        /usr/lib/python2.7/dist-packages/powerline/bindings

" Automatic installation of vim-plug plugin manager
if empty(glob('~/.vim/autoload/plug.vim'))
   silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
   \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" List of plugins
call plug#begin('~/.vim/plugged')
Plug 'drewtempelmeyer/palenight.vim'
Plug 'ayu-theme/ayu-vim'
call plug#end()

" Use correct colors together with tmux
if exists('+termguicolors')
   let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
   let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
   set termguicolors
endif

" " fixes glitch? in colors when using vim with tmux
" set t_Co=256

" Set theme
set background=dark
colorscheme palenight
" let g:lightline.colorscheme = 'palenight'
" let g:airline_theme = "palenight"

" Italics for my favorite color scheme
" let g:palenight_terminal_italics=1


"---------------------------------------
" set termguicolors     " enable true colors support
" let ayucolor="light"  " for light version of theme
" let ayucolor="mirage" " for mirage version of theme
" let ayucolor="dark"   " for dark version of theme
" colorscheme ayu
