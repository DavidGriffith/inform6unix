;; Inform highlights for GNU emacs.

(hilit-set-mode-patterns 'inform-mode
 '(
   ;; Comments
   ("\\(^!\\|[ \t]!\\).*" nil comment)
   ;; Strings
   (hilit-string-find ?\\ string)
   ;; Declarations
   ("#?\\b\\(IFDEF\\|Ifdef\\|IFNDEF\\|Ifndef\\|IFNOT\\|Ifnot\\|IFV3\\|IfV3\\|IFV5\\|IfV5\\|ENDIF\\|Endif\\)\\b" nil define)
   ;; Include files
   ("^#?Include" nil include)
   ;; Control keywords
   ("\\b\\(while\\|if\\|else\\|for\\|switch\\|do\\|until\\|return\\|rtrue\\|rfalse\\|break\\|jump\\|objectloop\\)\\b" nil keyword)
   ;; Functions
   ("^\\[[ \t]*[^ \t;]+" nil defun)
   ("^\\(Object\\|Nearby\\|Class\\)\\([ \t]+->\\)*[ \t]+[^ \t]+" nil defun)
   ))
