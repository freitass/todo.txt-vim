### Quick install

    git clone git://github.com/freitass/todo.txt-vim.git
    cd todo.txt-vim
    cp -R * ~/.vim


This plugin gives syntax highlighting to [todo.txt](http://todotxt.com/) files. It also defines a few mappings, to help with editing these files:

`<localleader>-s` : Sort the file

`<localleader>-s+` : Sort the file on +Projects

`<localleader>-s@` : Sort the file on @Contexts

`<localleader>-sd` : Sort the file on dates

`<localleader>-j` : Lower the priority of the current line

`<localleader>-k` : Increase the priority of the current line

`<localleader>-a` : Add the priority (A) to the current line

`<localleader>-b` : Add the priority (B) to the current line

`<localleader>-c` : Add the priority (C) to the current line

`<localleader>-d` : Insert the current date

`date<tab>`  : (Insert mode) Insert the current date

`<localleader>-x` : Mark task as done (inserts current date as completion date)

`<localleader>-X` : Mark all tasks as completed

`<localleader>-D` : Move completed tasks to done.txt

If you want the help installed, run ":helptags ~/.vim/doc" inside vim after having copied the files.
Then you will be able to get the commands help with: :h todo.txt
