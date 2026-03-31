;; -*- lexical-binding: t; -*-


(use-package marginalia
  :straight t
  :init
  (marginalia-mode)) ;; Enable marginalia globally

(use-package embark
  :straight t
  :bind
  (("C-." . embark-act) ;; Context-aware actions
   ("C-," . embark-dwim)) ;; Default action
  :init
  (setq prefix-help-command #'embark-prefix-help-command)) ;; Show keybindings in prefix menu

(use-package smartparens
  :ensure t
  :config
  (smartparens-global-mode t))

(use-package yasnippet
  :ensure t
  :hook (php-ts-mode . yas-minor-mode)
  :hook (lsp-mode . yas-minor-mode)
  :config
  (yas-global-mode 1))


(use-package prettier-js
  :ensure t
  :hook ((js-mode . prettier-js-mode)
         (typescript-mode . prettier-js-mode)))

(global-set-key (kbd "M-j") 'json-pretty-print)
(global-set-key (kbd "M--") 'json-navigator-navigate-region)


(use-package expand-region
  :ensure t)
(global-set-key (kbd "C-c a") 'er/expand-region)


;; Ensure `vertico` is installed and enabled
(use-package vertico
  :straight t   ;; Use :ensure t if using package.el
  :init
  (vertico-mode)) ;; Enable vertico globally

(set-face-attribute 'default nil
                    :family "JetBrains Mono"  ;; Replace with your preferred font
                    :height 140)             ;; Font size in 10ths of a point

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(provide 'tool-beautify)
