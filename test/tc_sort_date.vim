let s:here = expand('<sfile>:p:h')
let s:tc = unittest#testcase#new('Sort Date',
      \ { 'data': s:here . '/tc_sort_date.todo.txt' })

let s:LEADER = mapleader

let s:SORTED_TASKS = [
      \ '(B) 2012-04-16 2015-04-16',
      \ '(B) 2013-03-15 2015-03-17',
      \ '(A) 2013-03-16 2013-03-10',
      \ ]

let s:SORTED_TASKS_WITH_NO_DATE = [
      \ '2013-03-15 task with date',
      \ '2013-03-15 task with date',
      \ '2013-03-15 task with date',
      \ 'task with no date',
      \ 'task with no date',
      \ ]

function! s:tc.test_sort_by_date()
  call self.data.visual_execute('call todo#txt#sort_by_date()', 'lorem_ipsum')
  call self.assert_equal(s:SORTED_TASKS, self.data.get('lorem_ipsum'))
endfunction

function! s:tc.test_sort_by_date_with_tasks_without_date()
  call self.data.visual_execute('call todo#txt#sort_by_date()', 'task_with_no_date')
  call self.assert_equal(s:SORTED_TASKS_WITH_NO_DATE, self.data.get('task_with_no_date'))
endfunction

unlet s:tc
