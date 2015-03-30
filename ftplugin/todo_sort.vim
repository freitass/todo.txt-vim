" File:        todo.txt.vim
" Description: Todo.txt sorting plugin
" Author:      David Beniamine <david@beniamine.net>
" Licence:     Vim licence
" Website:     http://github.com/dbeniamine/todo.txt.vim
" Version:     0.5
" vim: ts=4 sw=4 :help tw=78 cc=80

" These two variables are parameters for the successive calls the vim sort
"   '' means no flags
"   '! i' means reverse and ignore case
"   for more information on flags, see :help sort
if (! exists("g:Todo_txt_first_level_sort_mode"))
    let g:Todo_txt_first_level_sort_mode='i'
endif
if (! exists("g:Todo_txt_second_level_sort_mode"))
    let g:Todo_txt_second_level_sort_mode='i'
endif
if (! exists("g:Todo_txt_third_level_sort_mode"))
    let g:Todo_txt_third_level_sort_mode='i'
endif

" Sort todo by (first) context
if !hasmapto("<localleader>sc",'n')
    noremap <localleader>sc :call Todo_txt_HierarchicalSort('@', '', 1)<CR>
endif
if !hasmapto("<localleader>scp",'n')
    noremap <localleader>scp :call Todo_txt_HierarchicalSort('@', '+', 1)<CR>
endif
" Sort todo by (first) project
if !hasmapto("<localleader>sp",'n')
    noremap <localleader>sp :call Todo_txt_HierarchicalSort('+', '',1)<CR>
endif
if !hasmapto("<localleader>spc",'n')
    noremap <localleader>spc :call Todo_txt_HierarchicalSort('+', '@',0)<CR>
endif

" This is a Hierarchical sort designed for todo.txt todo lists, however it
" might be used for other files types
" At the first level, lines are sorted by the word right after the first
" occurence of a:symbol, there must be no space between the symbol and the
" word. At the second level, the same kind of sort is done based on
" a:symbolsub, is a:symbol==' ', the second sort doesn't occurs
" Therefore, according to todo.txt syntaxt, if
"   a:symbol is a '+' it sort by the first project
"   a:symbol is an '@' it sort by the first context
" The last level of sort is done directly on the line, so according to
" todo.txt syntax, it means by priority. This sort is done if and only if the
" las argument is not 0
function! Todo_txt_HierarchicalSort(symbol, symbolsub, dolastsort)
    if v:statusmsg =~ '--No lines in buffer--'
        "Empty buffer do nothing
        return
    endif
    "if the sort modes doesn't start by '!' it must start with a space
    let l:sortmode=Todo_txt_InsertSpaceIfNeeded(g:Todo_txt_first_level_sort_mode)
    let l:sortmodesub=Todo_txt_InsertSpaceIfNeeded(g:Todo_txt_second_level_sort_mode)
    let l:sortmodefinal=Todo_txt_InsertSpaceIfNeeded(g:Todo_txt_third_level_sort_mode)

    " Count the number of lines
    let l:position= getpos(".")
    execute "silent normal g\<c-g>"
    let l:linecount=str2nr(split(v:statusmsg)[7])

    " Get all the groups names
    let l:groups=GetGroups(a:symbol,0,l:linecount)

    " Sort by groups
    execute 'sort'.l:sortmode.' /.\{-}\ze'.a:symbol.'/'
    for l:g in l:groups
        " Find the beginning of the group
        execute '/'.a:symbol.l:g.'.*$'
        let l:groupBegin=getpos(".")[1]
        " Find the end of the group
        silent normal N
        let l:groupEnd=getpos(".")[1]

        " I'm too lazy to sort one groups of one line
        if(l:groupEnd==l:groupBegin)
            continue
        endif
        if( a:symbolsub!='')
            " Sort by subgroups
            let l:subgroups=GetGroups(a:symbolsub,l:groupBegin,l:groupEnd)
            " Go before the first line of the group
            " Sort the group using the second symbol
            for l:sg in l:subgroups
                " Find the beginning of the subgroup
                execute '/'.a:symbol.l:g.'.*'.a:symbolsub.l:sg.'.*$\|'.a:symbolsub.l:sg.'.*'.a:symbol.l:g.'.*$'
                let l:subgroupBegin=getpos(".")[1]
                " Find the end of the subgroup
                silent normal N
                let l:subgroupEnd=getpos(".")[1]
                " Sort by priority
                if a:dolastsort
                    execute l:subgroupBegin.','.l:subgroupEnd.'sort'.l:sortmodefinal
                endif
            endfor
        else
            " Sort by priority
            if a:dolastsort
                execute l:groupBegin.','.l:groupEnd.'sort'.l:sortmodefinal
            endif
        endif
    endfor
    " Restore the cursor position
    call setpos('.', position)
endfunction

" Returns the list of groups starting by a:symbol between lines a:begin and
" a:end
function! GetGroups(symbol,begin, end)
    let l:curline=a:begin
    let l:groups=[]
    while l:curline <= a:end
        let l:curproj=strpart(matchstr(getline(l:curline),a:symbol.'\a*'),1)
        if l:curproj != "" && index(l:groups,l:curproj) == -1
            let l:groups=add(l:groups , l:curproj)
        endif
        let l:curline += 1
    endwhile
    return l:groups
endfunction

" Insert a space if needed (the first char isn't '!' or ' ') in front of 
" sort parameters
function! Todo_txt_InsertSpaceIfNeeded(str)
    let l:c=strpart(a:str,1,1)
    if( l:c != '!' && l:c !=' ')
        return " ".a:str
    endif
    retur a:str
endfunction
