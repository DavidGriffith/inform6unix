;;; inform-mode.el --- Inform mode for Emacs

;; Original-Author: Gareth Rees <Gareth.Rees@cl.cam.ac.uk>
;; Maintainer: Rupert Lane <rupert@merguez.demon.co.uk>
;; Created: 1 Dec 1994
;; Version: 1.5.0
;; Released: 27 Nov 1999
;; Keywords: languages

;;; Copyright:

;; Copyright (c) by Gareth Rees 1996
;; Portions copyright (c) by Michael Fessler 1997-1998
;; Portions copyright (c) by Rupert Lane 1999

;; inform-mode is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; inform-mode is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;;; Commentary:

;; Inform is a compiler for adventure games by Graham Nelson,
;; available by anonymous FTP from
;; /ftp.gmd.de:/if-archive/programming/inform/
;;
;; This file implements a major mode for editing Inform programs.  It
;; understands most Inform syntax and is capable of indenting lines
;; and formatting quoted strings.  Type `C-h m' within Inform mode for
;; more details.
;;
;; Because Inform header files use the extension ".h" just as C header
;; files do, the function `inform-maybe-mode' is provided.  It looks at
;; the contents of the current buffer; if it thinks the buffer is in
;; Inform, it selects inform-mode; otherwise it selects the mode given
;; by the variable `inform-maybe-other'.

;; Put this file somewhere on your load-path, and the following code in
;; your .emacs file:
;;
;;  (autoload 'inform-mode "inform-mode" "Inform editing mode." t)
;;  (autoload 'inform-maybe-mode "inform-mode" "Inform/C header editing mode.")
;;  (setq auto-mode-alist
;;        (append '(("\\.h\\'"   . inform-maybe-mode) 
;;                  ("\\.inf\\'" . inform-mode))
;;                auto-mode-alist))
;;
;; To turn on font locking add:
;; (add-hook 'inform-mode-hook 'turn-on-font-lock)

;; Please send any bugs or comments to rupert@merguez.demon.co.uk

;;; Code:

(require 'font-lock)


;;; General variables: --------------------------------------------------------

(defconst inform-mode-version "1.5.0")

(defvar inform-maybe-other 'c-mode
  "*`inform-maybe-mode' runs this if current file is not in Inform mode.")

(defvar inform-startup-message t
  "*Non-nil means display a message when Inform mode is loaded.")

