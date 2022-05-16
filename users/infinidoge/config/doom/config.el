;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; --- Identity ---
(setq
 user-full-name "Infinidoge"
 user-mail-address "infinidoge@doge-inc.net"
 )

;; --- Appearance ---
(setq
 doom-theme 'doom-one
 display-line-numbers-type t
 doom-modeline-enable-word-count t
 )

;; --- Projectile ----
(setq
 projectile-indexing-method 'hybrid
 projectile-project-search-path '("~/Projects/" "~/Documents/School")
 )

;; --- Treemacs ---
(use-package! treemacs
  :init
  (setq +treemacs-git-mode 'extended)
  )

;; --- Deft ---
(setq
 deft-recursive t
 deft-directory "~/Documents/Notes"
 )

;; --- Tramp ---
(setq
 tramp-default-method "ssh"
 tramp-terminal-type "tramp"
 )

;; --- Flyspell ---
(after! flyspell
  (setq flyspell-lazy-idle-seconds 1))

;; --- Emms ---
(setq emms-volume-change-function 'emms-volume-pulse-change)

;; --- GnuPG ---
(setq epg-pinentry-mode 'loopback)

;; --- langtool ---
(use-package! langtool
  :config
  (setq langtool-bin "languagetool-commandline")
  )

;; --- Evil Goggles ---
(use-package! evil-goggles
  :config
  ;; (evil-goggles-use-diff-faces)
  ;; (evil-goggles-use-diff-refine-faces)
  (evil-goggles-use-magit-faces)
  )
;; (custom-set-faces
;;  '(evil-goggles-default-face ((t (:inherit 'highlight)))))

;; --- Nix ---
;; FIXME: This should be done using :editor format
(set-formatter! 'nixpkgs-fmt "nixpkgs-fmt" :modes '(nix-mode))

(defun infinidoge/nixpkgs-fmt-fix ()
  (when (eq major-mode 'nix-mode)
    (format-all-buffer)))

(add-hook 'before-save-hook #'infinidoge/nixpkgs-fmt-fix)

;; --- JSON ---
(setq js-indent-level 2)
(after! editorconfig
  (add-to-list 'editorconfig-indentation-alist '(json-mode js-indent-level)))

;; --- LSP ---
(setq lsp-csharp-server-path (executable-find "omnisharp"))

;; Set doom-private-dir to the writeable location, as opposed to read-only symlink in $DOOMDIR
(setq doom-private-dir "/etc/nixos/users/infinidoge/config/doom")
;; Disable excessive warnings in configuration directory
(add-to-list '+emacs-lisp-disable-flycheck-in-dirs doom-private-dir)

;; --- --- Original Configuration Comments --- ---
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
;; `load-theme' function.
;;
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

;; Other configuration files
(load! "config/org")
(load! "config/keybindings")
