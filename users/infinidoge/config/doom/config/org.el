;; --- Org Mode
(setq
 ;; Directories
 org-directory "~/Documents/Org"
 org-agenda-files '("~/Documents/" "~/Notes/" "~/Documents/Org/" "~/Documents/Org/agenda/" "~/Projects/" "~/Documents/School/")

 ;; General settings
 org-use-speed-commands t
 org-list-demote-modify-bullet '(("-" . "+") ("+" . "-") ("1." . "a."))
 ;; org-list-demote-modify-bullet '(("-" . "-") ("1." . "a."))
 org-list-allow-alphabetical t
 org-startup-shrink-all-tables t
 org-startup-align-all-tables t
 org-src-fontify-natively t
 org-edit-src-content-indentation 0
 org-display-custom-times nil
 org-time-stamp-custom-formats '("<%d %b %Y>" . "<%y/%m/%d %a %H:%M:%S>")
 org-link-descriptive nil

 ;; Export
 org-latex-tables-centered nil
 org-latex-src-block-backend 'minted
 org-latex-packages-alist '(("" "minted" "listingsutf8") ("cdot" "SIunits"))
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

;; Unescape and Escape code in org src blocks before/after formatting to prevent org's escaping from messing with formatting
(defun infinidoge/before-format--org-region (beg end)
  (let ((element (org-element-at-point)))
    (save-excursion
      (let* ((block-beg (save-excursion
                          (goto-char (org-babel-where-is-src-block-head element))
                          (line-beginning-position 2)))
             (block-end (save-excursion
                          (goto-char (org-element-property :end element))
                          (skip-chars-backward " \t\n")
                          (line-beginning-position)))
             (beg (if beg (max beg block-beg) block-beg))
             (end (if end (min end block-end) block-end))
             (lang (org-element-property :language element))
             (major-mode (org-src-get-lang-mode lang)))
        (if (eq major-mode 'org-mode)
            (user-error "Cannot reformat an org src block in org-mode")
          (org-unescape-code-in-region beg end)))))
  )

(defun infinidoge/after-format--org-region (beg end)
  (let ((element (org-element-at-point)))
    (save-excursion
      (let* ((block-beg (save-excursion
                          (goto-char (org-babel-where-is-src-block-head element))
                          (line-beginning-position 2)))
             (block-end (save-excursion
                          (goto-char (org-element-property :end element))
                          (skip-chars-backward " \t\n")
                          (line-beginning-position)))
             (beg (if beg (max beg block-beg) block-beg))
             (end (if end (min end block-end) block-end))
             (lang (org-element-property :language element))
             (major-mode (org-src-get-lang-mode lang)))
        (if (eq major-mode 'org-mode)
            (user-error "Cannot reformat an org src block in org-mode")
          (org-escape-code-in-region beg end)))))
  )

(advice-add '+format--org-region :before #'infinidoge/before-format--org-region)
(advice-add '+format--org-region :after #'infinidoge/after-format--org-region)

;; Automatically tangle src blocks on save
(defun infinidoge/tangle-on-save ()
  (when (eq major-mode 'org-mode)
    (org-babel-tangle)))

(add-hook 'after-save-hook 'infinidoge/tangle-on-save)

;; Setup ox-extras to allow ignoring headlines while keeping content
(use-package! ox-extra
  :config
  (ox-extras-activate '(ignore-headlines)))

(add-to-list 'org-latex-classes
  '("apa7"
    "\\documentclass{apa7}"
    ("\\section{%s}" . "\\section*{%s}")
    ("\\subsection{%s}" . "\\subsection*{%s}")
    ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
    ("\\paragraph{%s}" . "\\paragraph*{%s}")
    ("\\subparagraph{%s}" . "\\subparagraph*{%s}")
    )
  )
