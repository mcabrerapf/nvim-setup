# Vim cheatsheet
# :h index to see all bindings
-----------------------
### ===> NORMAL MODE
["]                     ===> access a register
["%]                    ===> get the current relative path
[0]                     ===> start of line ([$] end)
[^]                     ===> move to first ([g_] last) character in line
[%]                     ===> go to matching pair
[{n}%]                  ===> go to percentage of file, ie 50% half of the file
[']                     ===> go to mark 
['']                    ===> go to previous jump location 
[*]                     ===> show all matches at current cursor position (with a word selected after * do :%s//{new_word}/g the // is the searched value)
[+]                     ===> next line first character ([-] previous) same as <CR> same as <C-m>
[,]                     ===> repeats last find command backwards ([;] for forwards)
[.]                     ===> repeats las command
[;]                     ===> repeats last find command forward
[/]                     ===> start search (n and N to scroll forwards and back)
[==]                    ===> fix indentation in line ([gg=G] indent whole file)
[@]                     ===> play macro ([@@] redo last macro)
[i]                     ===> insert before ([I] line)
[a]                     ===> insert after ([A] line)
[m]                     ===> add mark (use upper case to set marks in different files)
[o]                     ===> new line ([O] before)
[p]                     ===> paste ([P] paste before)
[C-a]                   ===> increment ([C-x] decrease) number at cursor
[u]                     ===> undo ([U] line)
[C-r]                   ===> redo
[C-v]                   ===> start block select
[G]                     ===> move to last line
[H]                     ===> move to top of the screen
[J]                     ===> join lines with space ([gJ] no space)
[L]                     ===> move to bottom of the screen
[M]                     ===> move to middle of the screen
[R]                     ===> enter REPLACE mode
[ZQ]                    ===> quit no save 
[ZZ]                    ===> save and quit
[b]                     ===> move to prev word (B includes punctuation)
[c]                     ===> replace ([cc] or [C] replace entire line)
[d]                     ===> delete ([dd] entire line) ([D] end of line)
[e]                     ===> move to end of word (E includes punctuation)
[f]                     ===> jump to next ocurrance of character (F for previous)
[q]                     ===> record macro to register
[q:]                    ===> enter command-lin window (command line with insert support)
[r]                     ===> replace one character
[s]                     ===> delete char and enter INSERT mode ([S] for entire line)
[t]                     ===> jump to before next ocurrance of character(T for previous)
[v]                     ===> visual mode([V] line, [C-V] block mode)
[w]                     ===> move to next word (W includes punctuation)
[x]                     ===> delete at cursor
[y]                     ===> yanking ([Y] to the end of line)
[g*]                    ===> show partial matches
[gd]                    ===> go to local([gD] global) definition 
[ge]                    ===> move back to end of word ([gE] includes punctuation)
[gf]                    ===> go to file at cursor
[gg=G]                  ===> fix indents
[gg]                    ===> move to first line
[gi]                    ===> go to last instert
[gj]                    ===> move cursor down([k] up) in multi line text
[gn]                    ===> find next ([gN] prev) from previous search and visually highlight it
[gO]                    ===> show an outline of the current file
[gp]                    ===> paste after cursor and leave cursor after([gP] before) the new text
[gt]                    ===> go to next tab
[gu]                    ===> lower([U] upper, [~] toggle) at cursor requires motion ([w][e]etc..)
[gv]                    ===> reselct text
[gw]                    ===> format
[gx]                    ===> open url in browser
[{n}G]                  ===> move to line
|g&|                    ===> repeat last ":s" on all lines
[vab]                   ===> select block within {} or [] or ()
[za]                    ===> toggle fold under the cursor
[zz]                    ===> centers on cursor
[~]                     ===> toggle cappitalization
[}]                     ===> jump to next ([{] prev) paragraph (or function/block, when editing code)
[C-g]                   ===> to show your location in a file and the file status.
[C-i]                   ===> jump to previous jump point ([C-j] for next)
[C-ws]                  ===> split window
[C-wv]                  ===> split window vertically
[C-ww]                  ===> switch windows
[C-wq]                  ===> quit a window
[C-wx]                  ===> exchange current window with next one
[C-w=]                  ===> make all windows equal height & width
[[spacebar]             ===> adds empty line before (]spacebar after) line

### === INSERT MODE
[C-a]                   ===> insert last insert
[C-w]                   ===> delete word before the cursor during insert mode
[C-u]                   ===> delete line until cursor
[C-m]                   ===> new line
[C-j]                   ===> same as <CR>
[C-t]                   ===> indent([C-d] deindent) line one shiftwidth during insert mode
[C-n]                   ===> insert (auto-complete) next([C-p] previous) match before the cursor during insert mode
[C-r]                   ===> insert the contents of register x
[C-o]                   ===> Temporarily enter normal mode to issue one normal-mode command x.
[C-gj]                  ===> go to line below ([C-gk] above)

### === VISUAL MODE
[o]                     ===> move to end([O] start) of marked area
[ab]                    ===> a block with () or [a(]
[aB]                    ===> a block with {} [a{]
[at]                    ===> a block with <> tags
[ib]                    ===> inner block with () [i(]
[iB]                    ===> inner block with {} [i{]
[it]                    ===> inner block with <> tags
[>]                     ===> shift text right
[<]                     ===> shift text left

### === COMMANDS
[:!]                    ===> to run shell commands
[:{start},{end}d]       ===> delete lines {start} to {end}
[:{start},{end}t.]      ===> copy lines {start} to {end} to cursor (use '{mark} instead of . to send to mark)
[:{start},{end}m.]      ===> move lines {start} to {end} to cursor
[:s]                    ===> search and replace in current line (start with % to apply to entire document) followed by regular expression, (ie :%s/word/new_word/g changes all word to new_word, add c to confirm on each) (ie :#,#s/old/new/g chantes old to new from line # to #
)
[:noh]                  ===> clear search results
[:w]                    ===> write (save) the file, but don't exit
[:wq]                   ===> write (save) and quit(or [:x] or [ZZ])
[:q]                    ===> quit (fails if there are unsaved changes)
[:q!]                   ===> quit and throw away unsaved changes (or [ZQ])
[:wqa]                  ===> write save and quit all
[:g/{pattern}/d]        ===> delete all lines containing pattern
[:g!/{pattern}/d]       ===> delete all lines not containing pattern
[:find {file_name}]     ===> go to file

### === GLOBAL COMMAND :g/{pattern}/{cmd}
[:g/{pattern}]          ===> prints all lines with the pattern
[:g/{pattern}/d]        ===> deletes all lines with the pattern
[:g!/{pattern}/d]       ===> deletes all lines without the pattern (g! is the same as using v)  s


#### === EXTRAS
- register [=] is an expression register (command line)
- select something and do [:norm ithis text is at the start]
- create a bunch of 0. do vip to select the elements and [g C-+a] to create a numbered list
- in insert mode [C-j] works as Enter
- in insert mode [C-w] deletes the previous word
- in insert mode [C-o] puts you in normal mode and goes back to insert after a single command 


# FIX FOR TREESITER ON WINDOWS
Download MSYS2 from
https://www.msys2.org

Inside the MSYS2 MSYS terminal, run:
pacman -Syu

Run again:

pacman -Syu

Repeat until there are no more updates.

pacman -S --needed mingw-w64-x86_64-gcc

Press Win + R, type:

sysdm.cpl

Go to Advanced → Environment Variables

Under User variables, select Path → Edit

Add this new entry:

C:\msys64\mingw64\bin

gcc --version

Under User variables, click New

Set:

Name: CC
Value: gcc

####
Inspired by https://vim.rtorr.com/
####

