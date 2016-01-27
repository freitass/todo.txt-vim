#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# File:        todo.py
# Description: Todo.txt overdue date syntax script
# License:     Vim license
# Website:     http://github.com/freitass/todo.txt-vim
# Version:     0.1

import vim
import os
import sys
from datetime import date

dateregex_dir = os.path.join(vim.eval('s:script_dir'), 'dateregex')
if os.path.isdir(dateregex_dir):
    sys.path.insert(0, dateregex_dir)

def add_due_date_syntax_highlight():
    try:
        from dateregex import regex_date_before
    except ImportError:
        print("dateregex module not found. Overdue dates won't be highlighted")
        return

    regex = regex_date_before(date.today())
    regex = r'(^|<)due:%s(>|$)' % regex

    vim.command("syntax match OverDueDate '\\v%s'" % regex)
    vim.command("highlight  default  link  OverDueDate       Error")

add_due_date_syntax_highlight()
