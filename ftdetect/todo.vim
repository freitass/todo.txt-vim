" File:        todo.txt.vim
" Description: Todo.txt filetype detection
" Author:      David Beniamine <david@beniamine.net>, Leandro Freitas <freitass@gmail.com>
" License:     Vim license
" Website:     http://github.com/dbeniamine/todo.txt-vim
" Version:     0.7

autocmd BufNewFile,BufRead [Tt]odo.txt set filetype=todo
autocmd BufNewFile,BufRead [Dd]one.txt set filetype=todo

