;;= My init.el =================================================================
;; Thanks to https://sr.ht/~ashton314/emacs-bedrock/
;; Author: Bhargav Kulkarni

;;- Custom Options -------------------------------------------------------------

;; All this does is ensure all the custom emacs set options are in
;; this "custom.el" file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;;- Package Init ---------------------------------------------------------------

;; Adds melpa and nongnu as package sources
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("nongnu" . "https://elpa.nongnu.org/nongnu/") t)

;; initialize package.el and refresh the package archive if out of
;; date
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;;- Basic Look and Feel --------------------------------------------------------

;; Turn off the welcome screen
(setopt inhibit-splash-screen t)

;; Turn off load time info
(setopt display-time-default-load-average nil)

;; Reread from file if the file changes on disk
(setopt auto-revert-avoid-polling t)
(setopt auto-revert-interval 5)
(setopt auto-revert-check-vc-info t)
(global-auto-revert-mode)

;; Some typewrite nonsense that moved to emacs for some reason??
(setopt sentence-end-double-space nil)

;; Make emacs prefer vertical window splits
(setq split-width-threshold 1)

;;- Clean Backup Files ---------------------------------------------------------

;; Don't litter file system with *~ backup files; put them all inside
;; ~/.emacs.d/emacs-backup
(defun custom-backup-file-name (fpath)
  "Return a new file path of a given file path.
If the new path's directories does not exist, create them."
  (let* ((backupRootDir "~/.emacs.d/emacs-backup/")
	 ; remove Windows driver letter in path
         (filePath (replace-regexp-in-string "[A-Za-z]:" "" fpath )) 
         (backupFilePath
	  (replace-regexp-in-string
	   "//"
	   "/"
	   (concat backupRootDir filePath "~"))))
    (make-directory (file-name-directory backupFilePath)
		    (file-name-directory backupFilePath))
    backupFilePath))
