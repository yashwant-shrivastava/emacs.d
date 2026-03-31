;; -*- lexical-binding: t; -*-


;; Install `consult`
(use-package consult
  :straight t    ;; Use :ensure t if using package.el
  :config
  (setq consult-narrow-key "<")  ;; Set the key for narrowing
  :bind
  (("C-x b" . consult-buffer)               ;; Enhanced buffer switching
   ("M-y" . consult-yank-pop)               ;; Better kill-ring browsing
   ("s-l" . consult-goto-line)            ;; Navigate to a line
   ("s-p" . consult-projectile)                 ;; Search for files
   ("s-r g" . consult-ripgrep)              ;; Ripgrep integration
   ("s-f" . consult-line)                 ;; Search within buffer lines
   ("M-s m" . consult-mark)                 ;; Jump to marks
   ("M-s i" . consult-imenu)                ;; Search symbols in buffer
   ))

;; Optionally enable preview for commands like `consult-buffer`
(setq consult-preview-key '(:debounce 0.2 any))

(use-package orderless
  :straight t
  :custom
  (completion-styles '(orderless basic)) ;; Use `orderless` with fallback to `basic`
  (completion-category-defaults nil)    ;; No category-specific styles
  (completion-category-overrides '((file (styles partial-completion))))) ;; Better file completion

;; Optionally install embark-consult for better integration
(use-package embark-consult
  :straight t
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))


(use-package consult-gh
  :straight (consult-gh :type git :host github :repo "armindarvish/consult-gh")
  :after consult
  :config
  (require 'consult-gh-transient)
  (require 'consult-gh-embark)
  (require 'consult-gh-forge)
  (consult-gh-embark-mode +1)
  (consult-gh-forge-mode +1))

(use-package better-jumper
  :ensure t
  :config
  (better-jumper-mode 1)
  (setq better-jumper-add-jump-behavior 'append)
  (setq better-jumper-context-lines 10)
  (setq better-jumper-max-length 100)
  (setq better-jumper-use-evil-jump-advice nil)
  
  ;; Global keybindings for jumping
  (global-set-key (kbd "s-[") 'better-jumper-jump-backward)
  (global-set-key (kbd "s-]") 'better-jumper-jump-forward))

(advice-add 'lsp-find-definition :before #'better-jumper-set-jump)
(advice-add 'lsp-find-implementation :before #'better-jumper-set-jump)
(advice-add 'lsp-find-type-definition :before #'better-jumper-set-jump)


;; Remember recent files (only stores file paths, not contents)
(recentf-mode 1)
(setq recentf-max-saved-items 200)

;; Remember cursor position in files
(save-place-mode 1)

;; Projectile configuration
(use-package projectile
  :straight t
  :config
  (projectile-mode +1)
  ;; Set projectile indexing method
  (setq projectile-indexing-method 'alien)
  (setq projectile-completion-system 'default)

  ;; Open most recent file when switching projects (VS Code-like)
  (setq projectile-switch-project-action
        (lambda ()
          (let* ((project-root (projectile-acquire-root))
                 (recent-file (seq-find
                               (lambda (f) (string-prefix-p project-root f))
                               recentf-list)))
            (if recent-file
                (find-file recent-file)
              (projectile-find-file)))))

  ;; Define a key map prefix for projectile
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))
 
(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 1
        company-ip-align-annotations t))



;; Linear undo/redo (VS Code-like)
(use-package undo-fu
  :straight t
  :bind
  (("s-z" . undo-fu-only-undo)
   ("s-Z" . undo-fu-only-redo)))

;; Persist undo history across Emacs restarts
(use-package undo-fu-session
  :straight t
  :config
  (undo-fu-session-global-mode))

(provide 'tool-nav)
