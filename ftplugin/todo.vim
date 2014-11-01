" File:        todo.txt.vim
" Description: Todo.txt filetype detection
" Author:      Leandro Freitas <freitass@gmail.com>
" License:     Vim license
" Website:     http://github.com/freitass/todo.txt-vim
" Version:     0.4

" Save context {{{1
let s:save_cpo = &cpo
set cpo&vim

" General options {{{1
" Some options lose their values when window changes. They will be set every
" time this script is invocated, which is whenever a file of this type is
" created or edited.
setlocal textwidth=0
setlocal wrapmargin=0

" Functions {{{1
function! s:TodoTxtRemovePriority()
    :s/^(\w)\s\+//ge
endfunction

function! TodoTxtPrependDate()
    normal! 0"=strftime("%Y-%m-%d ")P
endfunction

function! TodoTxtMarkAsDone()
    call s:TodoTxtRemovePriority()
    call TodoTxtPrependDate()
    normal! Ix 
endfunction

function! TodoTxtMarkAllAsDone()
    :g!/^x /:call TodoTxtMarkAsDone()
endfunction

function! s:AppendToFile(file, lines)
    let l:lines = []

    " Place existing tasks in done.txt at the beggining of the list.
    if filereadable(a:file)
        call extend(l:lines, readfile(a:file))
    endif

    " Append new completed tasks to the list.
    call extend(l:lines, a:lines)

    " Write to file.
    call writefile(l:lines, a:file)
endfunction

function! TodoTxtRemoveCompleted()
    " Check if we can write to done.txt before proceeding.
    let l:target_dir = expand('%:p:h')
    let l:done_file = l:target_dir.'/done.txt'
    if !filewritable(l:done_file) && !filewritable(l:target_dir)
        echoerr "Can't write to file 'done.txt'"
        return
    endif

    let l:completed = []
    :g/^x /call add(l:completed, getline(line(".")))|d
    call s:AppendToFile(l:done_file, l:completed)
endfunction

" Mappings {{{1
" Sort tasks {{{2
if !hasmapto("<leader>s",'n')
    nnoremap <script> <silent> <buffer> <leader>s :sort<CR>
endif

if !hasmapto("<leader>s@",'n')
    nnoremap <script> <silent> <buffer> <leader>s@ :sort /.\{-}\ze@/ <CR>
endif

if !hasmapto("<leader>s+",'n')
    nnoremap <script> <silent> <buffer> <leader>s+ :sort /.\{-}\ze+/ <CR>
endif

" Increment and Decrement The Priority
:set nf=octal,hex,alpha

function! TodoTxtPrioritizeIncrease()
    normal! 0f)h
endfunction

function! TodoTxtPrioritizeDecrease()
    normal! 0f)h
endfunction

function! TodoTxtPrioritizeAdd (priority)
    " Need to figure out how to only do this if the first visible letter in a line is not (
    :call TodoTxtPrioritizeAddAction(a:priority)
endfunction

function! TodoTxtPrioritizeAddAction (priority)
    execute "normal! mq0i(".a:priority.") \<esc>`q"
endfunction

if !hasmapto("<leader>j",'n')
    nnoremap <script> <silent> <buffer> <leader>j :call TodoTxtPrioritizeIncrease()<CR>
endif

if !hasmapto("<leader>j",'v')
    vnoremap <script> <silent> <buffer> <leader>j :call TodoTxtPrioritizeIncrease()<CR>
endif

if !hasmapto("<leader>k",'n')
    nnoremap <script> <silent> <buffer> <leader>k :call TodoTxtPrioritizeDecrease()<CR>
endif

if !hasmapto("<leader>k",'v')
    vnoremap <script> <silent> <buffer> <leader>k :call TodoTxtPrioritizeDecrease()<CR>
endif

if !hasmapto("<leader>a",'n')
    nnoremap <script> <silent> <buffer> <leader>a :call TodoTxtPrioritizeAdd('A')<CR>
endif

if !hasmapto("<leader>a",'v')
    vnoremap <script> <silent> <buffer> <leader>a :call TodoTxtPrioritizeAdd('A')<CR>
endif

if !hasmapto("<leader>b",'n')
    nnoremap <script> <silent> <buffer> <leader>b :call TodoTxtPrioritizeAdd('B')<CR>
endif

if !hasmapto("<leader>b",'v')
    vnoremap <script> <silent> <buffer> <leader>b :call TodoTxtPrioritizeAdd('B')<CR>
endif

if !hasmapto("<leader>c",'n')
    nnoremap <script> <silent> <buffer> <leader>c :call TodoTxtPrioritizeAdd('C')<CR>
endif

if !hasmapto("<leader>c",'v')
    vnoremap <script> <silent> <buffer> <leader>c :call TodoTxtPrioritizeAdd('C')<CR>
endif

" Insert date {{{2
if !hasmapto("date<Tab>",'i')
    inoremap <script> <silent> <buffer> date<Tab> <C-R>=strftime("%Y-%m-%d")<CR>
endif

if !hasmapto("<leader>d",'n')
    nnoremap <script> <silent> <buffer> <leader>d :call TodoTxtPrependDate()<CR>
endif

if !hasmapto("<leader>d",'v')
    vnoremap <script> <silent> <buffer> <leader>d :call TodoTxtPrependDate()<CR>
endif

" Mark done {{{2
if !hasmapto("<leader>x",'n')
    nnoremap <script> <silent> <buffer> <leader>x :call TodoTxtMarkAsDone()<CR>
endif

if !hasmapto("<leader>x",'v')
    vnoremap <script> <silent> <buffer> <leader>x :call TodoTxtMarkAsDone()<CR>
endif

" Mark all done {{{2
if !hasmapto("<leader>X",'n')
    nnoremap <script> <silent> <buffer> <leader>X :call TodoTxtMarkAllAsDone()<CR>
endif

" Remove completed {{{2
if !hasmapto("<leader>D",'n')
    nnoremap <script> <silent> <buffer> <leader>D :call TodoTxtRemoveCompleted()<CR>
endif

" Folding {{{1
" Options {{{2
setlocal foldmethod=expr
setlocal foldexpr=TodoFoldLevel(v:lnum)
setlocal foldtext=TodoFoldText()

" TodoFoldLevel(lnum) {{{2
function! TodoFoldLevel(lnum)
    " The match function returns the index of the matching pattern or -1 if
    " the pattern doesn't match. In this case, we always try to match a
    " completed task from the beginning of the line so that the matching
    " function will always return -1 if the pattern doesn't match or 0 if the
    " pattern matches. Incrementing by one the value returned by the matching
    " function we will return 1 for the completed tasks (they will be at the
    " first folding level) while for the other lines 0 will be returned,
    " indicating that they do not fold.
    return match(getline(a:lnum),'^[xX]\s.\+$') + 1
endfunction

" TodoFoldText() {{{2
function! TodoFoldText()
    " The text displayed at the fold is formatted as '+- N Completed tasks'
    " where N is the number of lines folded.
    return '+' . v:folddashes . ' '
                \ . (v:foldend - v:foldstart + 1)
                \ . ' Completed tasks '
endfunction

" Restore context {{{1
let &cpo = s:save_cpo
" Modeline {{{1
" vim: ts=8 sw=4 sts=4 et foldenable foldmethod=marker foldcolumn=1
