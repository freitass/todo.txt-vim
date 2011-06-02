" Vim Todo.txt plugin
" Last Change:	2011 Jun 01
" Maintainer:	Leandro Freitas <freitass@gmail.com>
" License:	This file is placed in the public domain.

if exists("g:loaded_todo")
  finish
endif

" Stop breaking lines automatically
<<<<<<< HEAD
set textwidth=0
set wrapmargin=0

"" Vim global plugin for correcting typing mistakes
"" Last Change:	2000 Oct 15
"" Maintainer:	Bram Moolenaar <Bram@vim.org>
"" License:	This file is placed in the public domain.
"
"if exists("g:loaded_typecorr")
"  finish
"endif
"let g:loaded_typecorr = 1
"
"let s:save_cpo = &cpo
"set cpo&vim
"
"iabbrev teh the
"iabbrev otehr other
"iabbrev wnat want
"iabbrev synchronisation
"	\ synchronization
"let s:count = 4
"
"if !hasmapto('<Plug>TypecorrAdd')
"  map <unique> <Leader>a  <Plug>TypecorrAdd
"endif
"noremap <unique> <script> <Plug>TypecorrAdd  <SID>Add
"
"noremenu <script> Plugin.Add\ Correction      <SID>Add
"
"noremap <SID>Add  :call <SID>Add(expand("<cword>"), 1)<CR>
"
"function s:Add(from, correct)
"  let to = input("type the correction for " . a:from . ": ")
"  exe ":iabbrev " . a:from . " " . to
"  if a:correct | exe "normal viws\<C-R>\" \b\e" | endif
"  let s:count = s:count + 1
"  echo s:count . " corrections now"
"endfunction
"
"if !exists(":Correct")
"  command -nargs=1  Correct  :call s:Add(<q-args>, 0)
"endif
"
"let &cpo = s:save_cpo

let g:loaded_todo = 1
=======
setlocal textwidth=0
setlocal wrapmargin=0
>>>>>>> c53c15dc2ca63f8b92faa665c8f4187a19487425
