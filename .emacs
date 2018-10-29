;; Initialize packages
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(backup-directory-alist (quote ((".*" . "~/.emacs_backups/"))))
 '(blacken-line-length 80)
 '(css-indent-offset 2)
 '(global-company-mode t)
 '(initial-buffer-choice (lambda nil (org-journal-new-entry t)))
 '(js-indent-level 2)
 '(org-default-notes-file "~/Documents/org/notes.org")
 '(org-startup-truncated nil)
 '(package-selected-packages
   (quote
    (exec-path-from-shell deadgrep company-jedi tide typescript-mode projectile git-timemachine find-file-in-repository jedi org-journal go-mode ## python org)))
 '(projectile-mode t nil (projectile))
 '(typescript-auto-indent-flag nil)
 '(typescript-indent-level 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; Theme
(load-theme 'manoj-dark)
;; Load Path
(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp"))
;; Requires
(require 'blacken)
(require 'package)
;; MELPA
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;; Global Set Keys - Put them here to avoid collisions
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
;; Reserc C-c f for formatting
(global-set-key (kbd "C-c g") 'deadgrep)
;; Org-journal, prefix with C-u to jump to today's file without creating new entry
(global-set-key (kbd "C-c j") 'org-journal-new-entry)

;; Set multi-line move on M-up, M-down
(global-set-key (kbd "M-<up>")
		(lambda ()
		  (interactive)
		  (setq this-command 'previous-line)
		  (previous-line 5)))

(global-set-key (kbd "M-<down>")
		(lambda ()
		  (interactive)
		  (setq this-command 'next-line)
		  (next-line 5)))

;; Mode setups
;; go-mode
;; Additionally, installing github.com/rogpeppe/godef is useful
(defun setup-go-mode ()
  (local-set-key (kbd "C-c f") 'gofmt)
  )
(add-hook 'go-mode-hook 'setup-go-mode)
;; python-mode configuration
(defun setup-python-mode ()
  (local-set-key (kbd "C-c f") 'blacken-buffer)
  )
(add-hook 'python-mode-hook'setup-python-mode)

;; Org-mode stuff
(setq org-log-done t) ;; Is this working?
;; Files to be scanned for agenda
(setq org-agenda-files (list "~/Documents/org/shoobx.org"
			     "~/Documents/org/intafel.org"
			     "~/Documents/org/journal"
			     "~/Documents/org/life.org"))
;; org-journal
(setq org-journal-dir "~/Documents/org/journal")

;; org-capture templates
(setq org-capture-templates
      '(("b" "Note from Book" entry (id "notes")
	 "%?* Page(s) %^{Page}\n** Quote\n%^{Quote}\n** Note\n%^{Note}")))


;; jedi
;; Start Jedi in Python mode
;; Disable this for now to try plain company mode
;;(add-hook 'python-mode-hook 'jedi:setup)
;; Start jedi autocomplete when doing dot references
;;(setq jedi:complete-on-dot t)
;; This leverages company-jedi
;;(add-to-list `company-backends `company-jedi)

;; Projectile
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; typescript-mode
;; set indent to two
(setq typescript-indent-level 2)

;; tide
;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)
;; from tide docs
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
)
(add-hook 'typescript-mode-hook #'setup-tide-mode)

(setq tide-format-options
      '(:insertSpaceAfterCommaDelimiter t)
)


;; Correctly set exec path on macos
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))


;; Miscellaneous modes
;; Line and column numbers
(setq column-number-mode t)
(setq lin-number-mode t)
;; Show matching parenthesis mode
(setq show-paren-delay 0)
(setq show-paren-mode t)

