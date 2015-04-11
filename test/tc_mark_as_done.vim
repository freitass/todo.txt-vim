let s:here = expand('<sfile>:p:h')
let s:tc = unittest#testcase#new('Mask As Done', 
      \ { 'data': s:here . '/tc_mark_as_done.todo.txt' })

let s:LEADER = mapleader
let s:TODAY = strftime("%Y-%m-%d")

let s:FIRST_TASK_DONE = [
      \ 'x ' . s:TODAY . ' first task to be marked as done',
      \ 'second task to be marked as done',
      \ 'third task to be marked as done',
      \ ]

let s:ALL_TASKS_DONE = [
      \ 'x ' . s:TODAY . ' first task to be marked as done',
      \ 'x ' . s:TODAY . ' second task to be marked as done',
      \ 'x ' . s:TODAY . ' third task to be marked as done',
      \ ]

function! s:tc.test_mark_as_done()
  call self.data.goto('lorem_ipsum')
  execute 'normal ' . s:LEADER . 'x'
  call self.assert_equal(s:FIRST_TASK_DONE, self.data.get('lorem_ipsum'))
endfunction

function! s:tc.test_mark_range_as_done()
  call self.data.execute('normal ' . s:LEADER . 'x', 'lorem_ipsum')
  call self.assert_equal(s:ALL_TASKS_DONE, self.data.get('lorem_ipsum'))
endfunction

function! s:tc.test_mark_selection_as_done()
  call self.data.visual_execute('normal ' . s:LEADER . 'x', 'lorem_ipsum')
  call self.assert_equal(s:ALL_TASKS_DONE, self.data.get('lorem_ipsum'))
endfunction

unlet s:tc
