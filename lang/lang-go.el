;; -*- lexical-binding: t; -*-


(defun my-restart-lsp-on-go-mod-change ()
  "Restart LSP if go.mod changes."
  (when (and (buffer-file-name)
             (string-match-p "go\\.mod$" (buffer-file-name)))
    (lsp-restart-workspace)))

(add-hook 'after-save-hook 'my-restart-lsp-on-go-mod-change)

(defun my-lsp-enable-for-go-mod ()
  "Enable LSP for go.mod files."
  (when (string-equal (buffer-name) "go.mod")
    (lsp)))

(add-hook 'go-mod-ts-mode-hook 'my-lsp-enable-for-go-mod)

(use-package gotest
  :ensure t
  :config
  (setq go-test-verbose t)
  :bind (:map go-ts-mode-map
			  ("C-c t" . go-test-current-test))
  )


(provide 'lang-go)
