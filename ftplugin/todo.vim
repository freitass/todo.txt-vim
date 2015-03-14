" File:        todo.txt.vim
" Description: Todo.txt filetype detection
" Author:      Leandro Freitas <freitass@gmail.com>, David Beniamine <David@Beniamine.net>
" License:     Vim license
" Website:     http://github.com/dbeniamine/todo.txt-vim
" Version:     0.5

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

function! TodoTxtToggleMarkAsDone()
    if (getline(".") =~ 'x\s*\d\{4\}')
        :call TodoTxtUnMarkAsDone()
    else
        :call TodoTxtMarkAsDone()
    endif
endfunction

function! TodoTxtUnMarkAsDone()
    :s/\s*x\s*\d\{4}-\d\{1,2}-\d\{1,2}\s*//g
endfunction

function! TodoTxtMarkAsDone()
    "       call s:TodoTxtRemovePriority()
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

function! TodoTxtSort()
    " vim :sort is usually stable
    " we sort first on contexts, then on projects and then on priority
    :sort /@[a-zA-Z]*/ r
    :sort /+[a-zA-Z]*/ r
    :sort /\v\([A-Z]\)/ r
endfunction

" Mappings {{{1
" Sort tasks {{{2
if !hasmapto("<localleader>s",'n')
    nnoremap <script> <silent> <buffer> <LocalLeader>s :call TodoTxtSort()<CR>
endif

if !hasmapto("<LocalLeader>s@",'n')
    nnoremap <script> <silent> <buffer> <LocalLeader>s@ :sort /.\{-}\ze@/ <CR>
endif

if !hasmapto("<LocalLeader>s+",'n')
    nnoremap <script> <silent> <buffer> <LocalLeader>s+ :sort /.\{-}\ze+/ <CR>
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
    let oldpos=getcurpos()
    let line=getline('.')
    if line !~ '^([A-F])'
        :call TodoTxtPrioritizeAddAction(a:priority)
        let oldpos[2]+=4
    else
        exec ':s/^([A-F])/('.a:priority.')/'
    endif
    call setpos('.',oldpos)
endfunction

function! TodoTxtPrioritizeAddAction (priority)
    execute "normal! mq0i(".a:priority.") \<esc>`q"
endfunction

if !hasmapto("<LocalLeader>j",'n')
    nnoremap <script> <silent> <buffer> <LocalLeader>j :call TodoTxtPrioritizeIncrease()<CR>
endif

if !hasmapto("<LocalLeader>j",'v')
    vnoremap <script> <silent> <buffer> <LocalLeader>j :call TodoTxtPrioritizeIncrease()<CR>
endif

if !hasmapto("<LocalLeader>k",'n')
    nnoremap <script> <silent> <buffer> <LocalLeader>k :call TodoTxtPrioritizeDecrease()<CR>
endif

if !hasmapto("<LocalLeader>k",'v')
    vnoremap <script> <silent> <buffer> <LocalLeader>k :call TodoTxtPrioritizeDecrease()<CR>
endif

if !hasmapto("<LocalLeader>a",'n')
    nnoremap <script> <silent> <buffer> <LocalLeader>a :call TodoTxtPrioritizeAdd('A')<CR>
endif

if !hasmapto("<LocalLeader>a",'i')
    inoremap <script> <silent> <buffer> <LocalLeader>a <ESC>:call TodoTxtPrioritizeAdd('A')<CR>i
endif

if !hasmapto("<LocalLeader>a",'v')
    vnoremap <script> <silent> <buffer> <LocalLeader>a :call TodoTxtPrioritizeAdd('A')<CR>
endif

if !hasmapto("<LocalLeader>b",'n')
    nnoremap <script> <silent> <buffer> <LocalLeader>b :call TodoTxtPrioritizeAdd('B')<CR>
endif

if !hasmapto("<LocalLeader>b",'i')
    inoremap <script> <silent> <buffer> <LocalLeader>b <ESC>:call TodoTxtPrioritizeAdd('B')<CR>i
endif

if !hasmapto("<LocalLeader>b",'v')
    vnoremap <script> <silent> <buffer> <LocalLeader>b :call TodoTxtPrioritizeAdd('B')<CR>
endif

if !hasmapto("<LocalLeader>c",'n')
    nnoremap <script> <silent> <buffer> <LocalLeader>c :call TodoTxtPrioritizeAdd('C')<CR>
endif
if !hasmapto("<LocalLeader>c",'i')
    inoremap <script> <silent> <buffer> <LocalLeader>c <ESC>:call TodoTxtPrioritizeAdd('C')<CR>i
endif

if !hasmapto("<LocalLeader>c",'v')
    vnoremap <script> <silent> <buffer> <LocalLeader>c :call TodoTxtPrioritizeAdd('C')<CR>
endif

" Insert date {{{2
if !hasmapto("date<Tab>",'i')
    inoremap <script> <silent> <buffer> date<Tab> <C-R>=strftime("%Y-%m-%d")<CR>
endif

if !hasmapto("<localleader>d",'n')
    nnoremap <script> <silent> <buffer> <localleader>d :call TodoTxtPrependDate()<CR>
endif

if !hasmapto("<localleader>d",'v')
    vnoremap <script> <silent> <buffer> <localleader>d :call TodoTxtPrependDate()<CR>
endif

" Mark done {{{2
if !hasmapto("<localleader>x",'n')
    nnoremap <script> <silent> <buffer> <localleader>x :call TodoTxtToggleMarkAsDone()<CR>
endif

if !hasmapto("<localleader>x",'v')
    vnoremap <script> <silent> <buffer> <localleader>x :call TodoTxtToggleMarkAsDone()<CR>
endif

" Mark all done {{{2
if !hasmapto("<localleader>X",'n')
    nnoremap <script> <silent> <buffer> <localleader>X :call TodoTxtMarkAllAsDone()<CR>
endif

" Remove completed {{{2
if !hasmapto("<localleader>D",'n')
    nnoremap <script> <silent> <buffer> <localleader>D :call TodoTxtRemoveCompleted()<CR>
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

" Intelligent completion for projects and Contexts
fun! TodoComplete(findstart, base)
    if a:findstart
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] !~ '\s'
            let start -= 1
        endwhile
        return start
    else
        let res = []
        let file = readfile(expand("%:p"))
        for line in file
            if line =~ " ".a:base
                let item={}
                let item.word=substitute(line,'.*\('.a:base.'\S*\).*','\1',"")
                if a:base =~ '+'
                    let item.info="Context: ".substitute(line,'.*\s\(@\S\S*\).*','\1',"")
                elseif a:base =~ '@'
                    let l:pr=[]
                    for line2 in file
                        if line2 =~ l:item.word
                            call add(l:pr,substitute(line2,'.*\s\(+\S\S*\).*','\1',""))
                        endif
                    endfor
                    let item.info="Projects: ".join(uniq(l:pr), " ")
                endif
                call add(res,item)
            endif
        endfor
        return res
    endif
endfun

" Restore context {{{1
let &cpo = s:save_cpo
" Modeline {{{1
" vim: ts=8 sw=4 sts=4 et foldenable foldmethod=marker foldcolumn=1
