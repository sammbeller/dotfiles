;; Initialize packages
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "red3" "ForestGreen" "yellow3" "blue" "magenta3" "DeepSkyBlue" "gray50"])
 '(backup-directory-alist (quote ((".*" . "~/.emacs_backups/"))))
 '(blacken-line-length 80)
 '(css-indent-offset 2)
 '(custom-enabled-themes (quote (manoj-dark)))
 '(global-company-mode t)
 '(indent-tabs-mode nil)
 '(js-indent-level 2)
 '(js-switch-indent-offset 2)
 '(org-default-notes-file "~/Documents/org/notes.org")
 '(org-startup-truncated nil)
 '(package-archive-priorities (quote (("melpa-stable" . 2) ("gnu" . 1) ("melpa" . 0))))
 '(package-archives
   (quote
    (("gnu" . "https://elpa.gnu.org/packages/")
     ("melpa-stable" . "https://stable.melpa.org/packages/")
     ("melpa" . "https://melpa.org/packages/"))))
 '(package-selected-packages
   (quote
    (prettier-js markdown-mode geiser emojify rjsx-mode web-mode rust-mode magit elpy auctex exec-path-from-shell deadgrep company-jedi tide typescript-mode projectile git-timemachine find-file-in-repository jedi org-journal go-mode ## python org)))
 '(projectile-mode t nil (projectile))
 '(show-paren-delay 0)
 '(show-paren-mode t)
 '(typescript-auto-indent-flag nil)
 '(typescript-indent-level 2)
 '(web-mode-code-indent-offset 2)
 '(web-mode-enable-auto-quoting nil)
 '(web-mode-markup-indent-offset 2)
 '(web-mode-tests-directory "~/tests/"))
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
;; Needed for flycheck-add-mode
(require 'flycheck)
(require 'package)
;; For setting up web-mode
(require 'web-mode)
;; Global Set Keys - Put them here to avoid collisions
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
;; Reserve C-c f for formatting
(global-set-key (kbd "C-c g") 'deadgrep)
;; Org-journal, prefix with C-u to jump to today's file without creating new entry
(global-set-key (kbd "C-c j") 'org-journal-new-entry)
;; Reserve C-c l for linting
;; Reserve C-c r for finding references
(global-set-key (kbd "C-c s") 'magit-status)

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
  ;; Local set Keys
  (local-set-key (kbd "C-c f") 'gofmt)
  )
(add-hook 'go-mode-hook 'setup-go-mode)
;; python-mode configuration
(defun setup-python-mode ()
  ;; Local set Keys
  (local-set-key (kbd "C-c f") 'blacken-buffer)
  )
(add-hook 'python-mode-hook'setup-python-mode)

;; Org-mode stuff
;; Include diary file in org agenda
(setq org-agenda-include-diary t)
(setq org-log-done t) ;; Is this working?
;; Files to be scanned for agenda
(setq org-agenda-files (list "~/Documents/org/intafel.org"
			     "~/Documents/org/journal"
			     "~/Documents/org/life.org"
			     "~/Documents/org/classes/fast.ai.org"
			     "~/Documents/org/classes/fast-linear-algebra.org"))
;; org-journal
(setq org-journal-dir "~/Documents/org/journal")

;; org-capture templates
(setq org-capture-templates
      '(("b" "Note from Book" entry (id "notes")
	 "%?* Page(s) %^{Page}\n** Quote\n%^{Quote}\n** Note\n%^{Note}")))


;; jedi
;; Start Jedi in Python mode
;; Disable this for now to try plain company mode
;; (add-hook 'python-mode-hook 'jedi:setup)
;; Start jedi autocomplete when doing dot references
;; (setq jedi:complete-on-dot t)
;; This leverages company-jedi
;; (add-to-list `company-backends `company-jedi)

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
  (local-set-key (kbd "C-c f") 'tide-format)
  (local-set-key (kbd "C-c r") `tide-references)
)
(add-hook 'typescript-mode-hook #'setup-tide-mode)
(setq tide-format-options
      '(:convertTabsToSpace t
			    :indentSize 2
			    :insertSpaceAfterCommaDelimiter t
			    :tabSize 2)
      )
;; For tsx support
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
;; enable typescript-tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)

;; Correctly set exec path on macos
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))
;; Miscellaneous modes
;; Line and column numbers
(setq column-number-mode t)
(setq lin-number-mode t)
;; Show matching parenthesis mode
;; (setq show-paren-delay 0)

;; Elpy config
(elpy-enable)
;; Use Flycheck for syntax checking
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))
;; Enable narrowing
(put 'narrow-to-defun  'disabled nil)
(put 'narrow-to-page   'disabled nil)
(put 'narrow-to-region 'disabled nil)

;; Use node_modules as a source for executables for flycheck
;; https://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable
(defun use-tslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (tslint
          (and root
               (expand-file-name "node_modules/.bin/tslint"
                                 root))))
    (when (and tslint (file-executable-p tslint))
      (setq-local flycheck-typescript-tslint-executable tslint))))

(add-hook 'flycheck-mode-hook #'use-tslint-from-node-modules)

;; rjsx/rjsx mode
;; Enable mode for js files under components dir
(add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode))
(add-to-list 'auto-mode-alist '("pages\\/.*\\.js\\'" . rjsx-mode))
(add-hook 'rjsx-mode #'(lambda () (if (buffer-file-name)
                                      (if (or (string-match "\.jsx$" buffer-file-name)
                                              (string-match "\.js$" buffer-file-name))
                                          (funcall prettier-js-mode)))))

;; web-mode
;; Enable web-mode for tsx files
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))

;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "New name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))
