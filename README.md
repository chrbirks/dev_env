# Development environment
Configuration files for Bash, tmux, spacemacs, etc.

# Spacemacs shortcuts
To enable gtags/ctags/cctags: Add "gtags" to dotspacemacs-configuration-layers
- Navigate to a file in my project
- Type `SPC m g c` to create tags
- Select root directory of project to create tags and hit enter
- Choose 'pygment' (out of ctags, pygment, etc)
- Verify "Success: create TAGS"
- Check the root directory of the project and see GPATH, GRTAGS, and GTAGS
- Put the cursor over the name of an interface being implemented by a class
- Hit `SPC m g d` to run helm-gtags-find-tag

## Navigation
These shortcuts are a mix of native vi and spacemacs shortcuts.

| Shortcut | Description |
| -------- | ----------- |
|`w` | Go right a word|
|`5w` | Go right 5 words|
|`b` | Go left a word|
|`e` | Go to the end of a word|
|`0` | Go to the line beginning|
|`_` | Go to first non-white character|
|`$` | Go to the line end|
|`gg` | Go to the beginning of file|
|`G` | Go to the end of file|
|`22j` | Go 22 lines down|
|`SPC SPC <first letter of word>` | Jump to any word|
|`C-o` | Jump back to last position|
|`g ;` | Go to last place edited|
|`g f` | Go to file path under cursor|
|`SPC j l` | Avy go to line|
|`SPC j j` | Avy go to char|
|`zz` | Scroll and place line in the center of the screen|
|`zt` | Scroll and place line in the top of the screen|
|`zb` | Scroll and place line in the bottom of the screen|
|`C-d` | Move half page down|
|`C-u` | Move half page up|
|`C-b` | Move page up|
|`C-f` | Move page down|
|`C-y` | Move view pane up|
|`C-e` | Move view pane down|
|`{` | Go up to the next paragraph|
|`}` | Go down to the next paragraph|
|`[[` | Go to the previous function|
|`]]` | Go to the next function|
|`[{` | Go up to outer brace|
|`]}` | Go down to outer brace|

## Visual mode
Press `v` to enter visual mode so you can highlight text).
Use the arrow keys (or h,j,k,l,w,b,$) to highlight.

Spacemacs adds another Visual mode via the expand-region mode.

| Shortcut | Description |
| -------- | ----------- |
|`SPC v` | initiate expand-region mode|
|`v` | expand the region by one semantic unit|
|`V` | contract the region by one semantic unit|
|`r` | reset the region to initial selection|
|`ESC` | leave expand-region mode|

