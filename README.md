# Development environment
Configuration files for Bash, tmux, spacemacs, etc.

# Spacemacs
To get information about what a specific shortcut is bound to run <kbd>C-h k</kbd>.

## ELPA package manager (paradox)
Note: do not use this manager for installing packages since they won't be persisten this way. And do not update packages here either since it does not support roll-back. Use the "Update Packages" function on the Spacemacs loading page.

| Shortcut | Description |
| -------- | ----------- |
| <kbd>SPC a k</kbd> | Launch paradox |
| ... <kbd>/</kbd> | Evil-search |
| ... <kbd>f k</kbd> | Filter by keywords |
| ... <kbd>f r</kbd> | Filter by regexp |
| ... <kbd>f u</kbd> | Display only installed packages with updates available |
| ... <kbd>L</kbd>   | Display list of updates for selected package |
| ... <kbd>o</kbd> | Open package homepage |
| ... <kbd>r</kbd> | Refresh |
| ... <kbd>S P</kbd> | Sort by name |
| ... <kbd>S S</kbd> | Sort by status |
| ... <kbd>v</kbd> | Visual state |
| ... <kbd>x</kbd> | Execute (action flags) |

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

Shortcuts defined above:

| Shortcut | Description |
| -------- | ----------- |
| <kbd>M-t</kbd>                | find definition |
| <kbd>M-r</kbd>                | find references |
| <kbd>M-s</kbd>                | find symbols |
| <kbd>M-g</kbd> <kbd>M-p</kbd> | list all tags in file |
| <kbd>C-c</kbd> <kbd><</kbd>   | `helm-gtags-previous-history` |
| <kbd>C-c</kbd> <kbd>></kbd>   | `helm-gtags-next-history` |
| <kbd>M-,</kbd>                | `helm-gtags-pop-stack` |

Shortcuts in the major mode menu:

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

### Vi recording
| Shortcut | Description |
| -------- | ----------- |
|<kbd>q [register name]</kbd> | start recording into register |
|<kbd>q</kbd>                 | stop recording |
|<kbd>@ [register name]</kbd> | run recording from register |

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
|<kbd>SPC d</kbd> | jump to entry, keep focus |
|<kbd>SPC f</kbd> | fold/unfold current section |
|<kbd>SPC r</kbd> | refresh imenu window |

