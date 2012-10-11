function! InsertHeader()
  if !exists('b:comment_char')
    let b:comment_char = input("What's the comment character for the language in which you're working? ")
  endif

  let text = input('Header: ')
  let len = strlen(text)

  let len = len + 2
  let padding = repeat(b:comment_char, (80 - len) / 2)
  let text = padding . ' ' . text . ' ' . padding
  if len % 2 != 0
    let text = text . b:comment_char
  endif

  call append(line('.') - 1, text)
endfunction
