" File:        todo.txt.vim
" Description: Todo.txt filetype detection
" Author:      Leandro Freitas <freitass@gmail.com>
" Licence:     Vim licence
" Website:     http://github.com/freitass/todo.txt.vim
" Version:     0.2

if exists("g:loaded_todo")
    finish
endif
let g:loaded_todo = 1

let s:save_cpo = &cpo
set cpo&vim

setlocal textwidth=0
setlocal wrapmargin=0

let &cpo = s:save_cpo
