;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;; Code:
;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq
  user-full-name "Infinidoge"
  user-mail-address "infinidoge@doge-inc.net"
  )

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq
 org-directory "~/org/"
 org-agenda-files '("~/org/" "~/org/agenda" "~/Projects/" "~/Documents/School")
 org-use-speed-commands t
 org-list-demote-modify-bullet '(("-" . "+") ("+" . "-") ("1." . "a."))
 org-startup-shrink-all-tables t
 org-startup-align-all-tables t
 )
;; (setq org-list-demote-modify-bullet '(("-" . "-") ("1." . "a.")))

;; Setup Projectile's properties
(setq
 projectile-indexing-method 'hybrid
 projectile-project-search-path '("~/Projects/" "~/Documents/School")
 )

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

(setq deft-recursive t)

(setq tramp-default-method "ssh")

(after! flyspell
  (setq flyspell-lazy-idle-seconds 1))

(setq doom-modeline-enable-word-count t)

(setq emms-volume-change-function 'emms-volume-pulse-change)

(defun infinidoge/format-org-src-blocks ()
  (org-babel-map-src-blocks nil
    (if (equal (alist-get :format (org-babel-parse-header-arguments header-args) "yes")
               "yes")
        (+format--org-region nil nil)
      )
    )
  )

(add-hook 'before-save-hook 'infinidoge/format-org-src-blocks)
;; Temporary until the Black configuration is fixed
;; (setq-hook! 'python-mode-hook +format-with :none)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Keybindings

(map!
 ;; Remove scroll-left and scroll-right keybindings
 "C-<next>" nil
 "C-<prior>" nil
 )

(map! :map evil-window-map
  "<left>" #'evil-window-left
  "<right>" #'evil-window-right
  "<up>" #'evil-window-up
  "<down>" #'evil-window-down
  )

(use-package! evil-goggles
  :config
  ;; (evil-goggles-use-diff-faces)
  ;; (evil-goggles-use-diff-refine-faces)
  (evil-goggles-use-magit-faces)
  )

;; (custom-set-faces
;;  '(evil-goggles-default-face ((t (:inherit 'highlight)))))

(defun infinidoge/tangle-on-save ()
  (when (eq major-mode 'org-mode)
    (org-babel-tangle)))

(add-hook 'after-save-hook 'infinidoge/tangle-on-save)

;; (setq auth-sources '(password-store))

(set-formatter! 'nixpkgs-fmt "nixpkgs-fmt" :modes '(nix-mode))

(defun infinidoge/nixpkgs-fmt-fix ()
  (when (eq major-mode 'nix-mode)
    (format-all-buffer)))

(add-hook 'before-save-hook #'infinidoge/nixpkgs-fmt-fix)
;; (use-package! org-auto-tangle
;;   :defer t
;;   :hook (org-mode . org-auto-tangle-mode)
;;   :config
;;   (setq org-auto-tangle-default t)
;;   )


(setq
  org-latex-listings 'minted
  org-latex-packages-alist '(("" "minted"))
  )
