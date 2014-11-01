### Quick install

    git clone git://github.com/freitass/todo.txt-vim.git
    cd todo.txt-vim
    cp -R * ~/.vim


This plugin gives syntax highlighting to [todo.txt](http://todotxt.com/) files. It also defines a few mappings, to help with editing these files:

`<leader>-s` : Sort the file

`<leader>-s+` : Sort the file on +Projects

`<leader>-s@` : Sort the file on @Contexts

`<leader>-j` : Lower the priority of the current line

`<leader>-k` : Increase the priority of the current line

`<leader>-a` : Add the priority (A) to the current line

`<leader>-b` : Add the priority (B) to the current line

`<leader>-c` : Add the priority (C) to the current line

`<leader>-d` : Insert the current date

`date<tab>`  : (Insert mode) Insert the current date

`<leader>-x` : Mark task as done (inserts current date as completion date)

`<leader>-X` : Mark all tasks as completed

`<leader>-D` : Move completed tasks to done.txt

If you want the help installed, run ":helptags ~/.vim/doc" inside vim after having copied the files.
Then you will be able to get the commands help with: :h todo.txt
