# Readme

## What is this plugin ?

This plugin is a fork of freitass todo.txt (see section 1.3) vim plugin adding
a nice two level sorting function designed for todo.txt files and a complete
function for context and projects (see section 1.4).

## Install

### Quick install

    git clone https://github.com/dbeniamine/todo.txt-vim.git
    cd todo.txt-vim
    cp -r ./* ~/.vim

### Pathogen install

    git clone https://github.com/dbeniamine/todo.txt-vim.git ~/.vim/bundle/todo.txt-vim

## Features included in Freitass version

This plugin gives syntax highlighting to [todo.txt](http://todotxt.com/) files. It also defines a few mappings, to help with editing these files:

`<LocalLeader>s` : Sort the file

`<LocalLeader>s+` : Sort the file on +Projects

`<LocalLeader>s@` : Sort the file on @Contexts

`<LocalLeader>j` : Lower the priority of the current line

`<LocalLeader>k` : Increase the priority of the current line

`<LocalLeader>a` : Add the priority (A) to the current line

`<LocalLeader>b` : Add the priority (B) to the current line

`<LocalLeader>c` : Add the priority (C) to the current line

`<LocalLeader>d` : Insert the current date

`date<tab>`  : (Insert mode) Insert the current date

`<LocalLeader>x` : Toggle mark task as done (inserts current date as completion date)

`<LocalLeader>X` : Mark all tasks as completed

`<leader>-D` : Move completed tasks to done.txt

If you want the help installed, run ":helptags ~/.vim/doc" inside vim after having copied the files.
Then you will be able to get the commands help with: :h todo.txt

## New features

This fork provides a hierarchical sorting function designed to do by project
and/or by context sorts and a priority sort.

`<LocalLeader>sc` : Sort the file by context then by priority
`<LocalLeader>scp` : Sort the file by context, project then by priority
`<LocalLeader>sp` : Sort the file by project then by priority
`<LocalLeader>spc` : Sort the file by project, context then by priority

The user can give argument for the two call to vim sort function by changing
the following variables in its vimrc:
see :help sort
    let g:Todo_txt_first_level_sort_mode="! i"
    let g:Todo_txt_second_level_sort_mode="i"

Also `<LocalLeader>x` is a toggle which allow you to unmark a task as done.

We also provide a nice complete function for project and context, to use it
add the following lines to your vimrc:

    " Use TodoComplete as the omni complete function for todo files
    au filetype todo setlocal omnifunc=TodoComplete

You can also start automatically the completion when entering '+' or '@' by
adding the next lines to your vimrc:

    " Auto complete projects
    au filetype todo imap + +<C-X><C-O>

    " Auto complete contexts
    au filetype todo imap @ @<C-X><C-O>

The TodoComplete function is designed to complete projects (starting by '+')
and context (starting by '@'). If you use it on a regular word, it will do a
normal buffer completion.
If you try to complete a project, it will propose all projects in all open
buffers and for each of them, it will show their context and the name of the
buffers in which they appears in the preview window.
TodoCompelte does the same thing for context except that it gives in the
preview the list of projects existing in each existing contexts.
