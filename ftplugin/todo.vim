" File:        todo.txt.vim
" Description: Todo.txt filetype detection
" Author:      David Beniamine <David@Beniamine.net>, Leandro Freitas <freitass@gmail.com>
" License:     Vim license
" Website:     http://github.com/dbeniamine/todo.txt-vim
" Version:     0.7.2
" vim: ts=4 sw=4 :help tw=78 cc=80

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

" Sort todo by (first) context
if !hasmapto("<localleader>sc",'n')
    noremap <silent><localleader>sc :call todo#HierarchicalSort('@', '', 1)<CR>
endif
if !hasmapto("<localleader>scp",'n')
    noremap <silent><localleader>scp :call todo#HierarchicalSort('@', '+', 1)<CR>
endif
" Sort todo by (first) project
if !hasmapto("<localleader>sp",'n')
    noremap <silent><localleader>sp :call todo#HierarchicalSort('+', '',1)<CR>
endif
if !hasmapto("<localleader>spc",'n')
    noremap <silent><localleader>spc :call todo#HierarchicalSort('+', '@',1)<CR>
endif


" Sort tasks {{{2
if !hasmapto("<localleader>s",'n')
    nnoremap <script> <silent> <buffer> <LocalLeader>s :call todo#Sort()<CR>
endif

if !hasmapto("<LocalLeader>s@",'n')
    nnoremap <script> <silent> <buffer> <LocalLeader>s@ :sort /.\{-}\ze@/ <CR>
endif

if !hasmapto("<LocalLeader>s+",'n')
    nnoremap <script> <silent> <buffer> <LocalLeader>s+ :sort /.\{-}\ze+/ <CR>
endif

if !hasmapto("<LocalLeader>j",'n')
    nnoremap <script> <silent> <buffer> <LocalLeader>j :call todo#PrioritizeIncrease()<CR>
endif

if !hasmapto("<LocalLeader>j",'v')
    vnoremap <script> <silent> <buffer> <LocalLeader>j :call todo#PrioritizeIncrease()<CR>
endif

if !hasmapto("<LocalLeader>k",'n')
    nnoremap <script> <silent> <buffer> <LocalLeader>k :call todo#PrioritizeDecrease()<CR>
endif

if !hasmapto("<LocalLeader>k",'v')
    vnoremap <script> <silent> <buffer> <LocalLeader>k :call todo#PrioritizeDecrease()<CR>
endif

if !hasmapto("<LocalLeader>a",'n')
    nnoremap <script> <silent> <buffer> <LocalLeader>a :call todo#PrioritizeAdd('A')<CR>
endif

if !hasmapto("<LocalLeader>a",'i')
    inoremap <script> <silent> <buffer> <LocalLeader>a <ESC>:call todo#PrioritizeAdd('A')<CR>i
endif

if !hasmapto("<LocalLeader>a",'v')
    vnoremap <script> <silent> <buffer> <LocalLeader>a :call todo#PrioritizeAdd('A')<CR>
endif

if !hasmapto("<LocalLeader>b",'n')
    nnoremap <script> <silent> <buffer> <LocalLeader>b :call todo#PrioritizeAdd('B')<CR>
endif

if !hasmapto("<LocalLeader>b",'i')
    inoremap <script> <silent> <buffer> <LocalLeader>b <ESC>:call todo#PrioritizeAdd('B')<CR>i
endif

if !hasmapto("<LocalLeader>b",'v')
    vnoremap <script> <silent> <buffer> <LocalLeader>b :call todo#PrioritizeAdd('B')<CR>
endif

if !hasmapto("<LocalLeader>c",'n')
    nnoremap <script> <silent> <buffer> <LocalLeader>c :call todo#PrioritizeAdd('C')<CR>
endif
if !hasmapto("<LocalLeader>c",'i')
    inoremap <script> <silent> <buffer> <LocalLeader>c <ESC>:call todo#PrioritizeAdd('C')<CR>i
endif

if !hasmapto("<LocalLeader>c",'v')
    vnoremap <script> <silent> <buffer> <LocalLeader>c :call todo#PrioritizeAdd('C')<CR>
endif

" Insert date {{{2
if !hasmapto("date<Tab>",'i')
    inoremap <script> <silent> <buffer> date<Tab> <C-R>=strftime("%Y-%m-%d")<CR>
endif

if !hasmapto("due:",'i')
    inoremap <script> <silent> <buffer> due: due:<C-R>=strftime("%Y-%m-%d")<CR>
endif

if !hasmapto("DUE:",'i')
    inoremap <script> <silent> <buffer> DUE: DUE:<C-R>=strftime("%Y-%m-%d")<CR>
endif

if !hasmapto("<localleader>d",'n')
    nnoremap <script> <silent> <buffer> <localleader>d :call todo#PrependDate()<CR>
endif

if !hasmapto("<localleader>d",'v')
    vnoremap <script> <silent> <buffer> <localleader>d :call todo#PrependDate()<CR>
endif

" Mark done {{{2
if !hasmapto("<localleader>x",'n')
    nnoremap <script> <silent> <buffer> <localleader>x :call todo#ToggleMarkAsDone('')<CR>
endif

if !hasmapto("<localleader>x",'v')
    vnoremap <script> <silent> <buffer> <localleader>x :call todo#ToggleMarkAsDone('')<CR>
endif

" Mark done {{{2
if !hasmapto("<localleader>C",'n')
    nnoremap <script> <silent> <buffer> <localleader>C :call todo#ToggleMarkAsDone('Cancelled')<CR>
endif

if !hasmapto("<localleader>C",'v')
    vnoremap <script> <silent> <buffer> <localleader>C :call todo#ToggleMarkAsDone('Cancelled')<CR>
endif



" Mark all done {{{2
if !hasmapto("<localleader>X",'n')
    nnoremap <script> <silent> <buffer> <localleader>X :call todo#MarkAllAsDone('')<CR>
endif

" Remove completed {{{2
if !hasmapto("<localleader>D",'n')
    nnoremap <script> <silent> <buffer> <localleader>D :call todo#RemoveCompleted()<CR>
endif

" Sort by due: date {{{2
if !hasmapto("<localleader>sd".'n')
    nnoremap <script> <silent> <buffer> <localleader>sd :call todo#SortDue()<CR>
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
