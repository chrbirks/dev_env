# Development environment
Configuration files for Bash, tmux, spacemacs, etc.

# Spacemacs
To get information about what a specific shortcut is bound to run `C-h k`.

## ELPA package manager (paradox)
Note: do not use this manager for installing packages since they won't be persisten this way. And do not update packages here either since it does not support roll-back. Use the "Update Packages" function on the Spacemacs loading page.

| Shortcut | Description |
| -------- | ----------- |
| <kbd>SPC a k</kbd> | Launch paradox |
| <kbd>/</kbd> | Evil-search |
| <kbd>f k</kbd> | Filter by keywords |
| <kbd>f r</kbd> | Filter by regexp |
| <kbd>f u</kbd> | Display only installed packages with updates available |
| <kbd>o</kbd> | Open package homepage |
| <kbd>r</kbd> | Refresh |
| <kbd>S P</kbd> | Sort by name |
| <kbd>S S</kbd> | Sort by status |
| <kbd>v</kbd> | Visual state |
| <kbd>x</kbd> | Execute (action flags) |

## GTAGS
### Installation
`helm-gtags` and `ggtags` are clients for GNU Global. GNU
Global is a source code tagging system that allows querying symbol locations in
source code, such as definitions or references. Adding the `gtags` layer enables
both of these modes. See the Helm GTAGS Layer info page in Emacs for more information
(http://spacemacs.org/layers/+tags/gtags/README.html).
To use gtags you first have to install GNU Global on the OS.

`sudo pacman -S ctags python-pygments`

### Configuration
To be able to use `pygments` and `ctags`, you need to copy the sample
`gtags.conf` either to `/etc/gtags.conf` or `$HOME/.globalrc`.
Additionally you should define GTAGSLABEL in your shell startup file e.g.
with sh/ksh:

```echo export GTAGSLABEL=pygments >> .profile```

If you installed Emacs from source after ctags, your original ctags binary
is probably replaced by emacs’s etags. To get around this you will need to
configure emacs as following before installing:

`./configure --program-transform-name='s/^ctags$/ctags.emacs/'`

To check if you have the correct version of ctags execute:

`ctags --version | grep Exuberant`

If there is no output you have the wrong =ctags= executable and you need to
reinstall ctags from your package manager.

To use this configuration layer, add it to your `~/.spacemacs` file. You
will need to add `gtags` to the existing `dotspacemacs-configuration-layers`.

```
(setq dotspacemacs-configuration-layers
     '( ;; ...
        gtags
        ;; ...
       ))
```

Also add the following configuration to dotspacemacs/user-config()

```
;; Enable helm-gtags-mode
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)
(add-hook 'verilog-mode-hook 'helm-gtags-mode)
(add-hook 'vhdl-mode-hook 'helm-gtags-mode)
;; Customize helm-gtags-mode
(custom-set-variables
   '(helm-gtags-path-style 'root)
   '(helm-gtags-display-style 'detail)
   '(helm-gtags-direct-helm-completing t)
   '(helm-gtags-ignore-case t)
   '(helm-gtags-auto-update nil) ;update only when file is saved
   '(helm-gtags-pulse-at-cursor t)
   )
;; Set helm-gtags key bindings
(eval-after-load "helm-gtags"
  '(progn
     (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-find-tag) ; find definition
     (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag) ; find references
     (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol) ; find symbols
     (define-key helm-gtags-mode-map (kbd "M-g M-p") 'helm-gtags-parse-file) ; list all tags in file
     (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
     (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
     (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)))
```

Before using `gtags`, remember to create a GTAGS database by one of the following
methods:

* From within Emacs, run `helm-gtags-create-tags`, which are bound to <kbd>SPC m g C</kbd> (if the current
buffer has a major mode). Choose `pygments` as the backend to generate the database with support for the most languages.
* From inside a terminal:

```cd /path/to/project/root```

If the language is not directly supported and GTAGSLABEL is not set

```gtags --gtagslabel=pygments```

Otherwise

```gtags```

| Shortcut | Description |
| -------- | ----------- |
| <kbd>SPC m g C</kbd> | create a tag database                                     |
| <kbd>SPC m g f</kbd> | jump to a file in tag database                            |
| <kbd>SPC m g g</kbd> | jump to a location based on context                       |
| <kbd>SPC m g G</kbd> | jump to a location based on context (open another window) |
| <kbd>SPC m g d</kbd> | find definitions                                          |
| <kbd>SPC m g i</kbd> | present tags in current function only                     |
| <kbd>SPC m g l</kbd> | jump to definitions in file                               |
| <kbd>SPC m g n</kbd> | jump to next location in context stack                    |
| <kbd>SPC m g p</kbd> | jump to previous location in context stack                |
| <kbd>SPC m g r</kbd> | find references                                           |
| <kbd>SPC m g R</kbd> | resume previous helm-gtags session                        |
| <kbd>SPC m g s</kbd> | select any tag in a project retrieved by gtags            |
| <kbd>SPC m g S</kbd> | show stack of visited locations                           |
| <kbd>SPC m g y</kbd> | find symbols                                              |
| <kbd>SPC m g u</kbd> | manually update tag database  |
| <kbd>SPC m g g</kbd> | find tag |
| <kbd>SPC m g G</kbd> | regenerate tags |
| <kbd>SPC m g I</kbd> | invalidate projectile tags cache |


## Debug
The layer `debug` adds interactive debuggers for multiple languages using `realgud`, e.g. gdb.

| Shortcut | Description |
| -------- | ----------- |
|<kbd>SPC m d d</kbd> | open cmd buffer |
|<kbd>b b</kbd> | set break |
|<kbd>b c</kbd> | clear break |
|<kbd>b d</kbd> | delete break |
|<kbd>b s</kbd> | disable break |
|<kbd>b e</kbd> | enable break |
|<kbd>c</kbd> | continue |
|<kbd>i</kbd> | step into |
|<kbd>J</kbd> | jump to current line |
|<kbd>o</kbd> | step out |
|<kbd>q</kbd> | quit debugger |
|<kbd>r</kbd> | restart |
|<kbd>s</kbd> | step over |
|<kbd>S</kbd> | goto cmd buffer |
|<kbd>v</kbd> | eval variable |

## Shortcuts
### Window layouts and sessions
With the `spacemacs-layouts` layer you get access to `eyebrowse` which can group your window configuration into sessions and store/load them using names.

| Shortcut | Description |
| -------- | ----------- |
| <kbd>SPC l</kbd>    | open layouts           |
| <kbd>... 0..9</kbd> | open/create new layout |
| <kbd>... ?</kbd>    | open shortcuts window  |

### Buffer navigation
These shortcuts are a mix of native vi and spacemacs shortcuts, some of which
requires certain packages or layers to be installed.

| Shortcut | Description |
| -------- | ----------- |
|<kbd>w</kbd> | Go right a word|
|<kbd>5w</kbd> | Go right 5 words|
|<kbd>b</kbd> | Go left a word|
|<kbd>e</kbd> | Go to the end of a word|
|<kbd>0</kbd> | Go to the line beginning|
|<kbd>_</kbd> | Go to first non-white character|
|<kbd>$</kbd> | Go to the line end|
|<kbd>gg</kbd> | Go to the beginning of file|
|<kbd>G</kbd> | Go to the end of file|
|<kbd>22j</kbd> | Go 22 lines down|
|<kbd>SPC SPC first_letter_of_word</kbd> | Jump to any word|
|<kbd>C-o</kbd> | Jump back to last position|
|<kbd>g ;</kbd> | Go to last place edited|
|<kbd>g f</kbd> | Go to file path under cursor|
|<kbd>SPC j j</kbd> | Avy go to char|
|<kbd>SPC j w</kbd> | Avy go to word|
|<kbd>SPC j l</kbd> | Avy go to line|
|<kbd>SPC j b</kbd> | Avy go back|
|<kbd>z z</kbd> | Scroll and place line in the center of the screen|
|<kbd>z t</kbd> | Scroll and place line in the top of the screen|
|<kbd>z b</kbd> | Scroll and place line in the bottom of the screen|
|<kbd>C-d</kbd> | Move half page down|
|<kbd>C-u</kbd> | Move half page up|
|<kbd>C-b</kbd> | Move page up|
|<kbd>C-f</kbd> | Move page down|
|<kbd>C-y</kbd> | Move view pane up|
|<kbd>C-e</kbd> | Move view pane down|
|<kbd>{</kbd> | Go up to the next paragraph|
|<kbd>}</kbd> | Go down to the next paragraph|
|<kbd>[[</kbd> | Go to the previous function|
|<kbd>]]</kbd> | Go to the next function|
|<kbd>[{</kbd> | Go up to outer brace|
|<kbd>]}</kbd> | Go down to outer brace|

### Visual mode
Press <kbd>v</kbd> to enter visual mode so you can highlight text).
Use the arrow keys (or h,j,k,l,w,b,$) to highlight.

