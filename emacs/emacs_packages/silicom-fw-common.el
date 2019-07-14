;;; silicom-fw-common.el ---

;; Copyright (C) 2019 Christian Birk Sørensen

;; Author: Christian Birk Sørensen <chrbirks+emacs@gmail.com>
;; Created: 16 May 2019
;; Keywords: languages, vhdl

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

;;; Code:

(defgroup silicom-fw-common nil
  "Enforce coding guidelines for VHDL and (System)Verilog."
  )

(defcustom silicom-email "name@company.com"
  "Silicom email"
  :group 'silicom-fw-common
  :risky t
  :type 'string
  )

(defcustom silicom-name "Anonymous"
  "Full name"
  :group 'silicom-fw-common
  :risky t
  :type 'string)

;; Common settings
(setq silicom-company-name "Silicom Denmark A/S")
(custom-set-variables
 '(user-full-name silicom-name)
 '(user-mail-address silicom-email)
 )

;; VHDL settings
(custom-set-variables
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

;; Verilog settings
(setq verilog-company silicom-company-name)

;; Define Verilog header
(define-skeleton silicom--verilog-sk-header-tmpl
  "Insert a comment block containing the module title, author, etc."
  "[Description]: "
  "//                              -*- Mode: Verilog -*-"
  "\n// Filename        : " (buffer-name)
  "\n// Description     : " str
  "\n// FIXME          : " (user-full-name)
  "\n// Created On      : " (current-time-string)
  "\n// Last Modified By: " (user-full-name)
  "\n// Last Modified On: " (current-time-string)
  "\n// Update Count    : 0"
  "\n// Status          : Unknown, Use with caution!"
  "\n")

;; Override default Verilog header function verilog-sk-header
(with-eval-after-load 'verilog-mode
  (defun verilog-sk-header ()
    "Insert a descriptive header at the top of the file.
See also `verilog-header' for an alternative format."
    (interactive "*")
    (save-excursion
      (goto-char (point-min))
      (silicom--verilog-sk-header-tmpl)))
  )

'(custom-set-variables
  '(verilog-align-ifelse nil)
  '(verilog-auto-declare-nettype nil)
  '(verilog-auto-indent-on-newline t)
  '(verilog-indent-level 2)
  '(verilog-indent-level-behavioral 2)
  '(verilog-indent-level-declaration 2)
  '(verilog-indent-level-directive 1)
  '(verilog-indent-level-module 2)
  '(verilog-indent-lists t))

(provide 'silicom-fw-common)
;;; silicom-fw-common.el ends here
