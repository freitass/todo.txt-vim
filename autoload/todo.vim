" File:        autoload/todo.vim
" Description: Todo.txt sorting plugin
" Author:      David Beniamine <david@beniamine.net>
" Licence:     Vim licence
" Website:     http://github.com/dbeniamine/todo.txt.vim
" Version:     0.7.3
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


" Functions {{{1

" Increment and Decrement The Priority
:set nf=octal,hex,alpha

function! todo#PrioritizeIncrease()
    normal! 0f)h
endfunction

function! todo#PrioritizeDecrease()
    normal! 0f)h
endfunction

function! todo#PrioritizeAdd (priority)
    let oldpos=getcurpos()
    let line=getline('.')
    if line !~ '^([A-F])'
        :call todo#PrioritizeAddAction(a:priority)
        let oldpos[2]+=4
    else
        exec ':s/^([A-F])/('.a:priority.')/'
    endif
    call setpos('.',oldpos)
endfunction

function! todo#PrioritizeAddAction (priority)
    execute "normal! mq0i(".a:priority.") \<esc>`q"
endfunction

function! todo#RemovePriority()
    :s/^(\w)\s\+//ge
endfunction

function! todo#PrependDate()
    normal! 0"=strftime("%Y-%m-%d ")P
endfunction

function! todo#ToggleMarkAsDone()
    if (getline(".") =~ 'x\s*\d\{4\}')
        :call todo#UnMarkAsDone()
    else
        :call todo#MarkAsDone()
    endif
endfunction

function! todo#UnMarkAsDone()
    :s/\s*x\s*\d\{4}-\d\{1,2}-\d\{1,2}\s*//g
endfunction

function! todo#MarkAsDone()
    call todo#PrependDate()
    normal! Ix 
endfunction

function! todo#MarkAllAsDone()
    :g!/^x /:call todo#MarkAsDone()
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

function! todo#RemoveCompleted()
    " Check if we can write to done.txt before proceeding.
    let l:target_dir = expand('%:p:h')
    if exists("g:TodoTxtForceDoneName")
        let l:done=g:TodoTxtForceDoneName
    else
        let l:done=substitute(substitute(expand('%:t'),'todo','done',''),'Todo','Done','')
    endif
    let l:done_file = l:target_dir.'/'.l:done
    echo "Writing to ".l:done_file
    if !filewritable(l:done_file) && !filewritable(l:target_dir)
        echoerr "Can't write to file '".l:done_file."'"
        return
    endif

    let l:completed = []
    :g/^x /call add(l:completed, getline(line(".")))|d
    call s:AppendToFile(l:done_file, l:completed)
endfunction

function! todo#Sort()
    " vim :sort is usually stable
    " we sort first on contexts, then on projects and then on priority
    if expand('%')=~'[Dd]one.*.txt'
        silent! %s/\(x\s*\d\{4}\)-\(\d\{2}\)-\(\d\{2}\)/\1\2\3/g
        sort n /^x\s*/
        silent! %s/\(x\s*\d\{4}\)\(\d\{2}\)/\1-\2-/g
    else
        sort /@[a-zA-Z]*/ r
        sort /+[a-zA-Z]*/ r
        sort /\v\([A-Z]\)/ r
    endif
endfunction

function! todo#SortDue()
    silent! %s/\([dD][uU][eE]:\d\{4}\)-\(\d\{2}\)-\(\d\{2}\)/\1\2\3/g
    " Sort adding entries with due dates add the beginning
    sort n /[dD][uU][eE]:/
    " Count the number of lines
    silent normal gg
    execute "/[dD][uU][eE]:"
    let l:first=getpos(".")[1]
    silent normal N
    let l:last=getpos(".")[1]
    let l:diff=l:last-l:first+1
    " Put the sorted lines at the beginning of the file
    execute ':'.l:first
    execute ':d'.l:diff
    silent normal gg
    silent normal P
    silent! %s/\([dD][uU][eE]:\d\{4}\)\(\d\{2}\)/\1-\2-/g
    " TODO: add time sorting (YYYY-MM-DD HH:MM)
