;;= Vim Keybindings ============================================================

;;- Evil Mode ------------------------------------------------------------------
(use-package evil
  :ensure t
  :config
  (setq evil-normal-state-cursor '(box "#268BD2"))
  (setq evil-insert-state-cursor '(box "#859900"))
  (setq evil-visual-state-cursor '(box "#B58900"))
  (evil-mode 1))

(use-package evil-nerd-commenter
  :ensure t)

(define-leader-menu "comment" ";"
  ";" 'evilnc-comment-or-uncomment-lines)