## Editing
| Shortcut | Description |
| -------- | ----------- |
|`i` | Insert before cursor|
|`a` | Insert after cursor|
|`I` | Insert at line beginning|
|`A` | Insert at line end|
|`O` | Insert above line|
|`o` | Insert below line|
|`y` | Copy highlighted text|
|`yw` | Copy word|
|`yy` | Copy line|
|`y$` | Copy from cursor to end of line|
|`p/P` | Paste before/after cursor|
|`d` | Delete highlighted text|
|`dw` | Delete word|
|`dd` | Delete line|
|`x` | Delete character|
|`df(` | Delete from cursor to ( (including)|
|`dt(` | Delete from cursor to ( (excluding)|
|`di(` | Delete text inside ()|
|`cw` | Replace word|
|`ci(` | Replace text inside ()|
|`s` | Replace character|
|`SPC x j c` | set the justification to center|
|`SPC x j f` | set the justification to full|
|`SPC x j l` | set the justification to left|
|`SPC x j n` | set the justification to none|
|`SPC x j r` | set the justification to right|
|`SPC x J` | move down a line of text (enter transient state)|
|`SPC x K` | move up a line of text (enter transient state)|
|`SPC x l d` | duplicate line or region|
|`SPC x l s` | sort lines|
|`SPC x l u` | uniquify lines|
|`SPC x o` | use avy to select a link in the frame and open it|
|`SPC x O` | use avy to select multiple links in the frame and open them|
|`SPC x t c` | swap (transpose) the current character with the previous one|
|`SPC x t w` | swap (transpose) the current word with the previous one|
|`SPC x t l` | swap (transpose) the current line with the previous one|
|`SPC x u` | set the selected text to lower case|
|`SPC x U` | set the selected text to upper case|
|`SPC x w c` | count the number of occurrences per word in the select region|
|`SPC x w d` | show dictionary entry of word from wordnik.com|
|`SPC x TAB` | indent or dedent a regionf rigidly|

## Bookmarks
Bookmarks can be set anywhere in a file. Bookmarks are persistent. They are very useful to jump to/open a known project. Spacemacs uses helm-bookmarks to manage them.	
Open an helm window with the current bookmarks by pressing: `SPC f b`
Then in the helm-bookmarks buffer:
`C-d` delete the selected bookmark
`C-e` edit the selected bookmark
`C-f` toggle filename location
`C-o` open the selected bookmark in another window
To save a new bookmark, just type the name of the bookmark and press RET.

## Searching
Searching in current file

| Shortcut | Description |
| -------- | ----------- |
| `SPC s s` | search (helm-swoop) with the first found tool |
| `SPC s S` | search (helm-swoop) with the first found tool with default input |
| `SPC s a a` | Seach with ag |
| `SPC s a A` | Seach with ag with default input |
| `SPC s g g` | Search with grep |
| `SPC s g G` | Seach with grep with default input |

Searching in all open buffers visiting files	

| Shortcut | Description |
| -------- | ----------- |
| `SPC s b` | search with the first found tool |
| `SPC s B` | search with the first found tool with default input |
| `SPC s a b` | Seach with ag with default input |
| `SPC s a B` | Seach with ag with default input |
| `SPC s g b` | Search with grep |
| `SPC s g B` | Seach with grep with default input |
| `SPC s k b` | Search with ack |
| `SPC s k B` | Seach with ack with default input |
| `SPC s t b` | Search with pt |
| `SPC s t B` | Seach with pt with default input|

Searching in a project	

| Shortcut | Description |
| -------- | ----------- |
| `SPC / or SPC s p` | search with the first found tool |
| `SPC * or SPC s P` | search with the first found tool with default input |

## Projectile shortcuts
| Shortcut | Description |
| -------- | ----------- |
| `SPC p f` | find file |
| `SPC p F` | find file based on path around point |
| `SPC p h` | find file using helm |
| `SPC p g` | find tags |
| `SPC p G` | regenerate the project’s etags / gtags |
| `SPC p d` | find directory |
| `SPC p D` | open project root in dired |
| `SPC p b` | switch to project buffer |
| `SPC p r` | open a recent file |
| `SPC s a p` | run ag |
| `SPC s g p` | run grep |
| `SPC s k p` | run ack |
| `SPC s t p` | run pt |
| `SPC p R` | replace a string |
| `SPC p %` | replace a regexp |
| `SPC p t` | open NeoTree/Spacetree in projectile root |
| `SPC p T` | test project |
| `SPC p a` | toggle between implementation and test |
| `SPC p c` | compile project using projectile |
| `SPC p I` | invalidate the projectile cache |
| `SPC p k` | kill all project buffers |
| `SPC p o` | run multi-occur |
| `SPC p p` | switch project |


## Neotree/Spacetree
Spacemacs provides a quick and simple way to navigate in an unknown project file tree with NeoTree.	
To toggle the NeoTree buffer press `SPC f t` or `SPC p t` (the latter open NeoTree with the root set to the projectile project root).
The NeoTree window always has the number 0 so it does not shift the current number of the other windows. To select the NeoTree window you then use `SPC 0`.
Spacetree file tree replaces NeoTree. Press `?` to show Spacetree shortcuts.


## Version control commands
| Shortcut | Description |
| -------- | ----------- |
| `SPC p v` | Open VC window |
| `n/p` | next/prev item |
| `tab/S-tab` | next/prev folder |
| `o` | visit file in new window |
| `m/u` | mark/unmark file or folder |
| `l` | open log for selected file/window |
| `i` | register file |
| `=` | Diff marked files/folders (diff all if none marked) |
| `v` | Commit marked files/folders |
| `C-c C-c` | Finish commit message |
| `q` | quit vc-dir |

## Commenting
Comments are handled by evil-nerd-commenter, it’s bound to the following keys.

| Shortcut | Description |
| -------- | ----------- |
| `SPC ;` | comment operator |
| `SPC c h` | hide/show comments |
| `SPC c l` | comment lines |
| `SPC c L` | invert comment lines |
| `SPC c p` | comment paragraphs |
| `SPC c P` | invert comment paragraphs |
| `SPC c t` | comment to line |
| `SPC c T` | invert comment to line |
| `SPC c y` | comment and yank |
| `SPC c Y` | invert comment and yank |
| `SPC ; SPC j l` | Comment efficiently a block of lines |
		
## Regular expressions	
Spacemacs uses the packages pcre2el to manipulate regular expressions. It is useful when working with Emacs Lisp buffers since it allows to easily converts PCRE (Perl Compatible RegExp) to Emacs RegExp or rx. It can also be used to “explain” a PCRE RegExp around point in rx form.

| Shortcut | Description |
| -------- | ----------- |
| `SPC x r /` | Explain the regexp around point with rx |
| `SPC x r '` | Generate strings given by a regexp given this list is finite |
| `SPC x r t` | Replace regexp around point by the rx form or vice versa |
| `SPC x r x` | Convert regexp around point in rx form and display the result in the minibuffer |
| `SPC x r c` | Convert regexp around point to the other form and display the result in the minibuffer |
| `SPC x r e /` | Explain Emacs Lisp regexp |

## Error handling
| Shortcut | Description |
| -------- | ----------- |
| `SPC t s` | toggle flycheck |
| `SPC e c` | clear all errors |
| `SPC e h` | describe a flycheck checker |
| `SPC e l` | toggle the display of the flycheck list of errors/warnings |
| `SPC e n` | go to the next error |
| `SPC e p` | go to the previous error |
| `SPC e v` | verify flycheck setup (useful to debug 3rd party tools configuration) |
| `SPC e .` | error transient state |


## Toggles
| Shortcut | Description |
| -------- | ----------- |
| `SPC t i` | indent guidelines |
| `SPC t h a` | automatically highligh selected word |
| `SPC t r` | toggle relative/absolute line numbers |
| `SPC t L` | toggle wrapping of lines |
| `SPC T F` | Fullscreen Emacs application |
| `SPC w m` | Zoom/maximize/minimize buffer window |
| `SPC SPC global-diff-hl-mode` | Highlight version control diffs |
| `SPC SPC diff-hl-flydiff-mode` | Highlight version control diffs on the fly |
