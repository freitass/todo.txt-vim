let s:here = expand('<sfile>:p:h')
let s:context = todo#__context__()
let s:context['data'] = s:here . '/tc_date.todo.txt'
let s:tc = unittest#testcase#new('Date', s:context)

let s:LEADER = mapleader
let s:TODAY = strftime("%Y-%m-%d")

function! s:tc.test_current_date()
  call self.assert_equal(s:TODAY, self.call('s:TodoTxtGetCurrentDate', []))
endfunction

let s:DATE_INSERTED = [
      \ s:TODAY . ' example task',
      \ ]

let s:DATE_INSERTED_VISUAL = [
      \ s:TODAY . ' example task',
      \ ]

function! s:tc.test_insert_date_normal_mode()
  call self.data.goto('lorem_ipsum')
  execute 'normal ' . s:LEADER . 'd'
  call self.assert_equal(s:DATE_INSERTED, self.data.get('lorem_ipsum'))
endfunction

function! s:tc.test_insert_date_insert_mode()
  call self.data.goto('lorem_ipsum')
  execute 'normal idate	 '
  call self.assert_equal(s:DATE_INSERTED_VISUAL, self.data.get('lorem_ipsum'))
endfunction

function! s:tc.test_insert_date_visual_mode()
  call self.data.visual_execute('call TodoTxtPrependDate()', 'lorem_ipsum')
  call self.assert_equal(s:DATE_INSERTED_VISUAL, self.data.get('lorem_ipsum'))
endfunction

unlet s:tc
