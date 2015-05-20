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

let s:DATE_INSERTED_DO_NOTHING = [
      \ '2014-05-06 example task',
      \ ]

let s:NON_EXISTING_DATE_INSERTED_DO_NOTHING = [
      \ s:TODAY . ' new todo line',
      \ ]

function! s:tc.test_insert_date_normal_mode()
  call self.data.goto('lorem_ipsum')
  call todo#txt#replace_date()
  call self.assert_equal(s:DATE_INSERTED, self.data.get('lorem_ipsum'))
endfunction

function! s:tc.test_insert_date_insert_mode()
  call self.data.goto('lorem_ipsum')
  execute 'normal idate	 '
  call self.assert_equal(s:DATE_INSERTED, self.data.get('lorem_ipsum'))
endfunction

function! s:tc.test_insert_date_visual_mode()
  call self.data.visual_execute('call todo#txt#replace_date()', 'lorem_ipsum')
  call self.assert_equal(s:DATE_INSERTED, self.data.get('lorem_ipsum'))
endfunction

function! s:tc.test_insert_date_after_priority_normal_mode()
  call self.data.execute('call todo#txt#replace_date()', 'date_after_priority')
  call self.assert_equal(s:DATE_INSERTED_AFTER_PRIORITY, self.data.get('date_after_priority'))
endfunction

function! s:tc.test_insert_date_after_priority_visual_mode()
  call self.data.visual_execute('call todo#txt#replace_date()', 'date_after_priority_visual')
  call self.assert_equal(s:DATE_INSERTED_AFTER_PRIORITY_VISUAL, self.data.get('date_after_priority_visual'))
endfunction

function! s:tc.test_insert_with_existing_date()
  call self.data.execute('call todo#txt#replace_date()', 'existing_date_no_priority')
  call self.assert_equal(s:DATE_INSERTED, self.data.get('existing_date_no_priority'))
endfunction

function! s:tc.test_insert_with_existing_date_and_priority()
  call self.data.execute('call todo#txt#replace_date()', 'existing_date_after_priority')
  call self.assert_equal(s:DATE_INSERTED_AFTER_PRIORITY, self.data.get('existing_date_after_priority'))
endfunction

function! s:tc.test_insert_with_existing_date_and_priority()
  let g:todo_existing_date = 'n'
  call self.data.execute('call todo#txt#replace_date()', 'existing_date_do_nothing')
  call self.assert_equal(s:DATE_INSERTED_DO_NOTHING, self.data.get('existing_date_do_nothing'))
  unlet g:todo_existing_date
endfunction

function! s:tc.test_insert_with_existing_date_and_priority()
  let g:todo_existing_date = 'n'
  call self.data.execute('call todo#txt#replace_date()', 'non_existing_date_do_nothing')
  call self.assert_equal(s:NON_EXISTING_DATE_INSERTED_DO_NOTHING, self.data.get('non_existing_date_do_nothing'))
  unlet g:todo_existing_date
endfunction

unlet s:tc
