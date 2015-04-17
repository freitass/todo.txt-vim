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

" Mappings {{{1
" Sort tasks {{{2
if !hasmapto("<leader>s",'n')
    nnoremap <script> <silent> <buffer> <leader>s :%sort<CR>
endif

if !hasmapto("<leader>s",'v')
    vnoremap <script> <silent> <buffer> <leader>s :sort<CR>
endif

if !hasmapto("<leader>s@",'n')
    nnoremap <script> <silent> <buffer> <leader>s@ :%call todo#txt#sort_by_context()<CR>
endif

if !hasmapto("<leader>s@",'v')
    vnoremap <script> <silent> <buffer> <leader>s@ :call todo#txt#sort_by_context()<CR>
endif

if !hasmapto("<leader>s+",'n')
    nnoremap <script> <silent> <buffer> <leader>s+ :%call todo#txt#sort_by_project()<CR>
endif

if !hasmapto("<leader>s+",'v')
    vnoremap <script> <silent> <buffer> <leader>s+ :call todo#txt#sort_by_project()<CR>
endif

if !hasmapto("<leader>sd",'n')
    nnoremap <script> <silent> <buffer> <leader>sd :%call todo#txt#sort_by_date()<CR>
endif

if !hasmapto("<leader>sd",'v')
    vnoremap <script> <silent> <buffer> <leader>sd :call todo#txt#sort_by_date()<CR>
endif

" Change priority {{{2
if !hasmapto("<leader>j",'n')
    nnoremap <script> <silent> <buffer> <leader>j :call todo#txt#prioritize_increase()<CR>
endif

if !hasmapto("<leader>j",'v')
    vnoremap <script> <silent> <buffer> <leader>j :call todo#txt#prioritize_increase()<CR>
endif

if !hasmapto("<leader>k",'n')
    nnoremap <script> <silent> <buffer> <leader>k :call todo#txt#prioritize_decrease()<CR>
endif

if !hasmapto("<leader>k",'v')
    vnoremap <script> <silent> <buffer> <leader>k :call todo#txt#prioritize_decrease()<CR>
endif

if !hasmapto("<leader>a",'n')
    nnoremap <script> <silent> <buffer> <leader>a :call todo#txt#prioritize_add('A')<CR>
endif

if !hasmapto("<leader>a",'v')
    vnoremap <script> <silent> <buffer> <leader>a :call todo#txt#prioritize_add('A')<CR>
endif

if !hasmapto("<leader>b",'n')
    nnoremap <script> <silent> <buffer> <leader>b :call todo#txt#prioritize_add('B')<CR>
endif

if !hasmapto("<leader>b",'v')
    vnoremap <script> <silent> <buffer> <leader>b :call todo#txt#prioritize_add('B')<CR>
endif

if !hasmapto("<leader>c",'n')
    nnoremap <script> <silent> <buffer> <leader>c :call todo#txt#prioritize_add('C')<CR>
endif

if !hasmapto("<leader>c",'v')
    vnoremap <script> <silent> <buffer> <leader>c :call todo#txt#prioritize_add('C')<CR>
endif

" Insert date {{{2
if !hasmapto("date<Tab>",'i')
    inoremap <script> <silent> <buffer> date<Tab> <C-R>=strftime("%Y-%m-%d")<CR>
endif

if !hasmapto("<leader>d",'n')
    nnoremap <script> <silent> <buffer> <leader>d :call todo#txt#prepend_date()<CR>
endif

if !hasmapto("<leader>d",'v')
    vnoremap <script> <silent> <buffer> <leader>d :call todo#txt#prepend_date()<CR>
endif

" Mark done {{{2
if !hasmapto("<leader>x",'n')
    nnoremap <script> <silent> <buffer> <leader>x :call todo#txt#mark_as_done()<CR>
endif

if !hasmapto("<leader>x",'v')
    vnoremap <script> <silent> <buffer> <leader>x :call todo#txt#mark_as_done()<CR>
endif

" Mark all done {{{2
if !hasmapto("<leader>X",'n')
    nnoremap <script> <silent> <buffer> <leader>X :call todo#txt#mark_all_as_done()<CR>
endif

" Remove completed {{{2
if !hasmapto("<leader>D",'n')
    nnoremap <script> <silent> <buffer> <leader>D :call todo#txt#remove_completed()<CR>
endif

" Folding {{{1
" Options {{{2
setlocal foldmethod=expr
setlocal foldexpr=s:todo_fold_level(v:lnum)
setlocal foldtext=s:todo_fold_text()

" s:todo_fold_level(lnum) {{{2
function! s:todo_fold_level(lnum)
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

" s:todo_fold_text() {{{2
function! s:todo_fold_text()
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