### Editing
| Shortcut | Description |
| -------- | ----------- |
|<kbd>i</kbd> | Insert before cursor|
|<kbd>a</kbd> | Insert after cursor|
|<kbd>I</kbd> | Insert at line beginning|
|<kbd>A</kbd> | Insert at line end|
|<kbd>O</kbd> | Insert above line|
|<kbd>o</kbd> | Insert below line|
|<kbd>y</kbd> | Copy highlighted text|
|<kbd>y w</kbd> | Copy word|
|<kbd>y y</kbd> | Copy line|
|<kbd>y $</kbd> | Copy from cursor to end of line|
|<kbd>p/P</kbd> | Paste before/after cursor|
|<kbd>d</kbd> | Delete highlighted text|
|<kbd>d w</kbd> | Delete word|
|<kbd>d d</kbd> | Delete line|
|<kbd>x</kbd>  | Delete character|
|<kbd>d f (</kbd> | Delete from cursor to ( (including)|
|<kbd>d t (</kbd> | Delete from cursor to ( (excluding)|
|<kbd>d i (</kbd> | Delete text inside ()|
|<kbd>c w</kbd> | Replace word|
|<kbd>c i (</kbd> | Replace text inside ()|
|<kbd>s</kbd> | Replace character|
|<kbd>SPC x j c</kbd> | set the justification to center|
|<kbd>SPC x j f</kbd>      | set the justification to full|
|<kbd>SPC x j l</kbd> | set the justification to left|
|<kbd>SPC x j n</kbd> | set the justification to none|
|<kbd>SPC x j r</kbd> | set the justification to right|
|<kbd>SPC x J</kbd> | move down a line of text (enter transient state)|
|<kbd>SPC x K</kbd>  | move up a line of text (enter transient state)|
|<kbd>SPC x l d</kbd> | duplicate line or region|
|<kbd>SPC x l s</kbd> | sort lines|
|<kbd>SPC x l u</kbd> | uniquify lines|
|<kbd>SPC x o</kbd>   | use avy to select a link in the frame and open it|
|<kbd>SPC x O</kbd> | use avy to select multiple links in the frame and open them|
|<kbd>SPC x t c</kbd> | swap (transpose) the current character with the previous one|
|<kbd>SPC x t w</kbd> | swap (transpose) the current word with the previous one|
|<kbd>SPC x t l</kbd> | swap (transpose) the current line with the previous one|
|<kbd>SPC x u</kbd> | set the selected text to lower case|
|<kbd>SPC x U</kbd> | set the selected text to upper case|
|<kbd>SPC x w c</kbd> | count the number of occurrences per word in the select region|
|<kbd>SPC x w d</kbd> | show dictionary entry of word from wordnik.com|
|<kbd>SPC x TAB</kbd> | indent or dedent a regionf rigidly|

### Bookmarks
Bookmarks can be set anywhere in a file. Bookmarks are persistent. They are very useful to jump to/open a known project. Spacemacs uses helm-bookmarks to manage them.	
Open an helm window with the current bookmarks by pressing: <kbd>SPC f b</kbd>
Then in the helm-bookmarks buffer:
<kbd>C-d</kbd> delete the selected bookmark
<kbd>C-e</kbd> edit the selected bookmark
<kbd>C-f</kbd> toggle filename location
<kbd>C-o</kbd> open the selected bookmark in another window
To save a new bookmark, just type the name of the bookmark and press RET.

### Searching
Searching in current file

| Shortcut | Description |
| -------- | ----------- |
| <kbd>SPC s s</kbd> | search (helm-swoop) with the first found tool |
| <kbd>SPC s S</kbd>  | search (helm-swoop) with the first found tool with default input |
| <kbd>SPC s a a</kbd> | Seach with ag |
| <kbd>SPC s a A</kbd> | Seach with ag with default input |
| <kbd>SPC s g g</kbd> | Search with grep |
| <kbd>SPC s g G</kbd> | Seach with grep with default input |
| <kbd>SPC s h</kbd> | Highlight word |

Searching in all open buffers visiting files	

| Shortcut | Description |
| -------- | ----------- |
| <kbd>SPC s s b</kbd> | search with the first found tool |
| <kbd>SPC s s B</kbd> | search with the first found tool with default input |
| <kbd>SPC s a b</kbd> | Seach with ag with default input |
| <kbd>SPC s a B</kbd> | Seach with ag with default input |
| <kbd>SPC s g b</kbd> | Search with grep |
| <kbd>SPC s g B</kbd> | Seach with grep with default input |
| <kbd>SPC s k b</kbd> | Search with ack |
| <kbd>SPC s k B</kbd> | Seach with ack with default input |
| <kbd>SPC s t b</kbd> | Search with pt |
| <kbd>SPC s t B</kbd> | Seach with pt with default input|
| <kbd>SPC s C-s</kbd> | Search in all open buffers |

Searching in a project	

| Shortcut | Description |
| -------- | ----------- |
| <kbd>SPC /</kbd> or <kbd>SPC s p</kbd> | search with the first found tool |
| <kbd>SPC *</kbd> or <kbd>SPC s P</kbd> | search with the first found tool with default input |
| <kbd>... C-c C-e</kbd> | enter iedit mode to edit search result, e.g. seach and replace in project |
| <kbd>SPC s e</kbd> | enter iedit state on selected word |
| <kbd>C-c C-c</kbd> | commit changes after leaving iedit state |

Searching with `iedit`

| Shortcut | Description |
| -------- | ----------- |
| <kbd>SPC s e</kbd> | open `iedit-mode` on selected word |
| ... <kbd>n/N</kbd> | next/previous occurence |
| ... <kbd>F</kbd> | restrict occurences to function (depending on file type) |
| ... <kbd>L</kbd> | restrict occurence to selected line |
| ... <kbd>J/K</kbd> | add line below/above |
| ... <kbd>TAB</kbd> | toggle selected occurence on/off |
| ... <kbd>i</kbd> | enter edit mode |

### Projectile shortcuts
| Shortcut | Description |
| -------- | ----------- |
| <kbd>SPC p f</kbd> | find file |
| <kbd>SPC p F</kbd> | find file based on path around point |
| <kbd>SPC p h</kbd> | find file using helm |
| <kbd>SPC p g</kbd> | find tags |
| <kbd>SPC p G</kbd> | regenerate the project’s etags / gtags |
| <kbd>SPC p d</kbd> | find directory |
| <kbd>SPC p D</kbd> | open project root in dired |
| <kbd>SPC p b</kbd> | switch to project buffer |
| <kbd>SPC p r</kbd> | open a recent file |
| <kbd>SPC s a p </kbd> | run ag |
| <kbd>SPC s g p </kbd> | run grep |
| <kbd>SPC s k p</kbd> | run ack |
| <kbd>SPC s t p</kbd>   | run pt |
| <kbd>SPC p R</kbd> | replace a string |
| <kbd>SPC p %</kbd> | replace a regexp |
| <kbd>SPC p t</kbd> | open NeoTree/Spacetree in projectile root |
| <kbd>SPC p T</kbd> | test project |
| <kbd>SPC p a</kbd> | toggle between implementation and test |
| <kbd>SPC p c</kbd> | compile project using projectile |
| <kbd>SPC p I</kbd> | invalidate the projectile cache |
| <kbd>SPC p k</kbd> | kill all project buffers |
| <kbd>SPC p o</kbd> | run multi-occur |
| <kbd>SPC p p</kbd> | switch project |


### Treemacs
Spacemacs provides a quick and simple way to navigate in an unknown project file tree with `neotree` layer (replaced by `treemacs` in newest version).	
To toggle the `treemacs` buffer press <kbd>SPC f t</kbd> or <kbd>SPC p t</kbd> (the latter open `treemacs` with the root set to the projectile project root).
The `neotree` window always has the number 0 so it does not shift the current number of the other windows. To select the `neotree` window you then use <kbd>SPC 0</kbd>.
`treemacs` file tree replaces `neotree`. Press <kbd>?</kbd> to show `treemacs` shortcuts.

| Shortcut | Description |
| -------- | ----------- |
| <kbd>SPC f t</kbd> | open/close neotree/treemacs  |
| <kbd>SPC p t</kbd> | open/close neotree/treemacs in project mode |
| <kbd>SPC f T</kbd> | open/close neotree/treemacs and shift focus |
| <kbd>SPC f B</kbd> | find and select a bookmark |
| <kbd>SPC 0</kbd> | focus on tree window |

Inside treemacs:

| Shortcut | Description |
| -------- | ----------- |
| ... <kbd>?</kbd> | show shortcuts |
| ... <kbd>j/k</kbd> | go to next/previous line |
| ... <kbd>TAB</kbd> | expand folder or file to see functions and variables |
| ... <kbd>C-c C-p a</kbd> | select new project to add to workspace |
| ... <kbd>C-c C-p r</kbd> | rename project in workspace |
| ... <kbd>C-c C-p d</kbd> | remove project at point from workspace |
| ... <kbd>C-p r</kbd> | rename project at point |
| ... <kbd>t h</kbd> | toggle display dotfiles |
| ... <kbd>t f</kbd>      | toggle treemacs-follow-mode |
| ... <kbd>t a</kbd> | toggle treemacs-filewatch-mode |
| ... <kbd>r</kbd> | refresh |
| ... <kbd>c f</kbd> | create file |
| ... <kbd>c d</kbd> | create directory |
| ... <kbd>R</kbd> | rename selected node |
| ... <kbd>u</kbd> | select parent of selected node if possible |
| ... <kbd>q</kbd> | show/hide tree window |
| ... <kbd>o a a</kbd>  | open current file or tag using ace-window |
| ... <kbd>y r</kbd> | copy absolute path of the nearest project at point |
| ... <kbd>y y</kbd> | copy absolute path of the node at point |

### Version control commands
| Shortcut | Description |
| -------- | ----------- |
| <kbd>SPC p v</kbd> | open VC window |
| <kbd>n/p</kbd> | next/prev item |
| <kbd>TAB/S-TAB</kbd> | next/prev folder |
| <kbd>o</kbd> | visit file in new window |
| <kbd>m/u</kbd> | mark/unmark file or folder |
| <kbd>l</kbd> | open log for selected file/window |
| <kbd>i</kbd> | register file |
| <kbd>=</kbd> | Diff marked files/folders (diff all if none marked) |
| <kbd>v</kbd> | Commit marked files/folders |
| <kbd>C-c C-c</kbd> | Finish commit message |
| <kbd>q</kbd> | quit vc-dir |

### Commenting
Comments are handled by evil-nerd-commenter, it’s bound to the following keys.

| Shortcut | Description |
| -------- | ----------- |
| <kbd>SPC ;</kbd>  | comment operator |
| <kbd>SPC c h</kbd> | hide/show comments |
| <kbd>SPC c l</kbd> | comment lines |
| <kbd>SPC c L</kbd> | invert comment lines |
| <kbd>SPC c p</kbd> | comment paragraphs |
| <kbd>SPC c P</kbd> | invert comment paragraphs |
| <kbd>SPC c t</kbd> | comment to line |
| <kbd>SPC c T</kbd> | invert comment to line |
| <kbd>SPC c y</kbd> | comment and yank |
| <kbd>SPC c Y</kbd> | invert comment and yank |
| <kbd>SPC ; SPC j l</kbd> | Comment efficiently a block of lines |
		
### Regular expressions	
Spacemacs uses the packages pcre2el to manipulate regular expressions. It is useful when working with Emacs Lisp buffers since it allows to easily converts PCRE (Perl Compatible RegExp) to Emacs RegExp or rx. It can also be used to “explain” a PCRE RegExp around point in rx form.

| Shortcut | Description |
| -------- | ----------- |
| <kbd>SPC x r /</kbd> | Explain the regexp around point with rx |
| <kbd>SPC x r '</kbd> | Generate strings given by a regexp given this list is finite |
| <kbd>SPC x r t</kbd> | Replace regexp around point by the rx form or vice versa |
| <kbd>SPC x r x</kbd> | Convert regexp around point in rx form and display the result in the minibuffer |
| <kbd>SPC x r c</kbd> | Convert regexp around point to the other form and display the result in the minibuffer |
| <kbd>SPC x r e /</kbd> | Explain Emacs Lisp regexp |

### Error handling
| Shortcut | Description |
| -------- | ----------- |
| <kbd>SPC t s</kbd> | toggle flycheck/syntax highlighting (syntax-highlighting layer must be added first) |
| <kbd>SPC e c</kbd> | clear all errors |
| <kbd>SPC e h</kbd> | describe a flycheck checker |
| <kbd>SPC e l</kbd> | toggle the display of the flycheck list of errors/warnings |
| <kbd>SPC e n</kbd> | go to the next error |
| <kbd>SPC e p</kbd> | go to the previous error |
| <kbd>SPC e v</kbd> | verify flycheck setup (useful to debug 3rd party tools configuration) |
| <kbd>SPC e .</kbd> | error transient state |

### Toggles
| Shortcut | Description |
| -------- | ----------- |
| <kbd>SPC t i</kbd> | indent guidelines |
| <kbd>SPC t h a</kbd> | automatically highligh selected word |
| <kbd>SPC t r</kbd> | toggle relative/absolute line numbers |
| <kbd>SPC t L</kbd> | toggle wrapping of lines |
| <kbd>SPC T F</kbd> | Fullscreen Emacs application |
| <kbd>SPC w m</kbd> | Zoom/maximize/minimize buffer window |
| <kbd>SPC SPC global-diff-hl-mode</kbd> | Highlight version control diffs |
| <kbd>SPC SPC diff-hl-flydiff-mode</kbd> | Highlight version control diffs on the fly |

### Verilog major mode
| Shortcut | Description |
| -------- | ----------- |
| <kbd>C-c C-t</kbd>`C-c C-t` | inital shortcut |
| ... <kbd>c</kbd>`... c` | case block |
| ... <kbd>h</kbd>`... h` | header block |
| ... <kbd>u</kbd>`... u` | UVM Object block |
| ... <kbd>U</kbd>`... U` | UVM Component block |
| ... <kbd>S</kbd>`... S` | state machine |
