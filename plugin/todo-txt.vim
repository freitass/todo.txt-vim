" File:        todo.txt.vim
" Description: Todo.txt sorting plugin
" Author:      Leandro Freitas <david@beniamine.net>
" Licence:     Vim licence
" Website:     http://github.com/dbeniamine/todo.txt.vim
" Version:     0.3

" These two variables are parameters for the first and second call to the vim
" sort function
"   '' means no flags
"   '! i' means reverse and ignore case
"   for more information on flags, see :help sort
if (! exists("g:Todo_txt_first_level_sort_mode"))
    let g:Todo_txt_first_level_sort_mode="i"
endif
if (! exists("g:Todo_txt_second_level_sort_mode"))
    let g:Todo_txt_second_level_sort_mode="i"
endif

" Sort todo by (first) context
noremap <leader>sc :call Todo_txt_TwoLevelsSort('@')<CR>
" Sort todo by (first) project
noremap <leader>sp :call Todo_txt_TwoLevelsSort('+')<CR>

" This is a two level sort designed for todo.txt todo lists
" At the first level, lines are sorted by the word right after the first
" occurence of a:symbol, there must be no space between the symbol and the
" word. Therefore, according to todo.txt syntaxt, if
"   a:symbol is a '+' it sort by the first project
"   a:symbol is an '@' it sort by the first context
" The second level of sort is done direcetly on the line, so according to
" todo.txt syntax, it means sort by priority
function! Todo_txt_TwoLevelsSort(symbol)
    "if the sort modes doesn't start by '!' it must start with a space
    let l:sortmode=Todo_txt_InsertSpaceIfNeeded(g:Todo_txt_first_level_sort_mode)
    let l:sortmode2=Todo_txt_InsertSpaceIfNeeded(g:Todo_txt_second_level_sort_mode)

    " Count the number of lines
    let l:position= getpos(".")
    execute "silent normal g\<c-g>"
    if v:statusmsg =~ '--No lines in buffer--'
        "Empty buffer do nothing
        return
    endif
    let l:linecount=str2nr(split(v:statusmsg)[7])

    " Get all the groups names
    let l:curline=0
    let l:groups=[]
    while l:curline <= l:linecount
        let l:curproj=strpart(matchstr(getline(l:curline),a:symbol.'\a*'),1)
        if l:curproj != "" && index(l:groups,l:curproj) == -1
            let l:groups=add(l:groups , l:curproj)
        endif
        let l:curline += 1
    endwhile

    " Sort by groups
    execute 'sort'.l:sortmode.' /.\{-}\ze'.a:symbol.'/'
    for l:p in l:groups
        execute '/^.\{-}'.a:symbol.l:p.'.*$'
        normal ma
        normal G
        execute '?^.\{-}'.a:symbol.l:p.'.*$'
        normal mb
        execute "'a,'b sort".l:sortmode2
    endfor
    " Restore the cursor position
    call setpos('.', position)
endfunction

function! Todo_txt_InsertSpaceIfNeeded(str)
    let l:c=strpart(a:str,1,1)
    if( l:c != '!' && l:c !=' ')
        return " ".a:str
    endif
    retur a:str
endfunction
