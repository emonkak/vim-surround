if exists('g:loaded_surround')
  finish
endif

if !exists('g:surround_objects')
  let g:surround_objects = {
  \   'b': ['(', ')'],
  \   '(': ['(', ')'],
  \   ')': ['(', ')'],
  \   'B': ['{', '}'],
  \   '{': ['{', '}'],
  \   '}': ['{', '}'],
  \   'r': ['[', ']'],
  \   '[': ['[', ']'],
  \   ']': ['[', ']'],
  \   'a': ['<', '>'],
  \   '<': ['<', '>'],
  \   '>': ['<', '>'],
  \   '"': ['"', '"'],
  \   "'": ["'", "'"],
  \   '`': ['`', '`'],
  \   '/': ['/', '/'],
  \ }
endif

nnoremap <expr> <Plug>(surround-operator-add)
\               surround#operator_n('surround#operator_add')
vnoremap <expr> <Plug>(surround-operator-add)
\               surround#operator_v('surround#operator_add')
onoremap <Plug>(surround-operator-add)  g@

nnoremap <expr> <Plug>(surround-operator-change)
\               surround#operator_n('surround#operator_change')
vnoremap <expr> <Plug>(surround-operator-change)
\               surround#operator_v('surround#operator_change')
onoremap <Plug>(surround-operator-change)  g@

nnoremap <expr> <Plug>(surround-operator-delete)
\               surround#operator_n('surround#operator_delete')
vnoremap <expr> <Plug>(surround-operator-delete)
\               surround#operator_v('surround#operator_delete')
onoremap <Plug>(surround-operator-delete)  g@

function! s:define_text_objects() abort
  for [key, value] in items(g:surround_objects)
    let [head, tail] = value
    let lhs = '<Plug>(surround-textobj:' . key . ')'
    if head ==# tail
      let rhs = ':<C-u>call surround#textobj_between('
      \       . string(head)
      \       . ')<CR>'
    else
      let rhs = ':<C-u>call surround#textobj_around('
      \       . string(head)
      \       . ', '
      \       . string(tail)
      \       . ')<CR>'
    endif
    execute 'vnoremap <silent>' lhs rhs
    execute 'onoremap <silent>' lhs rhs
  endfor
endfunction

function! s:define_default_key_mappings() abort
  nmap ys  <Plug>(surround-operator-add)

  nnoremap cs  <Nop>
  nnoremap ds  <Nop>

  for key in keys(g:surround_objects)
    let textobj = '<Plug>(surround-textobj:' . key  . ')'
    execute 'nmap'
    \       ('cs' . key)
    \       ('<Plug>(surround-operator-change)'. textobj)
    execute 'nmap'
    \       ('ds' . key)
    \       ('<Plug>(surround-operator-delete)' . textobj)
  endfor
endfunction

call s:define_text_objects()

if !get(g:, 'surround_no_default_key_mappings')
  call s:define_default_key_mappings()
endif

let g:loaded_surround = 1