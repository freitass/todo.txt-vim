let s:here = expand('<sfile>:p:h')
let s:tc = unittest#testcase#new('Sort Project',
      \ { 'data': s:here . '/tc_sort_project.todo.txt' })

let s:LEADER = mapleader

let s:SORTED_TASKS = [
      \ '(B) Review key questions. +benchmarking',
      \ '(B) Linear regression Rnet=Qh+Qle. +cons_emp_model',
      \ '(A) simple model first +cons_emp_model',
      \ ]

function! s:tc.test_sort_by_project()
  call self.data.visual_execute('call todo#txt#sort_by_project()', 'lorem_ipsum')
  call self.assert_equal(s:SORTED_TASKS, self.data.get('lorem_ipsum'))
endfunction

unlet s:tc
