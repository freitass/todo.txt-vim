### (Apr 2015) Important note: mappings were changed!

As it was suggested on issue [#28](https://github.com/freitass/todo.txt-vim/issues/28) (and as recommended by vim's documentation), all mappings were changed to use `<localleader>` instead of `<leader>`. If you don't have `maplocalleader` set on your environment then yours is probably `\`. For more information on that regard, please take a look at `:h <Localleader>`.

### (Jan 2016) Note: Overdue date highlight and Python Optional dependency

A new feature was added to highlight dates in overdue tasks as an Error (as suggested on issue [#44](https://github.com/freitass/todo.txt-vim/issues/44)). It depends on a Python library, however, and as such will only be able to work if your version of Vim was compiled with the `+python` option (as most common versions do).

If your Vim installation does **not** have Python support, this plugin **will work just fine** but this feature will be disabled.

### Quick install

    git clone git://github.com/freitass/todo.txt-vim.git
    cd todo.txt-vim
    cp -R * ~/.vim


This plugin gives syntax highlighting to [todo.txt](http://todotxt.com/) files. It also defines a few mappings, to help with editing these files:

Sorting tasks:  
`<localleader>s`   Sort the file  
`<localleader>s+`  Sort the file on +Projects  
`<localleader>s@`  Sort the file on @Contexts  
`<localleader>sd`  Sort the file on dates  
`<localleader>sdd`  Sort the file on due dates  

Edit priority:  
`<localleader>j`   Decrease the priority of the current line  
`<localleader>k`   Increase the priority of the current line  
`<localleader>a`   Add the priority (A) to the current line  
`<localleader>b`   Add the priority (B) to the current line  
`<localleader>c`   Add the priority (C) to the current line  

Date:  
`<localleader>d`   Set current task's creation date to the current date  
`date<tab>`        (Insert mode) Insert the current date  

Mark as done:  
`<localleader>x`   Mark current task as done  
`<localleader>X`   Mark all tasks as done  
`<localleader>D`   Move completed tasks to done.txt  

This plugin detects any text file with the name todo.txt or done.txt with an optional prefix that ends in a period (e.g. second.todo.txt, example.done.txt).

If you want the help installed, run ":helptags ~/.vim/doc" inside vim after having copied the files.
Then you will be able to get the commands help with: `:h todo.txt`.
