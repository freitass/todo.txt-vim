# Readme

## What is this plugin ?

This plugin is a fork of freitass todo.txt (see section 1.3) vim plugin adding
a nice two level sorting function designed for todo.txt files (see section
1.4).

## Install

### Quick install

    git clone git://github.com/dbeniamine/todo.txt-vim.git
    cd todo.txt-vim
    cp -R * ~/.vim

### Pathogen install

    git clone git://github.com/dbeniamine/todo.txt-vim.git ~/.vim/bundle/todo.txt-vim

## Features included in Freitass version

This plugin gives syntax highlighting to [todo.txt](http://todotxt.com/) files. It also defines a few
mappings, to help with edition of these files:

`<LocalLeader>-s` : Sort the file

`<LocalLeader>-d` : Insert the current date

`date<tab>`  : (Insert mode) Insert the current date

`<LocalLeader>-x` : Mark task as done (inserts current date as completion date)

`<LocalLeader>-X` : Mark all tasks as completed

`<LocalLeader>-D` : Remove completed tasks

If you want the help installed run ":helptags ~/.vim/doc" inside vim after having copied the files.
Then you will be able to get the commands help with: :h todo.txt

## New features

This fork provides a hierarchical sorting function designed to do by project
and/or by context sorts and a priority sort.

`<LocalLeader>-sc` : Sort the file by context then by priority
`<LocalLeader>-scp` : Sort the file by context, project then by priority
`<LocalLeader>-sp` : Sort the file by project then by priority
`<LocalLeader>-spc` : Sort the file by project, context then by priority

The user can give argument for the two call to vim sort function by changing
the following variables in its vimrc:
see :help sort
    let g:Todo_txt_first_level_sort_mode="! i"
    let g:Todo_txt_second_level_sort_mode="i"

## Todo

Complete documentation
