# Readme

## What is this plugin ?

This plugin is a fork of [freitass
todo.txt](https://github.com/freitass/todo.txt-vim). It add severals functionalities including a [hierarchical sort](#sort), a
[complete](#completion) function, some stuff to handle [due dates](#due-dates)
and others stuff see [new features](#new-features).

Freitass announced on october 30th 2014 that he is not going to merge his version.

## Install

### Quick install

    git clone https://github.com/dbeniamine/todo.txt-vim.git
    cd todo.txt-vim
    cp -r ./* ~/.vim


If you want the help installed, run `:helptags ~/.vim/doc` inside vim after
having copied the files.  Then you will be able to get the commands help with:
`:h todo.txt`

### Pathogen install

    git clone https://github.com/dbeniamine/todo.txt-vim.git ~/.vim/bundle/todo.txt-vim

Then from vim: `:Helptags` to update the doc

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

## New features

### Sort

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

### Completion

We also provide a nice complete function for project and context, to use it
add the following lines to your vimrc:

    " Use TodoComplete as the omni complete function for todo files
    au filetype todo setlocal omnifunc=TodoComplete

You can also start automatically the completion when entering '+' or '@' by
adding the next lines to your vimrc:

    " Auto complete projects
    au filetype todo imap <buffer> + +<C-X><C-O>

    " Auto complete contexts
    au filetype todo imap <buffer> @ @<C-X><C-O>

The TodoComplete function is designed to complete projects (starting by '+')
and context (starting by '@'). If you use it on a regular word, it will do a
normal keyword completion (on all buffers).
If you try to complete a project, it will propose all projects in all open
buffers and for each of them, it will show their context and the name of the
buffers in which they appears in the preview window.
TodoCompelte does the same thing for context except that it gives in the
preview the list of projects existing in each existing contexts.

### Due dates

I've integrated the [work from
durcheinandr](https://github.com/durcheinandr/todo.txt-vim/) concerning due
dates + some little improvements:

Accorrding to the todo.txt rules, one can define due dates using `due:date` or
`DUE:date` or any other  `key:value` combination. This plugins handle dates at
the format `YYYY-MM-DD` and the key `due` can be spell using any combination
of lower and upper case letters. The following mappings are provided:

`<leader>-sd` : Sort the file by due-date. Entries with a due date appears
sorted by at the beginning of the file, the rest of the file is not modified.

`due:`  : (Insert mode) Insert `due:` followed by the current date

`DUE:`  : (Insert mode) Insert `DUE:` followed by the current date

### Others

`<LocalLeader>x` is a toggle which allow you to unmark a task as done.

Syntax highlighting for couples key:value

If the current buffer is a done.txt file, the basic sort sorts on completion
date.
