let s:here = expand('<sfile>:p:h')
let s:context = todo#txt#__context__()
let s:context['data'] = s:here . '/tc_date.todo.txt'
let s:tc = unittest#testcase#new('Date', s:context)

let s:TODAY = strftime("%Y-%m-%d")

function! s:tc.test_current_date()
  call self.assert_equal(s:TODAY, self.call('s:get_current_date', []))
endfunction

let s:DATE_INSERTED = [
      \ s:TODAY . ' example task',
      \ ]

let s:DATE_INSERTED_AFTER_PRIORITY = [
      \ '(A) ' . s:TODAY . ' Call Mom',
      \ ]

let s:DATE_INSERTED_AFTER_PRIORITY_VISUAL = [
      \ '(A) ' . s:TODAY . ' Call Mom',
      \ '(B) ' . s:TODAY . ' Call Dad',
      \ ]

function! s:tc.test_insert_date_normal_mode()
  call self.data.goto('lorem_ipsum')
  call self.data.execute('call todo#txt#prepend_date()', 'lorem_ipsum')
  call self.assert_equal(s:DATE_INSERTED, self.data.get('lorem_ipsum'))
endfunction

function! s:tc.test_insert_date_insert_mode()
  call self.data.goto('lorem_ipsum')
  execute 'normal idate	 '
  call self.assert_equal(s:DATE_INSERTED, self.data.get('lorem_ipsum'))
endfunction

function! s:tc.test_insert_date_visual_mode()
  call self.data.visual_execute('call todo#txt#prepend_date()', 'lorem_ipsum')
  call self.assert_equal(s:DATE_INSERTED, self.data.get('lorem_ipsum'))
endfunction

function! s:tc.test_insert_date_after_priority_normal_mode()
  call self.data.goto('date_after_priority')
  call self.data.execute('call todo#txt#prepend_date()', 'date_after_priority')
  call self.assert_equal(s:DATE_INSERTED_AFTER_PRIORITY, self.data.get('date_after_priority'))
endfunction

function! s:tc.test_insert_date_after_priority_visual_mode()
  call self.data.goto('date_after_priority_visual')
  call self.data.visual_execute('call todo#txt#prepend_date()', 'date_after_priority_visual')
  call self.assert_equal(s:DATE_INSERTED_AFTER_PRIORITY_VISUAL, self.data.get('date_after_priority_visual'))
endfunction

unlet s:tc
