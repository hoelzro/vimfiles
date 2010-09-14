au BufNewFile,BufRead *.tt2 setf tt2html
au BufNewFile,BufRead SConstruct,SConscript,wscript,wscript_build setf python
au BufNewFile,BufRead *.p6 setf perl6
au filetype man 2match none

let b:tt2_syn_tags = '\[% %] <!-- -->'
