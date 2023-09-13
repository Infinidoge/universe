;;; list-mode.el --- A major mode for highlighting https://lists.sh list files
;;; list-mode.el -*- lexical-binding: t; -*-
;;; Commentary:

;;; Code:

(define-generic-mode list-mode
  '()
  '()
  '(
    ("^\s*\\(=:\\)\\(?:\s\\([^\s]+?\\)?\\)?\\(?:\s\\(.+\\)?\\)?$" (1 font-lock-doc-face) (2 font-lock-variable-name-face) (3 font-lock-string-face))
    ("^\s*##?\\(?:\s.*\\)?$" . font-lock-type-face)
    ("^\s*\\(=>\\)\\(?:\s\\([^\s]+?\\)?\\)?\\(?:\s\\(.+\\)?\\)?$" (1 font-lock-doc-face) (2 font-lock-keyword-face) (3 font-lock-doc-markup-face))
    ("^\s*\\(=<\\)\\(?:\s\\([^\s]+?\\)?\\)?\\(?:\s\\(.+\\)?\\)?$" (1 font-lock-doc-face) (2 font-lock-keyword-face) (3 font-lock-comment-face))
    ("^\s*\\(>\\).+$" 1 font-lock-doc-face)
    ("^```$" . font-lock-doc-face)
    )
  (list "\\.list\\.txt")
  '((lambda ()
      (display-line-numbers-mode)
      (set-syntax-table text-mode-syntax-table)
      ))
  "Major mode for editing https://lists.sh lists."
  )

(provide 'list-mode)
;;; list-mode.el ends here
