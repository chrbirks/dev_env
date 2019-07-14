;; -*- mode: emacs-lisp; lexical-binding: t -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs

   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused

   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t

   ;; If non-nil layers with lazy install support are lazy installed.
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()

   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press `SPC f e R' (Vim style) or
     ;; `M-m f e R' (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     (auto-completion :variables
                      auto-completion-front-end 'company
                      auto-completion-return-key-behavior 'complete
                      auto-completion-tab-key-behavior 'cycle
                      auto-completion-complete-with-key-sequence-delay 0.1
                      auto-completion-private-snippets-directory nil
                      auto-completion-enable-sort-by-usage t ;sort provided by the company package only and not auto-completion
                      auto-completion-enable-snippets-in-popup t
                      auto-completion-enable-help-tooltip t
                      :disabled-for
                      org
                      git)
     asm
     ;; better-defaults
     (c-c++ :variables
            ; Use ccls as LSP backend
            c-c++-backend 'lsp-ccls ; 'lsp-ccls or 'lsp-cquery
            c-c++-lsp-executable "/usr/bin/ccls"
            ; Use cquery as LSP backend
            ;; c-c++-backend 'lsp-cquery
            ;; c-c++-lsp-executable "/usr/bin/cquery"
            ; Others
            c-c++-adopt-subprojects t
            ;; c-c++-enable-clang-support t ;; auto-completion of function calls etc. (ignored when using lsp backend)
            c-c++-enable-rtags-completion t) ;; usefull for anything?
     csv
     dap ; optional requirement for lsp-ccls
     debug ; layer for interactive debuggers using realgud, e.g. gdb
     emacs-lisp
     git
     gtags; use pygments when generating tags for (System)Verilog support
     helm
     html
     imenu-list
     (java :variables
           java-backend 'lsp)
     lsp ; Language Server Protocol
     ;; (lsp :variables ; Language Server Protocol
     ;;      c-c++-backend 'lsp-ccls)
     major-modes ; adds packages for Arch PKGBUILDs, Arduino, Matlab, etc.
     markdown
     multiple-cursors
     org
     prettier
     (python :variables
             python-backend 'lsp) ;anaconda or lsp
     shell-scripts
     spacemacs-layouts
     syntax-checking
     (treemacs :variables
               treemacs-use-follow-mode t
               treemacs-use-filewatch-mode t)
     vimscript
     (version-control :variables
                      version-control-diff-side 'left
                      version-control-global-margin t
                      version-control-diff-tool 'diff-hl) ; options are diff-hl, git-gutter, git-gutter+. See version-control readme for differences.
     (shell :variables
            shell-default-height 30
            shell-default-position 'bottom)
     ;; spell-checking
     )

   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   ;; To use a local version of a package, use the `:location' property:
   ;; '(your-package :location "~/path/to/your-package/")
   ;; Also include the dependencies as they will not be resolved automatically.
   dotspacemacs-additional-packages '(;vhdl-tools
                                      ialign ;; visual align-regexp
                                      ;; deadgrip
                                      doom-themes
                                      )

   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()

   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '()

   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non-nil then enable support for the portable dumper. You'll need
   ;; to compile Emacs 27 from source following the instructions in file
   ;; EXPERIMENTAL.org at to root of the git repository.
   ;; (default nil)
   dotspacemacs-enable-emacs-pdumper nil

   ;; File path pointing to emacs 27.1 executable compiled with support
   ;; for the portable dumper (this is currently the branch pdumper).
   ;; (default "emacs-27.0.50")
   dotspacemacs-emacs-pdumper-executable-file "emacs-27.0.50"

   ;; Name of the Spacemacs dump file. This is the file will be created by the
   ;; portable dumper in the cache directory under dumps sub-directory.
   ;; To load it when starting Emacs add the parameter `--dump-file'
   ;; when invoking Emacs 27.1 executable on the command line, for instance:
   ;;   ./emacs --dump-file=~/.emacs.d/.cache/dumps/spacemacs.pdmp
   ;; (default spacemacs.pdmp)
   dotspacemacs-emacs-dumper-dump-file "spacemacs.pdmp"

   ;; If non-nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t

   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 5

   ;; Set `gc-cons-threshold' and `gc-cons-percentage' when startup finishes.
   ;; This is an advanced option and should not be changed unless you suspect
   ;; performance issues due to garbage collection operations.
   ;; (default '(100000000 0.1))
   dotspacemacs-gc-cons '(100000000 0.1)

   ;; If non-nil then Spacelpa repository is the primary source to install
   ;; a locked version of packages. If nil then Spacemacs will install the
   ;; latest version of packages from MELPA. (default nil)
   dotspacemacs-use-spacelpa nil

   ;; If non-nil then verify the signature for downloaded Spacelpa archives.
   ;; (default nil)
   dotspacemacs-verify-spacelpa-archives nil

   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update t

   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'. (default 'emacs-version)
   dotspacemacs-elpa-subdirectory 'emacs-version

   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'hybrid

   ;; If non-nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading nil

   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner nil

   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `bookmarks' `projects' `agenda' `todos'.
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists '((agenda . 2)
                                (todos . 2)
                                (recents . 2)
                                (projects . 4))

   ;; True if the home buffer should respond to resize events. (default t)
   dotspacemacs-startup-buffer-responsive t

   ;; Default major mode for a new empty buffer. Possible values are mode
   ;; names such as `text-mode'; and `nil' to use Fundamental mode.
   ;; (default `text-mode')
   dotspacemacs-new-empty-buffer-major-mode 'text-mode

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode

   ;; Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
   ;; (default nil)
   dotspacemacs-initial-scratch-message nil

   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(spacemacs-dark
                         doom-one
                         doom-city-lights
                         doom-molokai
                         doom-nord
                         subatomic
                         tangotango
                         soft-charcoal
                         apropospriate-dark
                         spacemacs-light)

   ;; Set the theme for the Spaceline. Supported themes are `spacemacs',
   ;; `all-the-icons', `custom', `doom', `vim-powerline' and `vanilla'. The
   ;; first three are spaceline themes. `doom' is the doom-emacs mode-line.
   ;; `vanilla' is default Emacs mode-line. `custom' is a user defined themes,
   ;; refer to the DOCUMENTATION.org for more info on how to create your own
   ;; spaceline theme. Value can be a symbol or list with additional properties.
   ;; (default '(spacemacs :separator wave :separator-scale 1.5))
   dotspacemacs-mode-line-theme '(spacemacs :separator arrow :separator-scale 1.5)

   ;; If non-nil the cursor color matches the state color in GUI Emacs.
   ;; (default t)
   dotspacemacs-colorize-cursor-according-to-state t

   ;; Default font, or prioritized list of fonts. `powerline-scale' allows to
   ;; quickly tweak the mode-line size to make separators look not too crappy.
   dotspacemacs-default-font '("Hack" ;"Source Code Pro" ;"Bitstream Vera Sans Mono" ;"Ubuntu Mono"
                               :size 14
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)
   ;; The leader key (default "SPC")
   dotspacemacs-leader-key "SPC"

   ;; The key used for Emacs commands `M-x' (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"

   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"

   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"

   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","

   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m")
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil

   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"

   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil

   ;; If non-nil then the last auto saved layouts are resumed automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil

   ;; If non-nil, auto-generate layout name when creating new layouts. Only has
   ;; effect when using the "jump to layout by number" commands. (default nil)
   dotspacemacs-auto-generate-layout-names nil

   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 10

   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache

   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5

   ;; If non-nil, the paste transient-state is enabled. While enabled, after you
   ;; paste something, pressing `C-j' and `C-k' several times cycles through the
   ;; elements in the `kill-ring'. (default nil)
   dotspacemacs-enable-paste-transient-state nil

   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4

   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom

   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil

   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t

   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil

   ;; If non-nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil

   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup t

   ;; If non-nil the frame is undecorated when Emacs starts up. Combine this
   ;; variable with `dotspacemacs-maximized-at-startup' in OSX to obtain
   ;; borderless fullscreen. (default nil)
   dotspacemacs-undecorated-at-startup nil

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90

   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t

   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t

   ;; If non-nil unicode symbols are displayed in the mode line.
   ;; If you use Emacs as a daemon and wants unicode characters only in GUI set
   ;; the value to quoted `display-graphic-p'. (default t)
   dotspacemacs-mode-line-unicode-symbols t

   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t

   ;; Control line numbers activation.
   ;; If set to `t', `relative' or `visual' then line numbers are enabled in all
   ;; `prog-mode' and `text-mode' derivatives. If set to `relative', line
   ;; numbers are relative. If set to `visual', line numbers are also relative,
   ;; but lines are only visual lines are counted. For example, folded lines
   ;; will not be counted and wrapped lines are counted as multiple lines.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :visual nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; When used in a plist, `visual' takes precedence over `relative'.
   ;; (default nil)
   dotspacemacs-line-numbers t

   ;; Code folding method. Possible values are `evil' and `origami'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil

   ;; If non-nil `smartparens-strict-mode' will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc…
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil

   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all

   ;; If non-nil, start an Emacs server if one is not already running.
   ;; (default nil)
   dotspacemacs-enable-server nil

   ;; Set the emacs server socket location.
   ;; If nil, uses whatever the Emacs default is, otherwise a directory path
   ;; like \"~/.emacs.d/server\". It has no effect if
   ;; `dotspacemacs-enable-server' is nil.
   ;; (default nil)
   dotspacemacs-server-socket-dir nil

   ;; If non-nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil

   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `pt', `ack' and `grep'.
   ;; (default '("rg" "ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("rg" "ag" "pt" "ack" "grep")

   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%I@%S"

   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil

   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup 'changed ; FIXME: 'changed does not work

   ;; Either nil or a number of seconds. If non-nil zone out after the specified
   ;; number of seconds. (default nil)
   dotspacemacs-zone-out-when-idle nil

   ;; Run `spacemacs/prettify-org-buffer' when
   ;; visiting README.org files of Spacemacs.
   ;; (default nil)
   dotspacemacs-pretty-docs nil))

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  ;; (add-to-list 'load-path "/home/chrbirks/github/dev_env")
  (spacemacs/load-spacemacs-env))

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."
  )

(defun dotspacemacs/user-load ()
  "Library to load while dumping.
This function is called only while dumping Spacemacs configuration. You can
`require' or `load' the libraries of your choice that will be included in the
dump."
  )

(defun dotspacemacs/user-config ()
  "Configuration for user code:
This function is called at the very end of Spacemacs startup, after layer
configuration.
Put your configuration code here, except for variables that should be set
before packages are loaded."
  (setq-default
   ;; debug-on-error t

   ;; Do not wrap lines
   truncate-lines t

   ;; Disable highlight line mode
   global-hl-line-mode nil

   ;; Do not show trailing whitespaces
   spacemacs-show-trailing-whitespace nil

   ;; Escape sequence
   evil-escape-key-sequence "fd"

   ;; Use 'verilator_bin' instead of 'verilator' which throws errors
   flycheck-verilog-verilator-executable "/usr/bin/verilator_bin"
   flycheck-vhdl-ghdl-executable "/usr/bin/ghdl"
   flycheck-ghdl-ieee-library "synopsys" ;;"standard"
   flycheck-ghdl-language-standard "08"
   ;; flycheck-ghdl-workdir "/home/chrbirks/github/dev_env/example_code/vhdl";; TODO
   ;; (flycheck-verilator-include-path ...) TODO

   ;; Compress files when access them via TRAMP
   tramp-inline-compress-start-size t
   )

  ;; ;; Delete trailing whitespaces before saving
  ;; (use-package files
  ;;   :hook
  ;;   (before-save . delete-trailing-whitespace)
  ;;   :custom
  ;;   (require-final-newline nil))

  ;; Clean up recent file buffers
  (use-package recentf
    :custom
    (recentf-auto-cleanup 30)
    :config
    (run-with-idle-timer 30 t 'recentf-save-list))

  ;; Set Avy to use actual words instead of sequences of letters (requires Avy 0.5.0)
  (setq avy-style 'words)

  ;; Settings for horizontal/vertical scrolling
  (setq scroll-margin     5              ;; Set top/bottom scroll margin in number of lines
        hscroll-margin    15             ;; Set horizontal scroll margin in number of characters
        hscroll-step      1
        auto-hscroll-mode 'current-line) ;; Scroll horizontally on the selected line only (Emacs version 26.1 or larger)
  ;; Set scroll margin to zero for terminals etc.
  (defun unset-scroll-margin()
    "Set scroll-margin to zero"
    (setq-local scroll-margin 0))
  (spacemacs/add-to-hooks
   'unset-scroll-margin
   '(messages-buffer-mode-hook
     comint-mode-hook
     term-mode-hook
     shell-mode-hook))

  ;; Remote access via TRAMP
  (require 'tramp)
  (setq tramp-default-method "sshx"
        ;; tramp-default-user-alist '(("\\`su\\(do\\)?\\'" nil "root"))
        ;; tramp-default-user "chrbirks"
        ;; tramp-default-host "192.168.1.7"
        ;; use the settings in ~/.ssh/config instead of Tramp's
        tramp-use-ssh-controlmaster-options nil
        ;; don't generate backups for remote files opened as root (security hazzard)
        backup-enable-predicate
        (lambda (name)
          (and (normal-backup-enable-predicate name)
               (not (let ((method (file-remote-p name 'method)))
                      (when (stringp method)
                        (member method '("su" "sudo"))))))))

  ;; Enable midnight-mode for automatic deletion of unused buffers (using clean-buffer-list?)
  (require 'midnight)
  (midnight-mode t)
  (midnight-delay-set 'midnight-delay 3600) ; run every hour

  ;; Parameters for clean-buffer-list mode
  (setq clean-buffer-list-delay-general 365         ; clean all open buffers not used for 365 days
        clean-buffer-list-delay-special (* 1 3600)) ; clean all open special buffers not used for 60 min

  ;; Project Management
  (require 'projectile)
  (setq projectile-globally-ignored-files
        (append '("_info"
                  "_lib.qdb"
                  "*.log"
                  "*.str"
                  "*.pyc"
                  "*.bak"
                  "*_bak"
                  "*.orig"
                  "*.jou"
                  "*.rpt"
                  "*.rpx"
                  "*.xpr"
                  "*.vdi"
                  "*.vds"
                  "*.pb"
                  "*.dcp"
                  "*.rtd"
                  "*.tar"
                  "*.qpg"
                  "syn_timing_report"
                  "fbupdate"
                  "modelsim_compile.txt")
                projectile-globally-ignored-files)
        projectile-globally-ignored-directories
        (append '(".Xil"
                  "work"))
        )

  ;; Cycle through windows
  (global-set-key (kbd "C-a") 'other-window)

  ;; Any files that end in .v, .dv, .pv or .sv should be in verilog mode
  (add-to-list 'auto-mode-alist '("\\.[dsp]?v\\'" . verilog-mode))

  ;; Replace highlighted text when typing
  (delete-selection-mode 1)

  ;; Verilog block comment macro
  (fset 'verilog-block-comment
        [?/ ?/ ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- return ?/ ?/ ?  return ?/ ?/ ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- ?- up right left ? ])
  (global-set-key (kbd "C-c c") 'verilog-block-comment)

  ;; UVM warning macro
  (fset 'uvm_warning
        (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([96 117 118 109 95 119 97 114 110 105 110 103 40 34 70 73 88 77 69 34 44 32 41 59 left left] 0 "%d")) arg)))
  (global-set-key (kbd "C-c v") 'uvm_warning)

  ;; Shortcut for switching to minibuffer
  (defun switch-to-minibuffer-window ()
    "switch to minibuffer window (if active)"
    (interactive)
    (when (active-minibuffer-window)
      (select-window (active-minibuffer-window))))
  (global-set-key (kbd "<f7>") 'switch-to-minibuffer-window)

  ;; Enable global auto completion
  (global-company-mode t)

  ;; Add verilog-mode and vhdl-mode to default-enabled flycheck modes
  (require 'flycheck)
  ;; (setq 'flycheck-global-modes t)
  (add-to-list 'flycheck-global-modes 'verilog-mode)
  (add-to-list 'flycheck-global-modes 'vhdl-mode)

  ;; Enable helm-gtags-mode
  (add-hook 'c-mode-hook 'helm-gtags-mode)
  (add-hook 'c++-mode-hook 'helm-gtags-mode)
  (add-hook 'asm-mode-hook 'helm-gtags-mode)
  (add-hook 'python-mode-hook 'helm-gtags-mode)
  (add-hook 'verilog-mode-hook 'helm-gtags-mode)
  (add-hook 'vhdl-mode-hook 'helm-gtags-mode)
  ;; Customize helm-gtags-mode
  (custom-set-variables
   '(helm-gtags-path-style (quote root))
   '(helm-gtags-display-style (quote detail))
   '(helm-gtags-direct-helm-completing t)
   '(helm-gtags-ignore-case t)
   '(helm-gtags-auto-update nil) ; do not update TAGS files when buffer is saved
   '(helm-gtags-pulse-at-cursor t)
   )
  ;; Set helm-gtags key bindings
  (eval-after-load "helm-gtags"
    '(progn
       (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-find-tag) ; find definition
       (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag) ; find references
       (define-key helm-gtags-mode-map (kbd "M-æ") 'helm-gtags-dwim) ; find definition
       (define-key helm-gtags-mode-map (kbd "M-ø") 'helm-gtags-dwim-other-window) ; find definition and open in other window
       (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol) ; find symbols
       (define-key helm-gtags-mode-map (kbd "M-g M-p") 'helm-gtags-parse-file) ; list all tags in file
       (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
       (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
       (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)))

  ;; Colorize tags (keywords) in helm-semantic-or-imenu
  (with-eval-after-load 'helm-semantic
    (push '(c-mode . semantic-format-tag-summarize) helm-semantic-display-style)
    (push '(c++-mode . semantic-format-tag-summarize) helm-semantic-display-style)
    (push '(vhdl-mode . semantic-format-tag-summarize) helm-semantic-display-style))

  ;; ;; Extend vhdl-mode with vhdl-tools-mode in vhdl-tools package (https://github.com/csantosb/vhdl-tools/wiki/Use)
  ;; (autoload 'vhdl-tools-mode "vhdl-tools")
  ;; (autoload 'vhdl-tools-vorg-mode "vhdl-tools")
  ;; ;; (require 'vhdl-tools)
  ;; (setq vhdl-tools-use-outshine t)
  ;; (require 'outshine)
  ;; (add-hook 'outline-minor-mode-hook 'outshine-hook-function)
  ;; (add-to-list 'company-begin-commands 'outshine-self-insert-command)

  ;; Set general parameters for lsp-mode
  ;; ;; Disable all lsp features except flycheck
  ;; (setq lsp-ui-doc-enable nil
  ;;       lsp-ui-peek-enable nil
  ;;       lsp-ui-sideline-enable nil
  ;;       lsp-ui-imenu-enable nil
  ;;       lsp-enable-symbol-highlighting nil
  ;;       lsp-ui-flycheck-enable t)
  ;; Enable all lsp features except symbol highlighting
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-include-signature t
        lsp-ui-doc-use-childframe nil ;TODO 17-05-2019: box is not placed correctly when t
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-symbol t
        lsp-enable-symbol-highlighting nil
        ;; lsp-ui-imenu-enable t ;TODO 17-05-2019: Does not work. Should call lsp-ui-menu which works
        lsp-ui-flycheck-enable t
        lsp-prefer-flymake nil ; 't' (flymake), 'nil' (flycheck), ':none' (None of them)
        lsp-auto-configure t ; auto-configure lsp-ui and company-lsp
        lsp-auto-guess-root t
        lsp-lens-mode t
        lsp-enable-completion-at-point t
        lsp-enable-indentation t
        lsp-enable-snippet t
        lsp-enable-on-type-formatting t
        lsp-enable-file-watchers t
        lsp-enable-xref t
        lsp-print-io nil ;FIXME: log all messages to *lsp-log* for debugging
        )

  ;; Enable lsp for all programming languages
  ;; (add-hook 'prog-mode-hook #'lsp)
  (add-hook 'java-mode-hook #'lsp)
  (add-hook 'c-mode-hook #'lsp)
  (add-hook 'c++-mode-hook #'lsp)

  ;; Load package for LSP in vhdl-mode
  ;; (setq lsp-vhdl-server-install-dir "~/github/rust_hdl")
  ;; (load-file "~/github/dev_env/emacs/emacs_packages/lsp-vhdl.el")

  ;; ;; veri-kompass for Verilog
  ;; (add-to-list 'load-path "/home/chrbirks/Downloads/veri-kompass/")
  ;; (require 'veri-kompass)
  ;; ;; Enable veri kompass minor mode mode
  ;; (add-hook 'verilog-mode-hook 'veri-kompass-minor-mode)

  '(custom-set-variables
    '(user-full-name "Christian Birk Sørensen")
    '(user-mail-address "chrbirks+emacs@gmail.com")
    )

  ;; Custom Verilog settings
  '(custom-set-variables
    '(verilog-auto-delete-trailing-whitespace t)
    '(verilog-highlight-grouping-keywords nil)
    '(verilog-highlight-p1800-keywords t)
    '(verilog-highlight-modules t)
    '(verilog-tab-always-indent t)
    '(verilog-align-ifelse nil)
    '(verilog-auto-declare-nettype nil)
    '(verilog-auto-indent-on-newline t)
    '(verilog-indent-level 2)
    '(verilog-indent-level-behavioral 2)
    '(verilog-indent-level-declaration 2)
    '(verilog-indent-level-directive 1)
    '(verilog-indent-level-module 2)
    '(verilog-indent-lists t)
    )

  ;; Custom VHDL settings
  '(custom-set-variables
    '(vhdl-array-index-record-field-in-sensitivity-list t)
    '(vhdl-compiler "GHDL")
    '(vhdl-default-library "work")
    '(vhdl-hideshow-menu t)
    '(vhdl-index-menu t) ; Build file index for imenu when opened
    '(vhdl-intelligent-tab nil)
    '(vhdl-makefile-default-targets (quote ("all" "clean" "library")))
    '(vhdl-source-file-menu t) ; Add menu of all source files in current directory
    '(vhdl-speedbar-auto-open nil)
    '(vhdl-speedbar-display-mode (quote directory))
    '(vhdl-stutter-mode t) ; Enable ".." -> "=>" and other shortcuts
    '(vhdl-underscore-is-part-of-word t)
    '(vhdl-use-direct-instantiation (quote standard)) ; Only use direct instantiation of VHDL standard allows it (from '93)
    '(vhdl-company-name silicom-company-name)
    '(vhdl-date-format "%Y-%m-%d")
    '(vhdl-file-header
      "-- *************************************************************************
-- *
-- * Copyright (c) 2008-2019, <company>
-- * All rights reserved.
-- *
-- * Redistribution and use in source and binary forms, with or without
-- * modification, are permitted provided that the following conditions are met:
-- *
-- * 1. Redistributions of source code must retain the above copyright notice,
-- * this list of conditions and the following disclaimer.
-- *
-- * 2. Redistributions in binary form must reproduce the above copyright
-- * notice, this list of conditions and the following disclaimer in the
-- * documentation and/or other materials provided with the distribution.
-- *
-- * 3. Neither the name of the Silicom nor the names of its
-- * contributors may be used to endorse or promote products derived from
-- * this software without specific prior written permission.
-- *
-- * 4. This software may only be redistributed and used in connection with a
-- *  Silicom network adapter product.
-- *
-- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\"
-- * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
-- * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- * POSSIBILITY OF SUCH DAMAGE.
-- *
-- ***************************************************************************
-------------------------------------------------------------------------------
-- Title      : <title string>
-- Project    : <project>
-------------------------------------------------------------------------------
-- File       : <filename>
-- Author     : <author>
-- Company    : <company>
-- Created    : <date>
-- Platform   : <platform>
-- Standard   : <standard>
-------------------------------------------------------------------------------
-- Description: <cursor>
-------------------------------------------------------------------------------

")
    '(vhdl-align-groups t)
    '(vhdl-align-same-indent t)
    '(vhdl-auto-align t)
    '(vhdl-basic-offset 3)
    '(vhdl-beautify-options (quote (nil t t t t)))
    ;; '(vhdl-comment-only-line-offset 0)
    '(vhdl-electric-mode nil)
    '(vhdl-end-comment-column 180)
    '(vhdl-indent-comment-like-next-code-line t)
    '(vhdl-indent-syntax-based t)
    '(vhdl-indent-tabs-mode nil)
    '(vhdl-instance-name (quote (".*" . "i_\\&")))
    '(vhdl-upper-case-attributes nil)
    '(vhdl-upper-case-constants t)
    '(vhdl-upper-case-enum-values t)
    '(vhdl-upper-case-keywords nil)
    '(vhdl-upper-case-types nil)
    )

  (use-package silicom-fw-common
    :load-path "/home/chrbirks/github/dev_env/emacs/emacs_packages/"
    :init (setq silicom-email "cbs@silicom.dk"
                silicom-name "Christian Birk Sørensen")
    :config (setq vhdl-standard (quote (8 nil))) ;; Change default VHDL standard from '93 to '08
    )

)

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(comment-style (quote indent))
 '(custom-buffer-indent 2)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (toml-mode racer flycheck-rust counsel-gtags cargo rust-mode realgud test-simple loc-changes load-relative company-plsense git-gutter-fringe+ git-gutter+ git-commit insert-shebang fish-mode disaster csv-mode cmake-mode clang-format yapfify pyvenv pytest pyenv-mode py-isort pip-requirements live-py-mode hy-mode dash-functional helm-pydoc cython-mode anaconda-mode pythonic fringe-helper with-editor flycheck-pos-tip pos-tip flycheck diff-hl helm-projectile helm-make projectile pkg-info epl ws-butler winum which-key volatile-highlights vi-tilde-fringe uuidgen use-package toc-org spaceline restart-emacs request rainbow-delimiters popwin persp-mode pcre2el org-plus-contrib org-bullets open-junk-file neotree move-text macrostep lorem-ipsum linum-relative link-hint indent-guide hungry-delete hl-todo highlight-parentheses highlight-numbers highlight-indentation helm-themes helm-swoop helm-mode-manager helm-flx helm-descbinds helm-ag google-translate golden-ratio flx-ido fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-ediff evil-args evil-anzu eval-sexp-fu elisp-slime-nav dumb-jump diminish define-word column-enforce-mode clean-aindent-mode bracketed-paste auto-highlight-symbol auto-compile aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line)))
 '(paradox-github-token t)
 '(standard-indent 2)
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-tooltip-common ((t (:inherit company-tooltip :weight bold :underline nil))))
 '(company-tooltip-common-selection ((t (:inherit company-tooltip-selection :weight bold :underline nil)))))
)