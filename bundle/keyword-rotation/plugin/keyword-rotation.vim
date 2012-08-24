" XXX what about ($@%&)?(...) and $#array, $#$aref?
" XXX STRINGS! "(.*)"; '(.*)'

let s:keywordTypes = ['a-z,A-Z', 'a-z,A-Z,48-57', 'a-z,A-Z,48-57,_']
let s:keywordNames = ['word', 'alphanumeric', 'C identifier']

function AddKeywordType(name, chars)
  call add(s:keywordTypes, a:chars)
  call add(s:keywordNames, a:name)
endfunction

function RotateKeywords()
  if !exists('b:keywordIndex')
    let b:keywordIndex = 0
  endif

  let b:keywordIndex = b:keywordIndex + 1
  if b:keywordIndex == len(s:keywordTypes)
    let b:keywordIndex = 0
  endif

  let &iskeyword = s:keywordTypes[b:keywordIndex]
  echo s:keywordNames[b:keywordIndex]
endfunction
