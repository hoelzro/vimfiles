augroup FileTypes
  autocmd!

  autocmd BufNewFile,BufRead *.tt2 setf tt2html
  autocmd BufNewFile,BufRead SConstruct,SConscript,wscript,wscript_build setf python
  autocmd BufNewFile,BufRead *.p6 setf perl6
  autocmd BufNewFile,BufRead /etc/lighttpd/*.conf,lighttpd.conf set filetype=lighttpd
  autocmd FileType c 2match Annoyance /\%>78v./
  autocmd FileType perl 2match Annoyance /\%>78v./
  autocmd FileType perl setlocal equalprg=perltidy
  autocmd BufRead,BufNewFile *.psgi set filetype=perl
  autocmd BufRead,BufNewFile *.html.epl set filetype=epl
  autocmd BufRead,BufNewFile *.html.ep set filetype=epl
  autocmd BufRead,BufNewFile /etc/nginx/* set filetype=nginx
  autocmd BufRead,BufNewFile *.rockspec set filetype=lua
  autocmd BufRead,BufNewFile .tmux.conf set filetype=tmux
  autocmd BufRead,BufNewFile bash-* set filetype=sh " for CTRL-X CTRL-E
  autocmd BufRead,BufNewFile *.t setf  perl
  autocmd BufRead,BufNewFile *.qml set filetype=qml

  " not really a filetype, but ¯\_(ツ)_/¯
  autocmd BufRead,BufNewFile *.log set buftype=nofile
augroup END

" disable setting filetype=zsh when I do things like `vim =(ls)`
autocmd! filetypedetect BufNewFile,BufRead zsh*

let b:tt2_syn_tags = '\[% %] <!-- -->'