(defvar inform-auto-newline t
  "*Non-nil means automatically newline before and after braces,
and after semicolons.
If you do not want a leading newline before opening braces then use:
  \(define-key inform-mode-map \"{\" 'inform-electric-semi\)")

(defvar inform-mode-map nil
  "Keymap for Inform mode.")

(if inform-mode-map nil
  (let ((map (make-sparse-keymap "Inform")))
    (setq inform-mode-map (make-sparse-keymap))
    (define-key inform-mode-map "\C-m" 'newline-and-indent)
    (define-key inform-mode-map "\177" 'backward-delete-char-untabify)
    (define-key inform-mode-map "\C-c\C-r" 'inform-retagify)
    (define-key inform-mode-map "\C-c\C-t" 'visit-tags-table)
    (define-key inform-mode-map "\C-c\C-o" 'inform-convert-old-format)
    (define-key inform-mode-map "\C-c\C-b" 'inform-build-project)
    (define-key inform-mode-map "\C-c\C-a" 'inform-toggle-auto-newline)
    (define-key inform-mode-map "\M-n" 'inform-next-object)
    (define-key inform-mode-map "\M-p" 'inform-prev-object)
    (define-key inform-mode-map "{" 'inform-electric-brace)
    (define-key inform-mode-map "}" 'inform-electric-brace)
    (define-key inform-mode-map "]" 'inform-electric-brace)
    (define-key inform-mode-map ";" 'inform-electric-semi)
    (define-key inform-mode-map ":" 'inform-electric-key)
    (define-key inform-mode-map "," 'inform-electric-comma)
    (define-key inform-mode-map [menu-bar] (make-sparse-keymap))
    (define-key inform-mode-map [menu-bar inform] (cons "Inform" map))
    (define-key map [convert] '("Convert old format" . inform-convert-old-format))
    (define-key map [separator3] '("--" . nil))
    (define-key map [load-tags] '("Load tags table" . visit-tags-table))
    (define-key map [retagify] '("Rebuild tags table" . inform-retagify))
    (define-key map [build] '("Build project" . inform-build-project))
    (define-key map [separator2] '("--" . nil))
    (define-key map [next-object] '("Next object" . inform-next-object))
    (define-key map [prev-object] '("Previous object" . inform-prev-object))
    (define-key map [separator1] '("--" . nil))
    (define-key map [comment-region] '("Comment Out Region" . comment-region))
    (put 'comment-region 'menu-enable 'mark-active)
    (define-key map [indent-region] '("Indent Region" . indent-region))
    (put 'indent-region 'menu-enable 'mark-active)
    (define-key map [indent-line] '("Indent Line" . indent-for-tab-command))))

(defvar inform-mode-abbrev-table nil
  "Abbrev table used while in Inform mode.")

(define-abbrev-table 'inform-mode-abbrev-table nil)

(defvar inform-project-file nil
  "*The top-level Inform project file to which the current file belongs.")
(make-variable-buffer-local 'inform-project-file)

(defvar inform-autoload-tags t
  "*Non-nil means automatically load tags table when entering Inform mode.")

(defvar inform-etags-program "etags"
  "The shell command with which to run the etags program.")

(defvar inform-command "inform"
  "*The shell command with which to run the Inform compiler.")

(defvar inform-libraries-directory nil
  "*If non-NIL, gives the directory in which libraries are found.")

(defvar inform-command-options ""
  "*Options with which to call the Inform compiler.")


;;; Indentation parameters: ---------------------------------------------------

(defvar inform-indent-property 8
  "*Indentation of the start of a property declaration.")

(defvar inform-indent-has-with-class 1
  "*Indentation of has/with/class lines in object declarations.")

(defvar inform-indent-level 4
  "*Indentation of lines of block relative to first line of block.")

(defvar inform-indent-label-offset -3
  "*Indentation of label relative to where it should be.")

(defvar inform-indent-cont-statement 4
  "*Indentation of continuation relative to start of statement.")

(defvar inform-indent-fixup-space t
  "*If non-NIL, fix up space in object declarations.")

(defvar inform-indent-action-column 40
  "*Column at which action names should be placed in verb declarations.")


;;; Syntax variables: ---------------------------------------------------------

(defvar inform-mode-syntax-table nil
  "Syntax table to use in Inform mode buffers.")

(if inform-mode-syntax-table
    nil
  (setq inform-mode-syntax-table (make-syntax-table))
  (modify-syntax-entry ?\\ "\\" inform-mode-syntax-table)
  (modify-syntax-entry ?\n ">" inform-mode-syntax-table)
  (modify-syntax-entry ?! "<" inform-mode-syntax-table)
  (modify-syntax-entry ?# "_" inform-mode-syntax-table)
  (modify-syntax-entry ?% "." inform-mode-syntax-table)
  (modify-syntax-entry ?& "." inform-mode-syntax-table)
  (modify-syntax-entry ?\' "." inform-mode-syntax-table)
  (modify-syntax-entry ?* "." inform-mode-syntax-table)
  (modify-syntax-entry ?- "." inform-mode-syntax-table)
  (modify-syntax-entry ?/ "." inform-mode-syntax-table)
  (modify-syntax-entry ?\; "." inform-mode-syntax-table)
  (modify-syntax-entry ?< "." inform-mode-syntax-table)
  (modify-syntax-entry ?= "." inform-mode-syntax-table)
  (modify-syntax-entry ?> "." inform-mode-syntax-table)
  (modify-syntax-entry ?+ "." inform-mode-syntax-table)
  (modify-syntax-entry ?| "." inform-mode-syntax-table))


;;; Keyword definitions-------------------------------------------------------

;; These are used for syntax and font-lock purposes.
;; They combine words used in Inform 5 and Inform 6 for full compatability.
;; You can add new keywords directly to this list as the regexps for 
;; font-locking are defined when this file is byte-compiled or eval'd.

(defvar inform-directive-list 
  '("abbreviate" "array" "attribute" "btrace" "class" "constant"
    "default" "dictionary" "end" "endif" "etrace" "extend" "fake_action"
    "global" "ifdef" "ifndef" "iftrue" "iffalse" "ifv3" "ifv5" "import"
    "include" "link" "listsymbols" "listdict" "listverbs" "lowstring"
    "ltrace" "message" "nearby" "nobtrace" "noetrace" "noltrace" "notrace"
    "object" "property" "release" "replace" "serial" "statusline" "stub"
    "switches" "system_file" "trace" "verb" "zcharacter")
  "List of Inform directives that shouldn't appear embedded in code.")

(defvar inform-defining-list
  '("[" "array" "attribute" "class" "constant" "fake_action" "global"
    "lowstring" "nearby" "object" "property")
  "List of Inform directives that define a variable/constant name.
Used to build a font-lock regexp; the name defined must follow the
keyword.")

(defvar inform-attribute-list
  '("absent" "animate" "clothing" "concealed" "container" "door"
    "edible" "enterable" "female" "general" "light" "lockable" "locked"
    "male" "moved" "neuter" "on" "open" "openable" "pluralname" "proper"
    "scenery" "scored" "static" "supporter" "switchable" "talkable"
    "transparent" "visited" "workflag" "worn")
  "List of Inform attributes defined in the library.")

(defvar inform-property-list
  '("n_to" "s_to" "e_to" "w_to" "ne_to" "se_to" "nw_to" "sw_to" "u_to"
    "d_to" "in_to" "out_to" "add_to_scope" "after" "article" "articles"
    "before" "cant_go" "capacity" "daemon" "describe" "description"
    "door_dir" "door_to" "each_turn" "found_in" "grammar" "initial"
    "inside_description" "invent" "life" "list_together" "name" "number"
    "orders" "parse_name" "plural" "react_after" "react_before"
    "short_name" "time_left" "time_out" "when_closed" "when_open"
    "when_on" "when_off" "with_key")
  "List of Inform properties defined in the library.")

(defvar inform-code-keyword-list
  '("box" "break" "continue" "do" "else" "font off" "font on" "for"
	"give" "has" "hasnt" "if" "inversion" "jump" "move" "new_line" "notin"
    "objectloop" "ofclass" "print" "print_ret" "quit" "read" "remove" 
    "restore" "return" "rfalse" "rtrue" "save" "spaces" "string" 
    "style bold" "style fixed" "style reverse" "style roman" "style underline"
    "switch" "to" "until" "while")
  "List of Inform code keywords.")

;; Some regular expressions are needed at compile-time too so as to
;; avoid postponing the work to load time.

;; To do the work of building the regexps we use regexp-opt, which has
;; different behaviour on XEmacs and GNU Emacs and may not even be 
;; available on ancient versions
(defun inform-make-regexp (strings &optional paren shy)
  (cond ((not (fboundp 'regexp-opt))
         (if (fboundp 'make-regexp)
             ;; Can we use older make-regexp?
             (make-regexp strings)
           ;; No way to make regexps
           ;; If you get this message, upgrade to a newer emacs or install
           ;; `make-regexp' from Simon Marshall's package of that name, 
           ;; which can be found at:
           ;; /src.doc.ic.ac.uk:/gnu/EmacsBits/elisp-archive/functions/make-regexp.el.Z
           (error "Neither regexp-opt nor make-regexp are available; see source code") ))
        ((string-match "XEmacs\\|Lucid" emacs-version)
         ;; XEmacs
         (regexp-opt strings paren shy))
        (t
         ;; GNU Emacs
         (regexp-opt strings))))

(eval-and-compile
  (defvar inform-directive-regexp
    (concat "#?\\("
            (inform-make-regexp inform-directive-list)
            "\\)\\>")
    "Regular expression matching an Inform directive.")

  (defvar inform-object-regexp 
    "#?\\<\\(object\\|nearby\\|class\\)\\>"
    "Regular expression matching start of object declaration."))

(defvar inform-real-object-regexp
  (eval-when-compile (concat "^" inform-object-regexp))
  "Regular expression matching the start of a real object declaration.
That is, one found at the start of a line.")

(defvar inform-label-regexp "[^:\"!\(\n]+:"
  "Regular expression matching a label.")

(defvar inform-action-regexp "\\s-*\\*"
  "Regular expression matching an action line in a verb declaration.")

(defvar inform-statement-terminators '(?\; ?{ ?} ?: ?\) do else)
  "Tokens which precede the beginning of a statement.")


;;; Font-lock keywords: -------------------------------------------------------

(defvar inform-font-lock-defaults
  '(inform-font-lock-keywords nil t ((?_ . "w")) inform-prev-object)
  "Font Lock defaults for Inform mode.")

(defvar inform-font-lock-keywords
  (eval-when-compile
    (list

	 ;; Inform code keywords
      (cons (concat "\\s-+\\("
                    (inform-make-regexp inform-code-keyword-list)
                    "\\)\\(\\s-\\|$\\|;\\)")
            'font-lock-keyword-face)

     ;; Keywords that declare variable or constant names. 
     (list (concat "^#?\\("
                   (inform-make-regexp inform-defining-list nil t)
                   "\\)\\s-+\\(\\(\\w\\|\\s_\\)+\\)")
           '(1 font-lock-keyword-face)
           '(4 font-lock-function-name-face))

     ;; Other directives.
     (cons inform-directive-regexp 'font-lock-keyword-face)

     ;; `class', `has' and `with' in objects.
     '("^\\s-+\\(class\\|has\\|with\\)\\(\\s-\\|$\\)"
       (1 font-lock-keyword-face))

    
     ;; Attributes and properties. 
     (cons (concat "\\<\\("
                   (inform-make-regexp (append inform-attribute-list
                                       inform-property-list))
                   "\\)\\>")
           font-lock-variable-name-face)))
  "Expressions to fontify in Inform mode.")


;;; Inform mode: --------------------------------------------------------------

(defun inform-mode ()
  "Major mode for editing Inform programs.

* Inform syntax:

  Type \\[indent-for-tab-command] to indent the current line.
  Type \\[indent-region] to indent the region.

  Type \\[fill-paragraph] to fill strings or comments.
  This compresses multiple spaces into single spaces.

* Multi-file projects:

  The variable `inform-project-file' gives the name of the root file of
  the project \(i.e., the one that you run Inform on\)\; it is best to
  set this as a local variable in each file, for example by making
     ! -*- inform-project-file:\"game.inf\" -*-
  the first line of the file.

* Tags tables:

  Type \\[inform-retagify] to build \(and load\) a Tags table.
  Type \\[visit-tags-table] to load an existing Tags table.
  If it exists, and if the variable `inform-autoload-tags' is non-NIL,
  the Tags table is loaded on entry to Inform Mode.
  With a Tags table loaded, type \\[find-tag] to find the declaration of
  the object, class or function under point.

* Navigating in a file:

  Type \\[inform-prev-object] to go to the previous object/class declaration.
  Type \\[inform-next-object] to go to the next one.

* Compilation:

  Type \\[inform-build-project] to build the current project.
  Type \\[next-error] to go to the next error.

* Font-lock support:

  Put \(add-hook 'inform-mode-hook 'turn-on-font-lock) in your .emacs.

* Old versions of Inform Mode:

  Versions of Inform Mode prior to 0.5 used tab stops every 4 characters
  to control the formatting.  This was the Wrong Thing To Do.
  Type \\[inform-convert-old-format] to undo the broken formatting.

* Key definitions:

\\{inform-mode-map}
* Functions:

  inform-maybe-mode
    Looks at the contents of a file, guesses whether it is an Inform
    program, runs `inform-mode' if so, or `inform-maybe-other' if not.
    The latter defaults to `c-mode'.  Used for header files which might
    be Inform or C programs.

* Miscellaneous user options:

  inform-startup-message
    Set to nil to inhibit message first time Inform mode is used.

  inform-maybe-other
    The mode used by `inform-maybe-mode' if it guesses that the file is
    not an Inform program.

  inform-mode-hook
    This hook is run after entry to Inform Mode.

  inform-autoload-tags
    If non-nil, then a tags table will automatically be loaded when
    entering Inform mode.

  inform-auto-newline
    If non-nil, then newlines are automatically inserted before and
    after braces, and after semicolons in Inform code, and after commas
    in object declarations.

* User options controlling indentation style:

  Values in parentheses are the default indentation style.

  inform-indent-property \(8\)
    Indentation of a property or attribute in an object declaration.

  inform-indent-has-with-class \(1\)
    Indentation of has/with/class lines in object declaration.

  inform-indent-level \(4\)
    Indentation of line of code in a block relative to the first line of
    the block.

  inform-indent-label-offset \(-3\)
    Indentation of a line starting with a label, relative to the
    indentation if the label were absent.

  inform-indent-cont-statement \(4\)
    Indentation of second and subsequent lines of a statement, relative
    to the first.

  inform-indent-fixup-space \(T\)
    If non-NIL, fix up space after `Object', `Class', `Nearby', `has'
    and `with', so that all the object's properties line up.

  inform-indent-action-column \(40\)
    Column at which action names should be placed in verb declarations.
    If NIL, then action names are not moved.

* User options to do with compilation:

  inform-command
    The shell command with which to run the Inform compiler.

  inform-libraries-directory
    If non-NIL, gives the directory in which the Inform libraries are
    found.

  inform-command-options
    Additional options with which to call the Inform compiler.

* Please send any bugs or comments to rupert@merguez.demon.co.uk
"
  
  (interactive)
  (if inform-startup-message
      (message "Emacs Inform mode version %s." inform-mode-version))
  (kill-all-local-variables)
  (use-local-map inform-mode-map)
  (set-syntax-table inform-mode-syntax-table)
  (make-local-variable 'comment-column)
  (make-local-variable 'comment-end)
  (make-local-variable 'comment-indent-function)
  (make-local-variable 'comment-start)
  (make-local-variable 'comment-start-skip)
  (make-local-variable 'fill-paragraph-function)
  (make-local-variable 'font-lock-defaults)
  (make-local-variable 'imenu-extract-index-name-function)
  (make-local-variable 'imenu-prev-index-position-function)
  (make-local-variable 'indent-line-function)
  (make-local-variable 'indent-region-function)
  (make-local-variable 'parse-sexp-ignore-comments)
  (make-local-variable 'require-final-newline)
  (setq comment-column 40
	comment-end ""
	comment-indent-function 'inform-comment-indent
	comment-start "!"
	comment-start-skip "!+\\s-*"
	fill-paragraph-function 'inform-fill-paragraph
	font-lock-defaults inform-font-lock-defaults
        imenu-extract-index-name-function 'inform-imenu-extract-name
        imenu-prev-index-position-function 'inform-prev-object
	indent-line-function 'inform-indent-line
	indent-region-function 'inform-indent-region
	inform-startup-message nil
	local-abbrev-table inform-mode-abbrev-table
	major-mode 'inform-mode
	mode-name "Inform"
	parse-sexp-ignore-comments t
	require-final-newline t)
  (auto-fill-mode 1)
  (if inform-autoload-tags
      (inform-auto-load-tags-table))
  (run-hooks 'inform-mode-hook))

(defun inform-maybe-mode ()
  "Starts Inform mode if file is in Inform; `inform-maybe-other' otherwise."
  (let ((case-fold-search t))
    (if (save-excursion
	  (re-search-forward
	   "^\\(!\\|object\\|nearby\\|\\[ \\)"
	   nil t))
	(inform-mode)
      (funcall inform-maybe-other))))


;;; Syntax and indentation: ---------------------------------------------------

;; Go to the start of the current Inform definition.  Just goes to the
;; most recent line with a function beginning [, or a directive.

(defun inform-beginning-of-defun ()
  (let ((case-fold-search t))
    (catch 'found
      (end-of-line 1)
      (while (re-search-backward "\n[[#a-z]" nil 'move)
	(forward-char 1)
	(if (or (and (looking-at "\\[")
		     (eq (inform-preceding-char) ?\;))
		(looking-at inform-directive-regexp))
	    (throw 'found nil))
	(forward-char -1)))))

;; Returns preceding non-blank, non-comment character in buffer.  It is
;; assumed that point is not inside a string or comment.

(defun inform-preceding-char ()
  (save-excursion
    (while (/= (point) (progn (forward-comment -1) (point))))
    (skip-syntax-backward " ")
    (if (bobp) ?\;
      (preceding-char))))

;; Returns preceding non-blank, non-comment token in buffer, either the
;; character itself, or the tokens 'do or 'else.  It is assumed that
;; point is not inside a string or comment.

(defun inform-preceding-token ()
  (save-excursion
    (while (/= (point) (progn (forward-comment -1) (point))))
    (skip-syntax-backward " ")
    (if (bobp) ?\;
      (let ((p (preceding-char)))
	(cond ((and (eq p ?o)
		    (>= (- (point) 2) (point-min)))
	       (goto-char (- (point) 2))
	       (if (looking-at "\\<do") 'do p))
	      ((and (eq p ?e)
		    (>= (- (point) 4) (point-min)))
	       (goto-char (- (point) 4))
	       (if (looking-at "\\<else") 'else p))
	      (t p))))))

;; `inform-syntax-class' returns a list describing the syntax at point.

;; Optional argument DEFUN-START gives the point from which parsing
;; should start, and DATA is the list returned by a previous invocation
;; of `inform-syntax-class'.

;; The returned list is of the form (SYNTAX IN-OBJ SEXPS STATE).
;; SYNTAX is one of

;;  directive  An Inform directive (given by `inform-directive-list')
;;  has        The "has" keyword
;;  with       The "with" keyword
;;  class      The "class" keyword
;;  property   A property or attribute
;;  other      Any other line not in a function body
;;  string     The line begins inside a string
;;  comment    The line starts with a comment
;;  label      Line contains a label (i.e. has a colon in it)
;;  code       Any other line inside a function body
;;  blank      A blank line
;;  action     An action line in a verb declaration

;; IN-OBJ is non-NIL if the line appears to be inside an Object, Nearby,
;; or Class declaration.

;; SEXPS is a list of pairs (D . P) where P is the start of a sexp
;; containing point and D is its nesting depth.  The pairs are in
;; descreasing order of nesting depth.

;; STATE is the list returned by `parse-partial-sexp'.

;; For reasons of speed, `inform-syntax-class' looks for directives only
;; at the start of lines.  If the source contains top-level directives
;; not at the start of lines, or anything else at the start of a line
;; that might be mistaken for a directive, the wrong syntax class may be
;; returned.

;; There are circumstances in which SEXPS might not be complete (namely
;; if there were multiple opening brackets and some but not all have
;; been closed since the last call to `inform-syntax-class'), and rare
;; circumstances in which it might be wrong (namely if there are
;; multiple closing brackets and fewer, but at least two, opening
;; bracket since the last call).  I consider these cases not worth
;; worrying about - and the speed hit of checking for them is
;; considerable.

(defun inform-syntax-class (&optional defun-start data)
  (let ((line-start (point))
	in-obj state
	(case-fold-search t))
    (save-excursion
      (cond (defun-start
	      (setq state (parse-partial-sexp defun-start line-start nil nil
					      (nth 3 data)))
	      (setq in-obj
		    (cond ((or (> (car state) 0) (nth 3 state) (nth 4 state))
			   (nth 1 data))
			  ((nth 1 data) (/= (inform-preceding-char) ?\;))
			  (t (looking-at inform-object-regexp)))))
	    (t
	     (inform-beginning-of-defun)
	     (setq in-obj (looking-at inform-object-regexp)
		   state (parse-partial-sexp (point) line-start)))))

    (list
     (if (> (car state) 0)
	 ;; If there's a containing sexp then it's easy.
	 (cond ((nth 3 state) 'string)
	       ((nth 4 state) 'comment)
	       ((looking-at comment-start) 'comment)
	       ((looking-at inform-label-regexp) 'label)
	       (t 'code))

       ;; Otherwise there are a bunch of special cases (has, with,
       ;; class, properties) that must be checked for.  Note that we
       ;; have to distinguish between global class declarations and
       ;; class membership in an object declaration.  This is done by
       ;; looking for a preceding semicolon.
       (cond ((nth 3 state) 'string)
	     ((nth 4 state) 'comment)
	     ((looking-at comment-start) 'comment)
	     ((and in-obj (looking-at "\\s-*class\\>")
		   (/= (inform-preceding-char) ?\;))
	      'class)
	     ((looking-at inform-action-regexp) 'action)
	     ((looking-at inform-directive-regexp) 'directive)
	     ((and (looking-at "\\[") (eq (inform-preceding-char) ?\;))
	      'directive)
	     ((and (not in-obj) (eq (inform-preceding-char) ?\;))
	      'directive)
	     ((not in-obj) 'other)
	     ((looking-at "\\s-*has\\(\\s-\\|$\\)") 'has)
	     ((looking-at "\\s-*with\\(\\s-\\|$\\)") 'with)
	     ((eq (inform-preceding-char) ?,) 'property)
	     ((looking-at "\\s-*$") 'blank)
	     (t 'other)))

     ;; Are we in an object?
     (if (and in-obj
	      (not (looking-at inform-object-regexp))
	      (zerop (car state))
	      (eq (inform-preceding-char) ?\;))
	 nil
       in-obj)

     ;; List of known enclosing sexps.
     (let ((sexps (nth 2 data))		; the old list of sexps
	   (depth (car state))		; current nesting depth
	   (sexp-start (nth 1 state)))	; enclosing sexp, if any
       (if sexps
	   ;; Strip away closed sexps.
	   (let ((sexp-depth (car (car sexps))))
	     (while (and sexps (or (> sexp-depth depth)
				   (and (eq sexp-depth depth)
					sexp-start)))
	       (setq sexps (cdr sexps)
		     sexp-depth (if sexps (car (car sexps)))))))
       (if sexp-start
	   (setq sexps (cons (cons depth sexp-start) sexps)))
       sexps)

     ;; State from the parse algorithm.
     state)))

;; Returns the correct indentation for the line at point.  DATA is the
;; syntax class for the start of the line (as returned by
;; `inform-syntax-class').  It is assumed that point is somewhere in the
;; indentation for the current line (i.e., everything to the left is
;; whitespace).

(defun inform-calculate-indentation (data)
  (let ((syntax (car data))		; syntax class of start of line
	(in-obj (nth 1 data))		; inside an object?
	(depth (car (nth 3 data)))	; depth of nesting of start of line
	(case-fold-search t))		; searches are case-insensitive
    (cond

     ;; Directives should never be indented or else the directive-
     ;; finding code won't run fast enough.  Hence the magic
     ;; constant 0.
     ((eq syntax 'directive) 0)
     ((eq syntax 'blank) 0)

     ;; Various standard indentations.
     ((eq syntax 'property) inform-indent-property)
     ((eq syntax 'other)
      (cond ((looking-at "\\s-*\\[") inform-indent-property)
	    (in-obj (+ inform-indent-property inform-indent-level))
	    (t inform-indent-level)))
     ((and (eq syntax 'string) (zerop depth))
      (cond (in-obj (+ inform-indent-property inform-indent-level))
	    (t inform-indent-level)))
     ((and (eq syntax 'comment) (zerop depth))
      (if in-obj inform-indent-property 0))
     ((eq syntax 'action) inform-indent-level)
     ((memq syntax '(has with class)) inform-indent-has-with-class)

     ;; We are inside a sexp of some sort.
     (t
      (let ((indent 0)			; calculated indent column
	    paren			; where the enclosing sexp begins
	    string-start		; where string (if any) starts
	    cont-p			; true if line is a continuation
	    paren-char			; the parenthesis character
	    prec-token			; token preceding line
	    this-char)			; character under consideration
	(save-excursion

	  ;; Skip back to the start of a string, if any.  (Note that
	  ;; we can't be in a comment since the syntax class applies
	  ;; to the start of the line.)
	  (if (eq syntax 'string)
	      (progn
            (skip-syntax-backward "^\"")
            (forward-char -1)
            (setq string-start (point))))

	  ;; Now find the start of the sexp containing point.  Most
	  ;; likely, the location was found by `inform-syntax-class';
	  ;; if not, call `up-list' now and save the result in case
	  ;; it's useful in future.
	  (save-excursion
	    (let ((sexps (nth 2 data)))
	      (if (and sexps (eq (car (car sexps)) depth))
		  (goto-char (cdr (car sexps)))
		(up-list -1)
		(setcar (nthcdr 2 data)
			(cons (cons depth (point)) (nth 2 data)))))
	    (setq paren (point)
		  paren-char (following-char)))

	  ;; If we were in a string, now skip back to the start of the
	  ;; line.  We have to do this *after* calling `up-list' just
	  ;; in case there was an opening parenthesis on the line
	  ;; including the start of the string.
	  (if (eq syntax 'string)
	      (forward-line 0))

	  ;; The indentation depends on what kind of sexp we are in.
	  ;; If line is in parentheses, indent to opening parenthesis.
	  (if (eq paren-char ?\()
	      (setq indent (progn (goto-char paren) (1+ (current-column))))
	
	    ;; Line not in parentheses.
	    (setq prec-token (inform-preceding-token)
		  this-char (following-char))
	    (cond

         ;; Each 'else' should have the same indentation as the matching 'if'
         ((looking-at "\\s-*else")
          ;; Find the matching 'if' by counting 'if's and 'else's in this sexp
          (let ((offset 0) (if-count 0) found)
            (while (and (not found)
                        (progn (forward-sexp -1) t)  ; skip over sub-sexps
                        (re-search-backward "\\s-*\\(else\\|if\\)" paren t))
              (setq if-count (+ if-count
                               (if (string= (match-string 1) "else")
                                   -1 1)))
              (if (eq if-count 1) (setq found t)))
            (if (not found)
                (setq indent 0)
              (forward-line 0)
              (skip-syntax-forward " ")
              (setq indent (current-column)))))
         
	     ;; Line is in an implicit block: take indentation from
	     ;; the line that introduces the block, plus one level.
	     ((memq prec-token '(?\) do else))
	      (forward-sexp -1)
	      (forward-line 0)
	      (skip-syntax-forward " ")
	      (setq indent
		    (+ (current-column)
		       (if (eq this-char ?{) 0 inform-indent-level))))

	     ;; Line is a continued statement.
	     ((not (memq prec-token inform-statement-terminators))
	      (setq cont-p t)
	      (forward-line -1)
	      (let ((token (inform-preceding-token)))
            ;; Is it the first continuation line?
            (if (memq token inform-statement-terminators)
                (setq indent inform-indent-cont-statement)))
	      (skip-syntax-forward " ")
	      (setq indent (+ indent (current-column))))

	     ;; Line is in a function, take indentation from start of
	     ;; function, ignoring `with'.
	     ((eq paren-char ?\[)
	      (goto-char paren)
	      (forward-line 0)
	      (looking-at "\\(\\s-*with\\s-\\)?\\s-*")
	      (goto-char (match-end 0))
	      (setq indent
		    (+ (current-column)
		       (if (eq this-char ?\]) 0 inform-indent-level))))

	     ;; Line is in a block: take indentation from block.
	     (t
	      (goto-char paren)
	      (if (eq (inform-preceding-char) ?\))
              (forward-sexp -1))
	      (forward-line 0)
	      (skip-syntax-forward " ")
          
	      (setq indent
                (+ (current-column) 
                   (if (memq this-char '(?} ?{)) 
                       0
                     inform-indent-level)))
          ))

	    ;; We calculated the indentation for the start of the
	    ;; string; correct this for the remainder of the string if
	    ;; appropriate.
	    (cond ((and (eq syntax 'string) (not cont-p))
		   (goto-char string-start)
		   (let ((token (inform-preceding-token)))
		     (if (not (memq token inform-statement-terminators))
			 (setq indent
			       (+ indent inform-indent-cont-statement)))))
		
		  ;; Indent for label, if any.
		  ((eq syntax 'label)
		   (setq indent (+ indent inform-indent-label-offset))))))

	indent)))))

;; Modifies whitespace to the left of point so that the character after
;; point is at COLUMN.  If this is impossible, one whitespace character
;; is left.  Avoids changing buffer gratuitously, and returns non-NIL if
;; it actually changed the buffer.  If a change is made, point is moved
;; to the end of any inserted or deleted whitespace.  (If not, it may be
;; moved at random.)

(defun inform-indent-to (column)
  (let ((col (current-column)))
    (cond ((eq col column) nil)
	  ((< col column) (indent-to column) t)
	  (t (let ((p (point))
		 (mincol (progn (skip-syntax-backward " ")
				(current-column))))
 	       (if (eq mincol (1- col))
		   nil
		 (delete-region (point) p)
		 (indent-to (max (if (bolp) mincol (1+ mincol)) column))
		 t))))))

;; Indent the line containing point; DATA is assumed to have been
;; returned from `inform-syntax-class', called at the *start* of the
;; current line.  It is assumed that point is at the start of the line.
;; Fixes up the spacing on `has', `with', `object', `nearby' and `class'
;; lines.  Returns T if a change was made, NIL otherwise.  Moves point.

(defun inform-do-indent-line (data)
  (skip-syntax-forward " ")
  (let ((changed-p (inform-indent-to (inform-calculate-indentation data)))
	(syntax (car data)))

    ;; Fix up space if appropriate, return changed flag.
    (or
     (cond
      ((and (memq syntax '(directive has with class))
	    inform-indent-fixup-space
	    (looking-at
	     "\\(object\\|class\\|nearby\\|has\\|with\\)\\(\\s-+\\|$\\)"))
       (goto-char (match-end 0))
       (inform-indent-to inform-indent-property))
      ((and (eq syntax 'action)
	    inform-indent-action-column
	    (or (looking-at "\\*.*\\(->\\)")
		(looking-at "\\*.*\\($\\)")))
       (goto-char (match-beginning 1))
       (inform-indent-to inform-indent-action-column))       
      (t nil))
     changed-p)))

;; Calculate and return the indentation for a comment (assume point is
;; on the comment).

(defun inform-comment-indent ()
  (skip-syntax-backward " ")
  (if (bolp)
      (inform-calculate-indentation (inform-syntax-class))
    (max (1+ (current-column)) comment-column)))

;; Indent line containing point.  If the indentation changes or if point
;; is before the first non-whitespace character on the line,
;; move point to indentation.

(defun inform-indent-line ()
  (let ((old-point (point)))
    (forward-line 0)
    (or (inform-do-indent-line (inform-syntax-class))
        (< old-point (point))
        (goto-char old-point))))

;; Indent all the lines in region.

(defun inform-indent-region (start end)
  (save-restriction
    (let ((endline (progn (goto-char (max end start))
			  (or (bolp) (end-of-line))
			  (point)))
	  data linestart)
      (narrow-to-region (point-min) endline)
      (goto-char (min start end))
      (forward-line 0)
      (while (not (eobp))
	(setq data (if data (inform-syntax-class linestart data)
		     (inform-syntax-class))
	      linestart (point))
	(inform-do-indent-line data)
	(forward-line 1)))))


;;; Filling paragraphs: -------------------------------------------------------

;; Fill quoted string or comment containing point.  To fill a quoted
;; string, point must be between the quotes.  Deals appropriately with
;; trailing backslashes.

(defun inform-fill-paragraph (&optional arg)
  (let* ((data (inform-syntax-class))
         (syntax (car data))
         (case-fold-search t))
    (cond ((eq syntax 'comment)
           (if (save-excursion
                 (forward-line 0)
                 (looking-at "\\s-*!+\\s-*"))
               (let ((fill-prefix (match-string 0)))
                 (fill-paragraph nil)
                 t)
             (error "Can't fill comments not at start of line.")))
          ((eq syntax 'string)
           (save-excursion
             (let* ((indent-col (prog2
                                    (insert ?\n)
                                    (inform-calculate-indentation data)
                                  (delete-backward-char 1)))
                    (start (search-backward "\""))
                    (end (search-forward "\"" nil nil 2))
                    (fill-column (- fill-column 2))
                    linebeg)
               (save-restriction
                 (narrow-to-region (point-min) end)
                 
                 ;; Fold all the lines together, removing backslashes
                 ;; and multiple spaces as we go.
                 (subst-char-in-region start end ?\n ? )
                 (subst-char-in-region start end ?\\ ? )
                 (subst-char-in-region start end ?\t ? )
                 (goto-char start)
                 (while (re-search-forward "  +" end t)
                   (delete-region (match-beginning 0) (1- (match-end 0))))
                 
                 ;; Split this line; reindent after first split,
                 ;; otherwise indent to point where first split ended
                 ;; up.
                 (goto-char start)
                 (setq linebeg start)
                 (while (not (eobp))
                   (move-to-column (1+ fill-column))
                   (if (eobp)
                       nil
                     (skip-chars-backward "^ " linebeg)
                     (if (eq (point) linebeg)
                         (progn
                           (skip-chars-forward "^ ")
                           (skip-chars-forward " ")))
                     (insert "\n")
                     (indent-to-column indent-col 1)
                     (setq linebeg (point))))))
             
             ;; Return T so that `fill-paragaph' doesn't try anything.
             t))
          
          (t (error "Point is neither in a comment nor a string.")))))


;;; Tags: ---------------------------------------------------------------------

;; Return the project file to which the current file belongs.  This is
;; either the value of `inform-project-file', the current file.

(defun inform-project-file ()
  (or inform-project-file (buffer-file-name)))

;; Builds a list of files in the current project and returns it.  It
;; recursively searches through included files, but tries to avoid
;; loops.

(defun inform-project-file-list ()
  (let* ((project-file (inform-project-file))
	 (project-dir (file-name-directory project-file))
	 (in-file-list (list project-file))
	 out-file-list
	 (temp-buffer (generate-new-buffer "*Inform temp*")))
    (message "Building list of files in project...")
    (save-excursion
      (while in-file-list
	(if (member (car in-file-list) out-file-list)
	    nil
	  (set-buffer temp-buffer)
	  (erase-buffer)
	  (insert-file-contents (car in-file-list))
	  (setq out-file-list (cons (car in-file-list) out-file-list)
		in-file-list (cdr in-file-list))
	  (goto-char (point-min))
	  (while (re-search-forward "\\<#?include\\s-+\">\\([^\"]+\\)\"" nil t)
	    (let ((file (match-string 1)))
	      ;; We need to duplicate Inform's file-finding algorithm:
	      (if (not (string-match "\\." file))
		  (setq file (concat file ".inf")))
	      (if (not (file-name-absolute-p file))
		  (setq file (expand-file-name file project-dir)))
	      (setq in-file-list (cons file in-file-list))))))
      (kill-buffer nil))
    (message "Building list of files in project...done")
    out-file-list))

;; Visit tags table for current project, if it exists, or do nothing if
;; there is no current project, or no tags table.

(defun inform-auto-load-tags-table ()
  (let (tf (project (inform-project-file)))
    (if project
	(progn
	  (setq tf (expand-file-name "TAGS" (file-name-directory project)))
	  (if (file-readable-p tf)
          ;; visit-tags-table seems to just take first parameter in XEmacs
	      (visit-tags-table tf))))))

(defun inform-retagify ()
  "Create a tags table for the files in the current project.
The current project contains all the files included using Inform's
`Include \">file\";' syntax by the project file, which is that given by
the variable `inform-project-file' \(if this is set\), or the current
file \(if not\).  Files included recursively are included in the tags
table."
  (interactive)
  (let* ((project-file (inform-project-file))
	 (project-dir (file-name-directory project-file))
	 (files (inform-project-file-list))
	 (tags-file (expand-file-name "TAGS" project-dir)))
    (message "Running external tags program...")

	;; Uses call-process to work on windows/nt systems (not tested)
	;; Regexp matches routines or object/class definitions
	(call-process inform-etags-program
				  nil nil nil
				  "--regex=/\\([oO]bject\\|[nN]earby\\|[cC]lass\\|\\[\\)\\([ \\t]*->\\)*[ \\t]*\\([A-Za-z0-9_]+\\)/"
				  (concat "--output=" tags-file)
				  "--language=none"
				  (mapconcat (function (lambda (x) x)) files " "))
	
    (message "Running external tags program...done")
    (inform-auto-load-tags-table)))




;;; Electric keys: ------------------------------------------------------------

(defun inform-toggle-auto-newline (arg)
  "Toggle auto-newline feature.
Optional numeric ARG, if supplied turns on auto-newline when positive,
turns it off when negative, and just toggles it when zero."
  (interactive "P")
  (setq inform-auto-newline
	(if (or (not arg)
		(zerop (setq arg (prefix-numeric-value arg))))
	    (not inform-auto-newline)
	  (> arg 0))))

(defun inform-electric-key (arg)
  "Insert the key typed and correct indentation."
  (interactive "P")
  (if (and (not arg) (eolp))
      (progn
	(self-insert-command 1)
	(inform-indent-line)
	(end-of-line))
    (self-insert-command (prefix-numeric-value arg))))

(defun inform-electric-semi (arg)
  "Insert the key typed and correct line's indentation, as for semicolon.
Special handling does not occur inside strings and comments.
Inserts newline after the character if `inform-auto-newline' is non-NIL."
  (interactive "P")
  (if (and (not arg)
	   (eolp)
	   (let ((data (inform-syntax-class)))
	     (not (memq (car data) '(string comment)))))
	(progn
	  (self-insert-command 1)
	  (inform-indent-line)
	  (end-of-line)
	  (if inform-auto-newline (newline-and-indent)))
      (self-insert-command (prefix-numeric-value arg))))

(defun inform-electric-comma (arg)
  "Insert the key typed and correct line's indentation, as for comma.
Special handling only occurs in object declarations.
Inserts newline after the character if `inform-auto-newline' is non-NIL."
  (interactive "P")
  (if (and (not arg)
	   (eolp)
	   (let ((data (inform-syntax-class)))
	     (and (not (memq (car data) '(string comment)))
		  (nth 1 data)
		  (zerop (car (nth 3 data))))))
	(progn
	  (self-insert-command 1)
	  (inform-indent-line)
	  (end-of-line)
	  (if inform-auto-newline (newline-and-indent)))
    (self-insert-command (prefix-numeric-value arg))))

(defun inform-electric-brace (arg)
  "Insert the key typed and correct line's indentation.
Insert newlines before and after if `inform-auto-newline' is non-NIL."
  ;; This logic is the same as electric-c-brace.
  (interactive "P")
  (let (insertpos)
    (if (and (not arg)
	     (eolp)
	     (let ((data (inform-syntax-class)))
	       (memq (car data) '(code label)))
	     (or (save-excursion (skip-syntax-backward " ") (bolp))
		 (if inform-auto-newline
		     (progn (inform-indent-line) (newline) t) nil)))
	(progn
	  (insert last-command-char)
	  (inform-indent-line)
	  (end-of-line)
	  (if (and inform-auto-newline (/= last-command-char ?\]))
	      (progn
		(newline)
		(setq insertpos (1- (point)))
		(inform-indent-line)))
	  (save-excursion
	    (if insertpos (goto-char insertpos))
	    (delete-char -1))))
    (if insertpos
	(save-excursion
	  (goto-char (1- insertpos))
	  (self-insert-command (prefix-numeric-value arg)))
      (self-insert-command (prefix-numeric-value arg)))))


;;; Miscellaneous: ------------------------------------------------------------

(defun inform-next-object (&optional arg)
  "Go to the next object or class declaration in the file.
With a prefix arg, go forward that many declarations.
With a negative prefix arg, search backwards."
  (interactive "P")
  (let ((fun 're-search-forward)
	(errstring "more")
	(n (prefix-numeric-value arg)))
    (cond ((< n 0)
	   (setq fun 're-search-backward errstring "previous" n (- n)))
	  ((looking-at inform-real-object-regexp)
	   (setq n (1+ n))))
    (prog1
	(funcall fun inform-real-object-regexp nil 'move n)
      (forward-line 0))))

;; This function doubles as an `imenu-prev-name' function, so when
;; called noninteractively it must return T if it was successful and NIL
;; if not.  Argument NIL must correspond to moving backwards by 1.

(defun inform-prev-object (&optional arg)
  "Go to the previous object or class declaration in the file.
With a prefix arg, go back many declarations.
With a negative prefix arg, go forwards."
  (interactive "P")
  (inform-next-object (- (prefix-numeric-value arg))))

(defun inform-imenu-extract-name ()
  (if (looking-at
       "^#?\\(object\\|nearby\\|class\\)\\s-+\\(\\(\\w\\|\\s_\\)+\\)")
      (concat (if (string= "class" (downcase (match-string 1)))
                  "Class ")
              (buffer-substring-no-properties (match-beginning 2)
                                              (match-end 2)))))

(defun inform-build-project ()
  "Compile the current Inform project.
The current project is given by `inform-project-file', or the current
file if this is NIL."
  (interactive)
  (let ((project-file (file-name-nondirectory (inform-project-file))))
    (compile
     (concat inform-command
	     (if (and inform-libraries-directory
		      (file-directory-p inform-libraries-directory))
		 (concat " +" inform-libraries-directory)
	       "")
	     ;; Note the use of Microsoft style errors.  The
	     ;; Archimedes-style errors don't give the correct file
	     ;; name.
	     " " inform-command-options " -E1 "
	     (if (string-match "\\`[^.]+\\(\\.inf\\'\\)" project-file)
		 (substring project-file 0 (match-beginning 1))
	       project-file)))))

(defun inform-convert-old-format ()
  "Undoes Inform Mode 0.4 formatting for current buffer.
Early versions of Inform Mode used tab stops every 4 characters to
control formatting, which was the Wrong Thing To Do.  This function
undoes that stupidity."
  (interactive)
  (let ((tab-width 4))
    (untabify (point-min) (point-max))))


(provide 'inform-mode)

;;; inform-mode.el ends here

