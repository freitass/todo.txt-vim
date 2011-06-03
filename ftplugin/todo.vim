" File:        todo.txt.vim
" Description: Todo.txt filetype detection
" Author:      Leandro Freitas <freitass@gmail.com>
" Licence:     Vim licence
" Website:     http://github.com/freitass/todo.txt.vim
" Version:     0.2

" TODO uncomment
"if exists("g:loaded_todo")
"    finish
"endif
"let g:loaded_todo = 1

let s:save_cpo = &cpo
set cpo&vim

setlocal textwidth=0
setlocal wrapmargin=0

if !hasmapto('<Plug>TodoSortlines')
    map <unique> <leader>s <Plug>TodoSortlines
endif

"TODO replace
"noremap <unique> <script> <Plug>TodoSortlines <SID>SortLines
noremap <script> <Plug>TodoSortlines <SID>SortLines

noremap <SID>SortLines :call <SID>SortLines()<CR>

function! s:Compare(line1,line2)
    " Matches a line starting with 'X '.
    let done_pattern = '\m^X\s\+.*'
    " Matches a line starting with '(\a) ' where \a is a letter.
    let priority_pattern = '\m^(\a)\s\+.*'
    " Matches date YYYY-MM-DD
    let date_pattern = '\m\d\{4\}-\d\{2\}-\d\{2\}'
    " Check PRIORITY first.
    let done_1 = match(a:line1,done_pattern)
    let done_2 = match(a:line2,done_pattern)
    if done_1 != done_2
        " Swap if only the first has been done.
        return -done_2
    endif
    let pri_set_1 = match(a:line1,priority_pattern)
    let pri_set_2 = match(a:line2,priority_pattern)
    if pri_set_1 != pri_set_2
        " Swap if only the second has priority set.
        return -pri_set_1
    elseif pri_set_1 >= 0
        " Swap if the second has higher proprity.
        return a:line2[1] <? a:line1[1]
    endif
    " If the execution reached this code, both tasks have the same priority.
    " Go for the date, sorting older tasks first.
    let x1 = match(a:line1,date_pattern)
    let x2 = match(a:line2,date_pattern)
    if x1 != x2
        " Swap if only the second has creation date.
        return -x1
    endif
    if x2 == -1
        " If none has date, keep the order.
        return 0
    endif
    " Calculate which date should come first
    let date_1 = a:line1[(x1):(x1+9)]
    let date_1 = substitute(date_1,"-","","g")
    let date_2 = a:line2[(x2):(x2+9)]
    let date_2 = substitute(date_2,"-","","g")
    return date_1 > date_2
endfunction

function! s:SortLines()
    let list_of_lines = getline(0,'$')
    let sorted_list = sort(copy(list_of_lines),'s:Compare')
    "%delete
    for line in sorted_list
        echo line
    endfor
endfunction

let &cpo = s:save_cpo
