autocmd BufRead,BufNewFile /home/rob/time-tracking/* setf tiddlywiki | match Number /@\w\+\>/
autocmd BufRead,BufNewFile /home/rob/time-tracking/* setlocal undodir=/home/rob/time-tracking/.vim-undo | setlocal undofile
