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
                      company-tooltip-align-annotations t
                      auto-completion-return-key-behavior nil
                      auto-completion-tab-key-behavior 'complete
                      auto-completion-complete-with-key-sequence-delay 0.1
                      auto-completion-private-snippets-directory nil
                      auto-completion-enable-sort-by-usage t ;sort provided by the company package only and not auto-completion
                      auto-completion-enable-snippets-in-popup t
                      auto-completion-enable-help-tooltip t
                      auto-completion-use-company-box t
                      :disabled-for
                      org
                      git)
     asm
     (c-c++ :variables
            ; Use ccls as LSP backend
            c-c++-backend 'lsp ; 'lsp-ccls or 'lsp-cquery
            c-c++-lsp-cache-dir "~/.emacs.d/.cache/lsp-c-cpp"
            ;; c-c++-lsp-executable "/usr/bin/ccls"
            ; Use cquery as LSP backend
            ;; c-c++-backend 'lsp-cquery
            ;; c-c++-lsp-cache-dir "~/.emacs.d/.cache/lsp-cquery"
            ;; c-c++-lsp-executable "/usr/bin/cquery"
            ; Others
            c-c++-adopt-subprojects t
            c-c++-enable-clang-support t ;; auto-completion of function calls etc. (ignored when using lsp backend)
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
     lsp
     major-modes ; adds packages for Arch PKGBUILDs, Arduino, Matlab, etc.
     markdown
     multiple-cursors
     org
     prettier
     (python :variables
             python-backend 'anaconda     ; anaconda or lsp
             ;; python-lsp-server 'pyls ; pyls (default) or mspyls. See http://develop.spacemacs.org/layers/+lang/python/README.html for installation.
             )
     rust
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
     yaml
     )

   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   ;; To use a local version of a package, use the `:location' property:
   ;; '(your-package :location "~/path/to/your-package/")
   ;; Also include the dependencies as they will not be resolved automatically.
   dotspacemacs-additional-packages '(vhdl-tools ;; extended vhdl-mode
                                      ialign ;; visual align-regexp
                                      doom-themes
                                      solaire-mode
                                      posframe
                                      hydra
                                      major-mode-hydra
                                      company-box
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

   ;; Name of executable file pointing to emacs 27+. This executable must be
   ;; in your PATH.
   ;; (default "emacs")
   dotspacemacs-emacs-pdumper-executable-file "emacs"

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
   ;; (default t)
   dotspacemacs-verify-spacelpa-archives t

   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil

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
                         doom-tomorrow-night
                         doom-one
                         doom-city-lights
                         doom-nord)

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
   dotspacemacs-auto-resume-layouts t

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
   dotspacemacs-maximized-at-startup nil

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
   ;; over any automatically added closing parenthesis, bracket, quote, etc...
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
   debug-on-error nil

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

  ;; Delete trailing whitespaces before saving
  (if nil
      (use-package files
        :hook
        (before-save . delete-trailing-whitespace)
        :custom
        (require-final-newline nil))
    )

  ;; Clean up recent file buffers
  (if nil
      (use-package recentf
        :custom
        (recentf-auto-cleanup 30)
        :config
        (run-with-idle-timer 30 t 'recentf-save-list))
    ;; Enable midnight-mode for automatic deletion of unused buffers (using clean-buffer-list?)
    (require 'midnight)
    (midnight-mode t)
    (midnight-delay-set 'midnight-delay 3600) ; run every hour
    ;; Parameters for clean-buffer-list mode
    (setq clean-buffer-list-delay-general 365         ; clean all open buffers not used for 365 days
          clean-buffer-list-delay-special (* 1 3600)) ; clean all open special buffers not used for 60 min
    )

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

  ;; Project Management
  (require 'projectile)
  (setq projectile-globally-ignored-files
        ;; TODO: Move HDL/Vivado reletated files into separate VHDL/Verilog file
        ;; FIXME 03-09-2019: List does not get passed to rg. Place ignore patterns in .ignore in project root.
        (append '("_info"
                  "_lib.qdb"
                  "*.backup.log"
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
                  "*.hg"
                  "hg_info"
                  "syn_timing_report"
                  "fbupdate"
                  "modelsim_compile.txt"
                  "GRTAGS"
                  "GTAGS"
                  "GPATH")
                projectile-globally-ignored-files)
        projectile-globally-ignored-directories
        (append '(".Xil"
                  "work"
                  "obj"
                  "bit_file"))
        )

  ;; Cycle through windows
  (global-set-key (kbd "C-a") 'other-window)

  ;; Any files that end in .v, .dv, .pv or .sv should be in verilog mode
  (add-to-list 'auto-mode-alist '("\\.[dsp]?v\\'" . verilog-mode))
  ;; Add Maxeler maxj to java-mode
  (add-to-list 'auto-mode-alist '("\\.maxj\\'" . java-mode))

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

  ;; Use vterm terminal from https://github.com/akermu/emacs-libvterm
  (add-to-list 'load-path "~/github/emacs-libvterm")
  (require 'vterm)

  ;; Enable global auto completion
  (global-company-mode t)

  ;; Use icons in company autocomplete popup box
  (if nil
      (use-package all-the-icons
        :ensure t)
    (use-package company-box
      :hook (company-mode . company-box-mode))
    )

  ;; Visually distinguish file-visiting windows from other types of windows (like popups or sidebars) by giving them a slightly different -- often brighter -- background
  (use-package solaire-mode
    :hook
    ((change-major-mode after-revert ediff-prepare-buffer) . turn-on-solaire-mode)
    (minibuffer-setup . solaire-mode-in-minibuffer)
    :config
    (solaire-global-mode +1)
    (solaire-mode-swap-bg))

  ;; Add verilog-mode and vhdl-mode to default-enabled flycheck modes
  (require 'flycheck)
  ;; (setq 'flycheck-global-modes t)
  ; FIXME: Try removing these since they are part of lsp-mode
  (add-to-list 'flycheck-global-modes 'verilog-mode)
  (add-to-list 'flycheck-global-modes 'vhdl-mode)

  ;; Enable helm-gtags-mode
  (add-hook 'c-mode-hook 'helm-gtags-mode)
  (add-hook 'c++-mode-hook 'helm-gtags-mode)
  (add-hook 'asm-mode-hook 'helm-gtags-mode)
  (add-hook 'python-mode-hook 'helm-gtags-mode)
  ;; (add-hook 'verilog-mode-hook 'helm-gtags-mode)
  ;; (add-hook 'vhdl-mode-hook 'helm-gtags-mode)
  ;; Customize helm-gtags-mode
  (custom-set-variables
   '(helm-gtags-path-style (quote root))
   '(helm-gtags-display-style (quote detail))
   '(helm-gtags-direct-helm-completing t)
   '(helm-gtags-ignore-case t)
   '(helm-gtags-auto-update t) ; update TAGS files when buffer is saved
   '(helm-gtags-pulse-at-cursor t)
   )

  ;; Colorize tags (keywords) in helm-semantic-or-imenu
  (with-eval-after-load 'helm-semantic
    (push '(c-mode . semantic-format-tag-summarize) helm-semantic-display-style)
    (push '(c++-mode . semantic-format-tag-summarize) helm-semantic-display-style)
    (push '(vhdl-mode . semantic-format-tag-summarize) helm-semantic-display-style))

  ;; Extend vhdl-mode with vhdl-tools-mode in vhdl-tools package (https://github.com/csantosb/vhdl-tools/wiki/Use)
  (if nil
      (use-package vhdl-tools
        :ensure t
        :defer t
        :config
        (setq vhdl-tools-manage-folding t
              vhdl-tools-verbose nil
              vhdl-tools-use-outshine nil
              vhdl-tools-vorg-tangle-comments-link t
              vhdl-tools-recenter-nb-lines '(6)))
    (use-package vhdl
      :defer t
      :hook (vhdl-mode . (lambda ()
                           (vhdl-tools-mode 1))))
    )

  ;; Set general parameters for lsp-mode
  (setq lsp-enable-file-watchers t
        lsp-file-watch-threshold 10000)
  ;; (custom-set-faces
  ;;  '(lsp-ui-doc-background ((t (:background "magenta" :foreground "yellow"))))
  ;;  '(lsp-ui-doc-header ((t (:background "deep sky blue" :foreground "red"))))
  ;;  )
  ;; Expression for getting lsp files from server
  ; eval (lsp--directory-files-recursively "<Path of your project>" ".*" t)

  ;; ;; Disable all lsp features except flycheck
  ;; (setq lsp-ui-doc-enable nil
  ;;       lsp-ui-peek-enable nil
  ;;       lsp-ui-sideline-enable nil
  ;;       lsp-ui-imenu-enable nil
  ;;       lsp-enable-symbol-highlighting nil
  ;;       lsp-ui-flycheck-enable t)
  ;; Enable all lsp features except symbol highlighting
  (setq ; Show info from cursor
        lsp-ui-doc-enable t
        lsp-ui-doc-header nil
        lsp-ui-doc-include-signature t
        lsp-ui-doc-position 'top;'at-position
        lsp-ui-doc-alignment 'window ; 'frame or 'window
        lsp-ui-doc-use-childframe t
        lsp-ui-doc-use-webkit nil ;; Use lsp-ui-doc-webkit only in GUI. Requires compiling --width-xwidgets
        lsp-enable-symbol-highlighting t
        ; Show info from whole line
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-symbol t
        lsp-ui-sideline-ignore-duplicate t
        lsp-ui-sideline-show-code-actions t
        ; Other options
        lsp-eldoc-enable-hover nil
        lsp-eldoc-enable-signature-help t
        lsp-eldoc-prefer-signature-help t
        lsp-signature-render-all t
        lsp-eldoc-render-all t
        ;; lsp-ui-imenu-enable t ;TODO 17-05-2019: Does not work. Should call lsp-ui-imenu which works
        lsp-ui-peek-enable t
        lsp-ui-peek-always-show nil
        lsp-prefer-flymake t ; 't' (flymake), 'nil' (flycheck), ':none' (None of them)
        lsp-ui-flycheck-enable nil
        lsp-ui-flycheck-list-position 'bottom
        lsp-ui-flycheck-live-reporting t
        lsp-auto-configure t ; auto-configure lsp-ui and company-lsp
        lsp-auto-guess-root nil
        lsp-lens-mode t
        lsp-enable-completion-at-point t
        lsp-enable-indentation t
        lsp-enable-snippet t
        lsp-enable-on-type-formatting t
        lsp-enable-file-watchers t
        lsp-enable-xref t
        lsp-print-io nil ; log all messages to *lsp-log* for debugging
        )

  ;; Configure company-lsp company completion backend for lsp-mode
  (setq company-lsp-async t
        company-lsp-enable-snippet t
        company-lsp-enable-recompletion t)

  ;; Enable lsp for all programming languages
  ;; (add-hook 'prog-mode-hook #'lsp)
  ;; Enable lsp for specific programming languages
  (add-hook 'java-mode-hook #'lsp)
  (add-hook 'c-mode-hook #'lsp)
  (add-hook 'c++-mode-hook #'lsp)
  (add-hook 'python-mode #'lsp)
  (add-hook 'vhdl-mode-hook #'lsp)

  ;; Set path to vhdl-tool LSP server
  (setq lsp-vhdl-server-path "~/github/dev_env/emacs/vhdl-tool")

  ;; ;; veri-kompass for Verilog
  ;; (add-to-list 'load-path "/home/chrbirks/Downloads/veri-kompass/")
  ;; (require 'veri-kompass)
  ;; ;; Enable veri kompass minor mode mode
  ;; (add-hook 'verilog-mode-hook 'veri-kompass-minor-mode)

  ;; Custom Verilog settings
  (setq verilog-auto-delete-trailing-whitespace t
        verilog-highlight-grouping-keywords nil
        verilog-highlight-p1800-keywords t
        verilog-highlight-modules t
        verilog-tab-always-indent t
        )

  ;; Custom VHDL settings
  (setq vhdl-array-index-record-field-in-sensitivity-list t
        vhdl-compiler "GHDL"
        vhdl-default-library "work"
        vhdl-hideshow-menu t
        vhdl-index-menu t ; Build file index for imenu when opened
        vhdl-intelligent-tab nil
        vhdl-makefile-default-targets (quote ("all" "clean" "library"))
        vhdl-source-file-menu t ; Add menu of all source files in current directory
        vhdl-speedbar-auto-open nil
        vhdl-speedbar-display-mode (quote files)
        vhdl-stutter-mode t ; Enable ".." -> "=>" and other shortcuts
        vhdl-underscore-is-part-of-word t
        vhdl-use-direct-instantiation (quote standard) ; Only use direct instantiation of VHDL standard allows it (from '93)
        )

  (use-package silicom-fw-common
    :load-path "~/github/dev_env/emacs/emacs_packages/"
    :init (setq silicom-email "chrbirks+emacs@gmail.com"
                silicom-name "Christian Birk Sørensen")
    :config (setq vhdl-standard (quote (8 nil))) ;; Change default VHDL standard from '93 to '08
    )

  ;; Set custom key bindings
  ;; TODO: Set shortcuts for lsp-ui-doc/sideline mode etc.
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

  ;; Set hydra for vhdl-mode
  ;; TODO: add shortcuts for lsp-format-buffer, lsp-ui-peek-find...
  (use-package major-mode-hydra
    :ensure t
    :bind ("C-å" . major-mode-hydra))
  (major-mode-hydra-define vhdl-mode (
    :color teal
    :separator "─"
    :foreign-keys warn
    :quit-key "q")
    ("Menus"
     (("C-i" imenu-list-smart-toggle "imenu" :toggle (default-value nil))
      ("C-o" lsp-ui-imenu "lsp-ui-imenu")
      ;; ("p" helm-imenu "helm-imenu")
      )
     ;; "DeleteMe"
     ;; (("t" ert "prompt")
     ;;  ("T" (ert t) "all")
     ;;  ("F" (ert :failed) "failed"))
     "LSP"
     (
      ("C-d" lsp-ui-doc-mode "lsp-ui-doc-mode" :toggle (default-value 'lsp-ui-doc-mode))
      ("C-u" lsp-ui-sideline-mode "lsp-ui-sideline-mode" :toggle (default-value 'lsp-ui-sideline-mode))
      ("q" lsp-ui-peek-find-definitions "lsp-ui-peek-find-def")
      ("w" lsp-ui-peek-find-references "lsp-ui-peek-find-ref")
      ("e" lsp-ui-peek-find-implementation "lsp-ui-peek-find-impl")
      ("r" lsp-describe-thing-at-point "lsp-describe-thing-at-point")
      ;; ("l" lsp-execute-code-action "Execute code action")
      ("t" lsp-rename "lsp-rename")
      ("y" lsp-goto-type-definition "lsp-goto-type-def")
      ("u" lsp-goto-implementation "lsp-goto-impl")
      ("C-q" lsp-describe-session "lsp-describe-session"))
     "xref"
     (("a" xref-find-definitions "xref-find-def")
      ("s" xref-find-definitions-other-window "xref-find-def-otherwin")
      ("d" xref-find-references "xref-find-ref"))
     "GTAGS"
     (("C-g" ggtags-mode "ggtags-mode" :toggle (default-value 'ggtags-mode))
      ("M-c" helm-gtags-create-tags "helm-gtags-create-tags")
      ("M-u" helm-gtags-update-tags "helm-gtags-update-tags")
      ("M-p" helm-gtags-parse-file "helm-gtags-parse-file")
      ("M-æ" helm-gtags-dwim "helm-gtags-dwim")
      ("M-ø" helm-gtags-dwim-other-window "helm-gtags-dwim-otherwin")
      ("M-t" helm-gtags-find-tag "helm-gtags-find-tag")
      ("M-r" helm-gtags-find-rtag "helm-gtags-find-rtag")
      ("M-s" helm-gtags-find-symbol "helm-gtags-find-symbol"))
     "Misc"
     (
      ;; ("a" spacemacs/toggle-auto-completion "toggle-auto-completion" :color green :exit nil :toogle (default-value 'spacemacs/toggle-auto-completion))
      ("C-a" spacemacs/toggle-auto-completion "toggle-auto-completion" :exit nil :toogle (default-value t))
      ("C-s" spacemacs/toggle-syntax-checking "toggle-syntax-checking" :exit nil :toogle (default-value 'spacemacs/toggle-syntax-checking-status))
      ;; ("c" toggle-debug-on-error "debug-on-error " :color yellow :exit nil :toggle (default-value 'debug-on-error))
      ("C-e" toggle-debug-on-error "debug-on-error " :exit nil :toggle (default-value 'debug-on-error))
      ("C-c" vhdl-beautify-buffer "vhdl-beautify-buffer")
      ;; TODO: VHDL copy/paste commands such as vhdl-subprog-copy ...
      ;; ("q" nil "quit")
      ))
    )

)

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
  ;; This is an extra to avoid having init.el polluted by M-x customize
  (setq custom-file "~/custom.el")
  (load custom-file)
)
