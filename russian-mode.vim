function! RussianModeEnable()
  augroup RussianMode
    autocmd!

    autocmd InsertLeave * call RussianModeDisable()
  augroup END

  inoremap <nowait> <buffer> q й
  inoremap <nowait> <buffer> w ц
  inoremap <nowait> <buffer> e у
  inoremap <nowait> <buffer> r к
  inoremap <nowait> <buffer> t е
  inoremap <nowait> <buffer> y н
  inoremap <nowait> <buffer> u г
  inoremap <nowait> <buffer> i ш
  inoremap <nowait> <buffer> o щ
  inoremap <nowait> <buffer> p з
  inoremap <nowait> <buffer> [ х
  inoremap <nowait> <buffer> ] ъ
  inoremap <nowait> <buffer> a ф
  inoremap <nowait> <buffer> s ы
  inoremap <nowait> <buffer> d в
  inoremap <nowait> <buffer> f а
  inoremap <nowait> <buffer> g п
  inoremap <nowait> <buffer> h р
  inoremap <nowait> <buffer> j о
  inoremap <nowait> <buffer> k л
  inoremap <nowait> <buffer> l д
  inoremap <nowait> <buffer> ; ж
  inoremap <nowait> <buffer> ' э
  inoremap <nowait> <buffer> z я
  inoremap <nowait> <buffer> x ч
  inoremap <nowait> <buffer> c с
  inoremap <nowait> <buffer> v м
  inoremap <nowait> <buffer> b и
  inoremap <nowait> <buffer> n т
  inoremap <nowait> <buffer> m ь
  inoremap <nowait> <buffer> , б
  inoremap <nowait> <buffer> . ю
  inoremap <nowait> <buffer> / .

  inoremap <nowait> <buffer> Q Й
  inoremap <nowait> <buffer> W Ц
  inoremap <nowait> <buffer> E У
  inoremap <nowait> <buffer> R К
  inoremap <nowait> <buffer> T Е
  inoremap <nowait> <buffer> Y Н
  inoremap <nowait> <buffer> U Г
  inoremap <nowait> <buffer> I Ш
  inoremap <nowait> <buffer> O Щ
  inoremap <nowait> <buffer> P З
  inoremap <nowait> <buffer> { Х
  inoremap <nowait> <buffer> } Ъ
  inoremap <nowait> <buffer> A Ф
  inoremap <nowait> <buffer> S Ы
  inoremap <nowait> <buffer> D В
  inoremap <nowait> <buffer> F А
  inoremap <nowait> <buffer> G П
  inoremap <nowait> <buffer> H Р
  inoremap <nowait> <buffer> J О
  inoremap <nowait> <buffer> K Л
  inoremap <nowait> <buffer> L Д
  inoremap <nowait> <buffer> : Ж
  inoremap <nowait> <buffer> " Э
  inoremap <nowait> <buffer> Z Я
  inoremap <nowait> <buffer> X Ч
  inoremap <nowait> <buffer> C С
  inoremap <nowait> <buffer> V М
  inoremap <nowait> <buffer> B И
  inoremap <nowait> <buffer> N Т
  inoremap <nowait> <buffer> M Ь
  inoremap <nowait> <buffer> < Б
  inoremap <nowait> <buffer> > Ю
  inoremap <nowait> <buffer> ? ,
endfunction

function! RussianModeDisable()
  augroup RussianMode
    autocmd!
  augroup END

  iunmap <buffer> q
  iunmap <buffer> w
  iunmap <buffer> e
  iunmap <buffer> r
  iunmap <buffer> t
  iunmap <buffer> y
  iunmap <buffer> u
  iunmap <buffer> i
  iunmap <buffer> o
  iunmap <buffer> p
  iunmap <buffer> [
  iunmap <buffer> ]
  iunmap <buffer> a
  iunmap <buffer> s
  iunmap <buffer> d
  iunmap <buffer> f
  iunmap <buffer> g
  iunmap <buffer> h
  iunmap <buffer> j
  iunmap <buffer> k
  iunmap <buffer> l
  iunmap <buffer> ;
  iunmap <buffer> '
  iunmap <buffer> z
  iunmap <buffer> x
  iunmap <buffer> c
  iunmap <buffer> v
  iunmap <buffer> b
  iunmap <buffer> n
  iunmap <buffer> m
  iunmap <buffer> ,
  iunmap <buffer> .
  iunmap <buffer> /

  iunmap <buffer> Q
  iunmap <buffer> W
  iunmap <buffer> E
  iunmap <buffer> R
  iunmap <buffer> T
  iunmap <buffer> Y
  iunmap <buffer> U
  iunmap <buffer> I
  iunmap <buffer> O
  iunmap <buffer> P
  iunmap <buffer> {
  iunmap <buffer> }
  iunmap <buffer> A
  iunmap <buffer> S
  iunmap <buffer> D
  iunmap <buffer> F
  iunmap <buffer> G
  iunmap <buffer> H
  iunmap <buffer> J
  iunmap <buffer> K
  iunmap <buffer> L
  iunmap <buffer> :
  iunmap <buffer> "
  iunmap <buffer> Z
  iunmap <buffer> X
  iunmap <buffer> C
  iunmap <buffer> V
  iunmap <buffer> B
  iunmap <buffer> N
  iunmap <buffer> M
  iunmap <buffer> <
  iunmap <buffer> >
  iunmap <buffer> ?
endfunction

nnoremap R :call RussianModeEnable() <Bar> :startinsert<CR>
