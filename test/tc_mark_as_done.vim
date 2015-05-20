let s:here = expand('<sfile>:p:h')
let s:context = todo#txt#__context__()
let s:context['data'] = s:here . '/tc_mark_as_done.todo.txt'
let s:tc = unittest#testcase#new('Mark As Done', s:context)

let s:TODAY = strftime("%Y-%m-%d")

let s:FIRST_TASK_DONE = [
      \ 'x ' . s:TODAY . ' first task to be marked as done',
      \ 'second task to be marked as done',
      \ '2015-05-20 third task to be marked as done',
      \ ]

let s:ALL_TASKS_DONE = [
      \ 'x ' . s:TODAY . ' first task to be marked as done',
      \ 'x ' . s:TODAY . ' second task to be marked as done',
      \ 'x ' . s:TODAY . ' 2015-05-20 third task to be marked as done',
      \ ]

function! s:tc.test_mark_as_done()
  call self.data.goto('lorem_ipsum')
  call todo#txt#mark_as_done()
  call self.assert_equal(s:FIRST_TASK_DONE, self.data.get('lorem_ipsum'))
endfunction

function! s:tc.test_mark_range_as_done()
  call self.data.execute('call todo#txt#mark_as_done()', 'lorem_ipsum')
  call self.assert_equal(s:ALL_TASKS_DONE, self.data.get('lorem_ipsum'))
endfunction

function! s:tc.test_mark_selection_as_done()
  call self.data.visual_execute('call todo#txt#mark_as_done()', 'lorem_ipsum')
  call self.assert_equal(s:ALL_TASKS_DONE, self.data.get('lorem_ipsum'))
endfunction

unlet s:tc