(setopt make-backup-file-name-function 'custom-backup-file-name)

;;- Key Discovery --------------------------------------------------------------

;; Quick Help
;; (add-hook 'after-init-hook 'help-quick)

;; `which-key' shows all available commands when running a long
;; command
(use-package which-key
  :ensure t
  :config (which-key-mode))

;;- Better Minibuffer ----------------------------------------------------------

;; TAB cycles candidates
(setopt completion-cycle-threshold 1)

;; Show command annotations
(setopt completions-detailed t)

;; TAB first tries to complete then indents
(setopt tab-always-indent 'complete)

;; Completion styles
(setopt completion-styles '(basic initials substring))

;; Always show completions
(setopt completion-auto-help 'always)

;; Visual Settings
(setopt completions-max-height 20)
(setopt completions-format 'one-column)
(setopt completions-group 'second-tab)
(setopt completion-auto-select 'second-tab)

;; TAB in minibuffer acts like it does in shell
(keymap-set minibuffer-mode-map "TAB" 'minibuffer-complete)

;;- Interface enhancements -----------------------------------------------------

;; Add line and column number information in modeline
(setopt line-number-mode t)
(setopt column-number-mode t)

;; Better underlines
(setopt x-underline-at-descent-line nil)

;; Show buffer boundaries in fringe
(setopt indicate-buffer-boundaries 'left)

;; Set "esc" to cancel
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Don't blink cursor
(blink-cursor-mode -1)

;; Better scrolling
(pixel-scroll-precision-mode)

;; Display line numbers in prog-mode
;; (add-hook 'prog-mode-hook 'display-line-numbers-mode)
;; (setopt display-line-numbers-width 3)

;; Nice Line Wrapping
(add-hook 'text-mode-hook 'visual-line-mode)

;; Highlight current line
(let ((hl-line-hooks '(text-mode-hook prog-mode-hook)))
  (mapc (lambda (hook) (add-hook hook 'hl-line-mode)) hl-line-hooks))

;; Line at column 80
(setopt display-fill-column-indicator-column 80)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

;; Display time in the modeline
(setopt display-time-format "%a %F %T")
(setopt display-time-interval 1)
(display-time-mode)

;; Ripgrep for very fast searching
(use-package rg
  :ensure t)

;;- Theme ----------------------------------------------------------------------

(use-package doom-themes
  :ensure t
  :config
  ;; Enable bold and italics
  (setq doom-themes-enable-bold t)
  (setq doom-themes-enable-italic t)
  
  ;; Set the default theme
  (load-theme 'doom-solarized-light t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config))

(defvar light-theme 'doom-solarized-light)
(defvar dark-theme 'doom-solarized-dark)
(defvar current-theme light-theme)

(defun toggle-theme ()
  "Toggle between light and dark themes."
  (interactive)
  (setq current-theme (if (eq current-theme light-theme)
			  dark-theme
			light-theme))
  (load-theme current-theme t))

(global-set-key (kbd "C-c t") 'toggle-theme)

;;- Keybinding Setup -----------------------------------------------------------
(defmacro define-leader-menu (name infix-key &rest body)
  (declare (indent 2))
  `(progn
     (general-create-definer ,(intern (concat name "-leader"))
       :wrapping global-leader
       :prefix-map (quote ,(intern (concat name "-leader-map")))
       :infix ,infix-key
       :wk-full-keys nil
       "" '(:ignore t :which-key ,name))
     (,(intern (concat name "-leader"))
      ,@body)))

(use-package general
  :ensure t
  :config
  (general-evil-setup)

  (general-create-definer global-leader
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC")

  (global-leader
   "!" 'shell-command))

(define-leader-menu "buffer" "b"
  "d" 'kill-current-buffer
  "b" 'consult-buffer)

(define-leader-menu "file" "f"
  "f" 'find-file
  "s" '((lambda () (interactive) 'save-file)
	:which-key "save-file"))

(define-leader-menu "theme" "t"
  "t" 'toggle-theme
  "l" 'load-theme)

(define-leader-menu "avy" "a"
  "l" 'avy-goto-line
  "c" 'avy-goto-char
  "w" 'avy-goto-word-1)

;;- Modeline -------------------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package fontset				 ;;
;;   :config					 ;;
;;   ;; Use symbola for proper unicode		 ;;
;;   (when (member "Symbola" (font-family-list)) ;;
;;     (set-fontset-font			 ;;
;;      t 'symbol "Symbola" nil)))		 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load-file (expand-file-name "dl-packages/bespoke-modeline.el"
			     user-emacs-directory))

(load-file (expand-file-name "dl-packages/alloy-mode.el"
			     user-emacs-directory))

(use-package bespoke-modeline
  :init
  (setq bespoke-modeline-position 'bottom)
  :config
  (bespoke-modeline-mode))

(use-package solaire-mode
  :ensure t
  :config
  (solaire-global-mode +1))

;;- Olivetti -------------------------------------------------------------------

(use-package olivetti
  :ensure t)

(add-hook 'olivetti-mode-on-hook (lambda () (olivetti-set-width 80)))

(load-file (expand-file-name "dl-packages/auto-olivetti.el"
			     user-emacs-directory))

(use-package auto-olivetti
  :init
  (setq auto-olivetti-enabled-modes '(text-mode prog-mode))
  :config
  (auto-olivetti-mode))

;;- Dashboard ------------------------------------------------------------------

(use-package dashboard
  :ensure t
  :init
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-center-content t)
  (setq dashboard-items '((recents  . 5)
                          (projects . 5)))
  :config
  (dashboard-setup-startup-hook))

;;- Spell Checker --------------------------------------------------------------
(setq ispell-program-name "/opt/homebrew/bin/aspell")

;;- Load other config ----------------------------------------------------------

;; UI/UX enhancements mostly focused on minibuffer and autocompletion
;; interfaces
(load-file (expand-file-name "extras/base.el" user-emacs-directory))

;; Packages for software development
(load-file (expand-file-name "extras/dev.el" user-emacs-directory))

;; Evil Mode
(load-file (expand-file-name "extras/vim.el" user-emacs-directory))
