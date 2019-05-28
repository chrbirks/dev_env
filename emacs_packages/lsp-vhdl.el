;;; lsp-vhdl.el ---

;; Copyright (C) 2019 Christian Birk Sørensen

;; Author: Christian Birk Sørensen <chrbirks+emacs@gmail.com>
;; Created: 16 May 2019
;; Keywords: languages, lsp, vhdl

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; LSP support for VHDL using the language server from https://github.com/kraigher/rust_hdl.
;; Set the following symbol to specify the path of the language server:
;;
;; (setq lsp-vhdl-server-install-dir "/path/to/server")
;;
;; If the server binary is not found in the specified path the repository is cloned
;; from Github and the server is built.
;; The server requires a project file list called vhdl_ls.toml which must
;; be placed the the project root. An example file can be found here:
;; https://github.com/kraigher/rust_hdl/blob/master/example_project/vhdl_ls.toml

;;; Code:

(require 'lsp-mode)

(defgroup lsp-vhdl nil
  "LSP support for VHDL using the server from https://github.com/kraigher/rust_hdl"
  :group 'vhdl-mode
  :link '(url-link "https://github.com/kraigher/rust_hdl"))

(defcustom lsp-vhdl-server-install-dir
   (locate-user-emacs-file "vhdl-language-server")
   "Install directory for vhdl-language-server. This directory should contain a clone of https://github.com/kraigher/rust_hdl"
   :group 'lsp-vhdl
   :risky t
   :type 'directory)

;; FIXME: lsp-make-traverser is copied from an older version of lsp-mode
;; (defun lsp-make-traverser (name)
;;   "Return a closure that walks up the current directory until NAME is found.
;; NAME can either be a string or a predicate used for `locate-dominating-file'.
;; The value returned by the function will be the directory name for NAME.
;; If no such directory could be found, log a warning and return `default-directory'"
;;   (lambda ()
;;     (let ((dir (locate-dominating-file "." name)))
;;       (if dir
;;           (file-truename dir)
;;         (if lsp-message-project-root-warning
;;             (message "Couldn't find project root, using the current directory as the root.")
;;           (lsp-warn "Couldn't find project root, using the current directory as the root.")
;;           default-directory)))))

(defun lsp-vhdl--server-binary ()
  "Return full path to Language Server binary"
  (f-join lsp-vhdl-server-install-dir "target/release/vhdl_ls"))

(defun lsp-vhdl--ensure-server ()
  "Ensure that Language Server is installed in the specified location."
  (mkdir lsp-vhdl-server-install-dir t)
  (let ((default-directory lsp-vhdl-server-install-dir))
    (shell-command-to-string "echo $PWD")
    (setq clone-cmd (concat "git clone https://github.com/kraigher/rust_hdl.git" " " lsp-vhdl-server-install-dir))
    (message "Clone Language Server source: %s" clone-cmd)
    (setq log-cmd (shell-command-to-string clone-cmd))
    (message "%s\n" log-cmd)
    (setq build-cmd "cargo build --release")
    (message "Building Language Server...")
    (setq log-cmd (shell-command-to-string build-cmd))
    (message "%s\n" log-cmd)
    )
  )


(defun lsp-vhdl--server-init-options ()
  "Language Server init options"
  )

(defun lsp-vhdl--server-command ()
  "Return path to Language Server binary. Clone and build server if not found."
  (if (file-exists-p (lsp-vhdl--server-binary))
      (lsp-vhdl--server-binary)
    (lsp-vhdl--ensure-server)
    )
  )

(add-hook 'vhdl-mode-hook #'lsp)
(add-to-list 'lsp-language-id-configuration '(vhdl-mode . "vhdl"))

(lsp-register-client
 (make-lsp-client :new-connection (lsp-stdio-connection #'lsp-vhdl--server-command)
                  :major-modes '(vhdl-mode)
                  :priority -1
                  :language-id "VHDL"
                  :initialization-options #'lsp-vhdl--server-init-options
                  :server-id 'lsp-vhdl-mode))

(provide 'lsp-vhdl)
;;; lsp-vhdl.el ends here
