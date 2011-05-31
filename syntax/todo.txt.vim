" File:        todo.txt.vim
" Description: Todo.txt syntax settings
" Author:      Leandro Freitas <freitass@gmail.com>
" Licence:     Vim licence
" Website:     http://github.com/freitass/todo.txt.vim
" Version:     0.1

if exists("b:current_syntax")
    finish
endif

syntax  match  TodoDone       '^[xX]\s.*$'
syntax  match  TodoPriorityA  '^([aA])\s.*$'
syntax  match  TodoPriorityB  '^([bB])\s.*$'
syntax  match  TodoPriorityC  '^([cC])\s.*$'
syntax  match  TodoPriorityD  '^([dD])\s.*$'
syntax  match  TodoPriorityE  '^([eE])\s.*$'
syntax  match  TodoPriorityF  '^([fF])\s.*$'
syntax  match  TodoPriorityG  '^([gG])\s.*$'
syntax  match  TodoPriorityH  '^([hH])\s.*$'
syntax  match  TodoPriorityI  '^([iI])\s.*$'
syntax  match  TodoPriorityJ  '^([jJ])\s.*$'
syntax  match  TodoPriorityK  '^([kK])\s.*$'
syntax  match  TodoPriorityL  '^([lL])\s.*$'
syntax  match  TodoPriorityM  '^([mM])\s.*$'
syntax  match  TodoPriorityN  '^([nN])\s.*$'
syntax  match  TodoPriorityO  '^([oO])\s.*$'
syntax  match  TodoPriorityP  '^([pP])\s.*$'
syntax  match  TodoPriorityQ  '^([qQ])\s.*$'
syntax  match  TodoPriorityR  '^([rR])\s.*$'
syntax  match  TodoPriorityS  '^([sS])\s.*$'
syntax  match  TodoPriorityT  '^([tT])\s.*$'
syntax  match  TodoPriorityU  '^([uU])\s.*$'
syntax  match  TodoPriorityV  '^([vV])\s.*$'
syntax  match  TodoPriorityW  '^([wW])\s.*$'
syntax  match  TodoPriorityX  '^([xX])\s.*$'
syntax  match  TodoPriorityY  '^([yY])\s.*$'
syntax  match  TodoPriorityZ  '^([zZ])\s.*$'

" Other priority colours might be defined by the user
highlight  default  link  TodoDone       Comment
highlight  default  link  TodoPriorityA  Constant
highlight  default  link  TodoPriorityB  Statement
highlight  default  link  TodoPriorityC  Identifier

let b:current_syntax = "todo.txt"
