;;= Org Mode ===================================================================
;; Thanks to https://sr.ht/~ashton314/emacs-bedrock/
;; Author: Bhargav Kulkarni

(setq org-directory "~/org")

(setq org-agenda-files '("work.org" "school.org" "life.org"))

(setq org-tag-alist '((:startgroup)
		      ("general" . ?h)
		      ("work" . ?w)
		      ("school" . ?s)
		      (:endgroup)
		      (:newline)
		      (:startgroup)
		      ("herbie" . ?r)
		      ("project" . ?p)
		      ("personal" . ?l)
		      (:endgroup)))

(use-package org
  :hook
  ((org-mode . visual-line-mode)
   (org-mode . flyspell-mode))

  :config
  (add-to-list 'org-export-backends 'md))

(use-package org-super-agenda
  :ensure t)

(let ((org-super-agenda-groups
       '((:auto-category t))))
  (org-agenda-list))


