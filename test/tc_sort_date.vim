let s:here = expand('<sfile>:p:h')
let s:tc = unittest#testcase#new('Sort Date', 
      \ { 'data': s:here . '/tc_sort_date.todo.txt' })

let s:LEADER = mapleader

let s:SORTED_TASKS = [
      \ '(B) 2013-03-16 2013-03-10',
      \ '(B) 2013-03-15 2015-03-17',
      \ '(A) 2012-04-16 2015-04-16',
      \ ]

function! s:tc.test_sort_by_context()
  call self.data.visual_execute('call todo#txt#sort_by_date()', 'lorem_ipsum')
  call self.assert_equal(s:SORTED_TASKS, self.data.get('lorem_ipsum'))
endfunction

unlet s:tc
