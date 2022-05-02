;; --- Keybindings ---
(map!
 ;; Remove scroll-left and scroll-right keybindings
 "C-<next>" nil
 "C-<prior>" nil
 )

(map!
 :map evil-window-map
 ;; Unbind Vim HJKL keys
 "h" nil
 "H" nil
 "C-h" nil
 "C-S-h" nil

 "j" nil
 "J" nil
 "C-j" nil
 "C-S-j" nil

 "k" nil
 "K" nil
 "C-k" nil
 "C-S-k" nil

 "l" nil
 "L" nil
 "C-l" nil
 "C-S-l" nil

 ;; Rebind to arrow keys
 "<left>" #'evil-window-left
 "C-<left>" #'evil-window-left
 "S-<left>" #'+evil/window-move-left
 "C-S-<left>" #'evil-window-move-far-left

 "<right>" #'evil-window-right
 "C-<right>" #'evil-window-right
 "S-<right>" #'+evil/window-move-right
 "C-S-<right>" #'evil-window-move-far-right

 "<up>" #'evil-window-up
 "C-<up>" #'evil-window-up
 "S-<up>" #'+evil/window-move-up
 "C-S-<up>" #'evil-window-move-very-top

 "<down>" #'evil-window-down
 "C-<down>" #'evil-window-down
 "S-<down>" #'+evil/window-move-down
 "C-S-<down>" #'evil-window-move-very-bottom
 )

(map!
 :map which-key-C-h-map
 "j" nil
 "<right>" #'which-key-show-next-page-cycle

 "k" nil
 "<left>" #'which-key-show-previous-page-cycle
 )
