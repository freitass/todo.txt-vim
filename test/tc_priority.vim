let s:here = expand('<sfile>:p:h')
let s:context = todo#txt#__context__()
let s:context['data'] = s:here . '/tc_priority.todo.txt'
let s:tc = unittest#testcase#new('Priority', s:context)

let s:TODAY = strftime("%Y-%m-%d")

let s:PRIORITY_INSERTED = [
      \ '(A) example task',
      \ ]

let s:PRIORITY_REPLACED = [
      \ '(C) example task',
      \ ]

function! s:tc.test_insert_priority()
  call self.data.goto('insert_priority')
  call todo#txt#prioritize_add('A')
  call self.assert_equal(s:PRIORITY_INSERTED, self.data.get('insert_priority'))
endfunction

function! s:tc.test_replace_priority()
  call self.data.goto('replace_priority')
  call todo#txt#prioritize_add('C')
  call self.assert_equal(s:PRIORITY_REPLACED, self.data.get('replace_priority'))
endfunction

unlet s:tc
