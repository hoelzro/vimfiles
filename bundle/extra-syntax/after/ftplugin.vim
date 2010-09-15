au BufNewFile,BufRead *.tt2 setf tt2html
au BufNewFile,BufRead SConstruct,SConscript,wscript,wscript_build setf python
au BufNewFile,BufRead *.p6 setf perl6
au FileType c 2match Search /\%>78v./
au FileType perl 2match Search /\%>78v./

let b:tt2_syn_tags = '\[% %] <!-- -->'
