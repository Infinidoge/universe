;; --- Org Mode
(setq
 ;; Directories
 org-directory "~/Documents/Org"
 org-agenda-files '("~/Documents/" "~/Documents/Notes/" "~/Documents/Org/" "~/Documents/Org/agenda/" "~/Projects/" "~/Documents/School/")

 ;; General settings
 org-use-speed-commands t
 org-list-demote-modify-bullet '(("-" . "+") ("+" . "-") ("1." . "a."))
 ;; org-list-demote-modify-bullet '(("-" . "-") ("1." . "a."))
 org-list-allow-alphabetical t
 org-startup-shrink-all-tables t
 org-startup-align-all-tables t
 org-src-fontify-natively t
 org-display-custom-times nil
 org-time-stamp-custom-formats '("<%d %b %Y>" . "<%y/%m/%d %a %H:%M:%S>")
 org-link-descriptive nil

 ;; Export
 org-latex-tables-centered nil
 org-latex-listings 'minted
 org-latex-packages-alist '(("" "minted" "listingsutf8"))
 org-latex-pdf-process
 '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
   "biber %b"
   "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
   "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f")
 )

;; Run formatters in org src blocks on save
(defun infinidoge/format-org-src-blocks ()
  (org-babel-map-src-blocks nil
    (if (equal (alist-get :format (org-babel-parse-header-arguments header-args) "yes")
               "yes")
        (+format--org-region nil nil))))

(add-hook 'before-save-hook 'infinidoge/format-org-src-blocks)

;; Automatically tangle src blocks on save
(defun infinidoge/tangle-on-save ()
  (when (eq major-mode 'org-mode)
    (org-babel-tangle)))

(add-hook 'after-save-hook 'infinidoge/tangle-on-save)

;; Setup ox-extras to allow ignoring headlines while keeping content
(use-package! ox-extra
  :config
  (ox-extras-activate '(ignore-headlines)))

;; Load babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (latex . t)))