endfunction

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
function! todo#HierarchicalSort(symbol, symbolsub, dolastsort)
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
    let l:groups=GetGroups(a:symbol,1,l:linecount)
    " Sort by groups
    execute 'sort'.l:sortmode.' /.\{-}\ze'.a:symbol.'/'
    for l:g in l:groups
        let l:pat=a:symbol.l:g.'.*$'
        normal gg
        " Find the beginning of the group
        let l:groupBegin=search(l:pat,'c')
        " Find the end of the group
        let l:groupEnd=search(l:pat,'b')

        " I'm too lazy to sort groups of one line
        if(l:groupEnd==l:groupBegin)
            continue
        endif
        if a:dolastsort
            if( a:symbolsub!='')
                " Sort by subgroups
                let l:subgroups=GetGroups(a:symbolsub,l:groupBegin,l:groupEnd)
                " Go before the first line of the group
                " Sort the group using the second symbol
                for l:sg in l:subgroups
                    normal gg
                    let l:pat=a:symbol.l:g.'.*'.a:symbolsub.l:sg.'.*$\|'.a:symbolsub.l:sg.'.*'.a:symbol.l:g.'.*$'
                    " Find the beginning of the subgroup
                    let l:subgroupBegin=search(l:pat,'c')
                    " Find the end of the subgroup
                    let l:subgroupEnd=search(l:pat,'b')
                    " Sort by priority
                    execute l:subgroupBegin.','.l:subgroupEnd.'sort'.l:sortmodefinal
                endfor
            else
                " Sort by priority
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

" Completion {{{1

" Simple keyword completion on all buffers {{{2
function! TodoKeywordComplete(base)
    " Search for matchs
    let res = []
    for bufnr in range(1,bufnr('$'))
        let lines=getbufline(bufnr,1,"$")
        for line in lines
            if line =~ a:base
                " init temporary item
                let item={}
                let item.word=substitute(line,'.*\('.a:base.'\S*\).*','\1',"")
                call add(res,item)
            endif
        endfor
    endfor
    return res
endfunction

" Intelligent completion for projects and Contexts {{{2
fun! todo#Complete(findstart, base)
    if a:findstart
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] !~ '\s'
            let start -= 1
        endwhile
        return start
    else
        if a:base !~ '^+' && a:base !~ '^@'
            return TodoKeywordComplete(a:base)
        endif
        " Opposite sign
        let opp=a:base=~'+'?'@':'+'
        " Search for matchs
        let res = []
        for bufnr in range(1,bufnr('$'))
            let lines=getbufline(bufnr,1,"$")
            for line in lines
                if line =~ "[x\s0-9\-]*([a-Z]).* ".a:base
                    " init temporary item
                    let item={}
                    let item.word=substitute(line,'.*\('.a:base.'\S*\).*','\1',"")
                    let item.buffers=bufname(bufnr)
                    let item.related=substitute(line,'.*\s\('.opp.'\S\S*\).*','\1',"")
                    call add(res,item)
                endif
            endfor
        endfor
        call sort(res)
        " Here all results are sorted in res, but we need to merge them
        let ret=[]
        if res != []
            let curitem={}
            let curitem.word=res[0].word
            let curitem.related=[]
            let curitem.buffers=[]
            for it in res
                if curitem.word==it.word
                    " Merge results
                    if index(curitem.related,it.related) <0
                        call add(curitem.related,it.related)
                    endif
                    if index(curitem.buffers,it.buffers) <0
                        call add(curitem.buffers,it.buffers)
                    endif
                else
                    " Create the definitive item
                    let resitem={}
                    let resitem.word=curitem.word
                    let resitem.info=opp=='+'?"Projects":"Contexts"
                    let resitem.info.=": ".join(curitem.related, ", ")
                                \."\nBuffers: ".join(curitem.buffers, ", ")
                    call add(ret,resitem)
                    " Init new item from it
                    let curitem.word=it.word
                    let curitem.related=[it.related]
                    let curitem.buffers=[it.buffers]
                endif
            endfor
        endif
        return ret
    endif
endfun


