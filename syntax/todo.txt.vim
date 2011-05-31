" File:        todo.txt.vim
" Description: Todo.txt syntax settings
" Author:      Leandro Freitas <freitass@gmail.com>
" Licence:     Vim licence
" Website:     http://github.com/freitass/todo.txt.vim
" Version:     0.1

if exists("b:current_syntax")
    finish
endif

syntax match TodoComplete    '^[xX].*$'
syntax match TodoNoPriotity  '^[^(xX].*$'
syntax match TodoPriorityA   '^([aA]).*$'
syntax match TodoPriorityB   '^([bB]).*$'
syntax match TodoPriorityC   '^([cC]).*$'
syntax match TodoPriorityD   '^([dD]).*$'
syntax match TodoPriorityE   '^([eE]).*$'
syntax match TodoPriorityF   '^([fF]).*$'
syntax match TodoPriorityG   '^([gG]).*$'
syntax match TodoPriorityH   '^([hH]).*$'
syntax match TodoPriorityI   '^([iI]).*$'
syntax match TodoPriorityJ   '^([jJ]).*$'
syntax match TodoPriorityK   '^([kK]).*$'
syntax match TodoPriorityL   '^([lL]).*$'
syntax match TodoPriorityM   '^([mM]).*$'
syntax match TodoPriorityN   '^([nN]).*$'
syntax match TodoPriorityO   '^([oO]).*$'
syntax match TodoPriorityP   '^([pP]).*$'
syntax match TodoPriorityQ   '^([qQ]).*$'
syntax match TodoPriorityR   '^([rR]).*$'
syntax match TodoPriorityS   '^([sS]).*$'
syntax match TodoPriorityT   '^([tT]).*$'
syntax match TodoPriorityU   '^([uU]).*$'
syntax match TodoPriorityV   '^([vV]).*$'
syntax match TodoPriorityW   '^([wW]).*$'
syntax match TodoPriorityX   '^([xX]).*$'
syntax match TodoPriorityY   '^([yY]).*$'
syntax match TodoPriorityZ   '^([zZ]).*$'

highlight default TodoPriorityA guifg=Red ctermfg=Red
" TODO

let b:current_syntax = "todo.txt"
