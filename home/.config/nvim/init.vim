language en_US.utf8

" typo fixer 
command! WQ wq
command! Wq wq
command! W w
command! Q q

function SudoWriteQuit()
  w !pkexec tee %
  q!
endfunction

cnoreabbrev w!! w !pkexec tee %
cnoreabbrev wq!! call SudoWriteQuit()
cnoreabbrev W!! w !pkexec tee %
cnoreabbrev Wq!! call SudoWriteQuit()
cnoreabbrev WQ!! call SudoWriteQuit()

" scrolling
set mouse=a
map <ScrollWheelUp> <C-Y>
map <S-ScrollWheelUp> <C-U>
map <ScrollWheelDown> <C-E>
map <S-ScrollWheelDown> <C-D>

" copy paste
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+