Spacemacs adds another Visual mode via the expand-region mode.

| Shortcut | Description |
| -------- | ----------- |
|<kbd>SPC v</kbd> | initiate expand-region mode|
|<kbd>v</kbd> | expand the region by one semantic unit|
|<kbd>V</kbd> | contract the region by one semantic unit|
|<kbd>r</kbd> | reset the region to initial selection|
|<kbd>ESC</kbd> | leave expand-region mode|

### Buffers
| Shortcut | Description |
| -------- | ----------- |
|<kbd>SPC 0-9</kbd> | open buffer in window 1..9 |
|<kbd>SPC b b</kbd> | list buffers |
|<kbd>SPC b d</kbd> | kill buffer |
|<kbd>SPC b n/p</kbd> | next/previous buffer |
|<kbd>SPC b i</kbd> | toggle imenu with buffer outline (requires imenu-list layer) |

### imenu-list
Opened with <kbd>SPC b i</kbd>

| Shortcut | Description |
| -------- | ----------- |
|<kbd>SPC q</kbd> | quit imenu |
|<kbd>SPC RET</kbd> | jump to enty |
|<kbd>SPC d</kbd>` | jump to entry, keep focus |
|<kbd>SPC f</kbd> | fold/unfold current section |
|<kbd>SPC r</kbd> | refresh imenu window |

### Editing
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

### Bookmarks
Bookmarks can be set anywhere in a file. Bookmarks are persistent. They are very useful to jump to/open a known project. Spacemacs uses helm-bookmarks to manage them.	
Open an helm window with the current bookmarks by pressing: `SPC f b`
Then in the helm-bookmarks buffer:
`C-d` delete the selected bookmark
`C-e` edit the selected bookmark
`C-f` toggle filename location
`C-o` open the selected bookmark in another window
To save a new bookmark, just type the name of the bookmark and press RET.

### Searching
Searching in current file

| Shortcut | Description |
| -------- | ----------- |
| `SPC s s` | search (helm-swoop) with the first found tool |
| `SPC s S` | search (helm-swoop) with the first found tool with default input |
| `SPC s a a` | Seach with ag |
| `SPC s a A` | Seach with ag with default input |
| `SPC s g g` | Search with grep |
| `SPC s g G` | Seach with grep with default input |
| `SPC s h` | Highlight word |

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
| `SPC s C-s` | Search in all open buffers |

Searching in a project	

| Shortcut | Description |
| -------- | ----------- |
| `SPC / or SPC s p` | search with the first found tool |
| `SPC * or SPC s P` | search with the first found tool with default input |
| `... C-c C-e`      | enter iedit mode to edit search result, e.g. seach and replace in project |
| `... SPC s e`      | enter iedit state on selected word |
| `... C-c C-c`      | commit changes after leaving iedit state |

### Projectile shortcuts
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


### Treemacs
Spacemacs provides a quick and simple way to navigate in an unknown project file tree with `neotree` layer (replaced by `treemacs` in newest version).	
To toggle the `treemacs` buffer press `SPC f t` or `SPC p t` (the latter open `treemacs` with the root set to the projectile project root).
The `neotree` window always has the number 0 so it does not shift the current number of the other windows. To select the `neotree` window you then use `SPC 0`.
`treemacs` file tree replaces `neotree`. Press `?` to show `treemacs` shortcuts.

| Shortcut | Description |
| -------- | ----------- |
| `SPC f t` | open/close neotree/treemacs  |
| `SPC p t` | open/close neotree/treemacs in project mode |
| `SPC f T` | open/close neotree/treemacs and shift focus |
| `SPC f B` | find and select a bookmark |
| `SPC 0` | focus on tree window |

Inside treemacs:

| Shortcut | Description |
| -------- | ----------- |
| `... ?` | show shortcuts |
| `... j/k` | go to next/previous line |
| `... tab` | expand folder or file to see functions and variables |
| `... C-c C-p a` | select new project to add to workspace |
| `... C-c C-p r` | rename project in workspace |
| `... C-c C-p d` | remove project at point from workspace |
| `... C-p r` | rename project at point |
| `... th` | toggle display dotfiles |
| `... tf` | toggle treemacs-follow-mode |
| `... ta` | toggle treemacs-filewatch-mode |
| `... r` | refresh |
| `... cf` | create file |
| `... cd` | create directory |
| `... R` | rename selected node |
| `... u` | select parent of selected node if possible |
| `... q` | show/hide tree window |
| `... oaa` | open current file or tag using ace-window |
| `... yr` | copy absolute path of the nearest project at point |
| `... yy` | copy absolute path of the node at point |

### Version control commands
| Shortcut | Description |
| -------- | ----------- |
| `SPC p v` | open VC window |
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

### Commenting
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
		
### Regular expressions	
Spacemacs uses the packages pcre2el to manipulate regular expressions. It is useful when working with Emacs Lisp buffers since it allows to easily converts PCRE (Perl Compatible RegExp) to Emacs RegExp or rx. It can also be used to “explain” a PCRE RegExp around point in rx form.

| Shortcut | Description |
| -------- | ----------- |
| `SPC x r /` | Explain the regexp around point with rx |
| `SPC x r '` | Generate strings given by a regexp given this list is finite |
| `SPC x r t` | Replace regexp around point by the rx form or vice versa |
| `SPC x r x` | Convert regexp around point in rx form and display the result in the minibuffer |
| `SPC x r c` | Convert regexp around point to the other form and display the result in the minibuffer |
| `SPC x r e /` | Explain Emacs Lisp regexp |

### Error handling
| Shortcut | Description |
| -------- | ----------- |
| `SPC t s` | toggle flycheck/syntax highlighting (syntax-highlighting layer must be added first) |
| `SPC e c` | clear all errors |
| `SPC e h` | describe a flycheck checker |
| `SPC e l` | toggle the display of the flycheck list of errors/warnings |
| `SPC e n` | go to the next error |
| `SPC e p` | go to the previous error |
| `SPC e v` | verify flycheck setup (useful to debug 3rd party tools configuration) |
| `SPC e .` | error transient state |

### Toggles
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

### Verilog major mode
| Shortcut | Description |
| -------- | ----------- |
| `C-c C-t` | inital shortcut |
| `... c` | case block |
| `... h` | header block |
| `... u` | UVM Object block |
| `... U` | UVM Component block |
| `... S` | state machine |
