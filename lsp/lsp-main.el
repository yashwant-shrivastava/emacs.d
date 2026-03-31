;; -*- lexical-binding: t; -*-

(use-package json-rpc-server
  :ensure t)

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((typescript-ts-mode
          tsx-ts-mode
          js-ts-mode
          dockerfile-ts-mode
          js-mode
          go-ts-mode
          php-ts-mode) . lsp-deferred)
  :init
  :config
  (setq lsp-disabled-clients '(semgrep-ls golangci-lint-ls))
  (setq lsp-intelephense-licence-key (get-env-variable "intelephense_license_key"))
  (setq lsp-intelephense-files-max-size 5000000)
  (setq lsp-enable-snippet t)
  (setq lsp-enable-file-watchers t)
  (setq lsp-warn-no-watchers nil)
  (setq lsp-response-timeout 30)
  (setq lsp-file-watch-threshold 10000)
  (setq lsp-prefer-flymake nil)  ;; prefer lsp-ui and flycheck over flymake
  (setq lsp-enable-on-type-formatting nil)  ;; disable on-type formatting
  (setq lsp-headerline-breadcrumb-enable t))  ;; enable breadcrumb navigation

(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-ts-mode-hook #'lsp-go-install-save-hooks)

(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-sideline-enable nil
		lsp-ui-sideline-show-symbol t
        lsp-ui-sideline-show-hover t
		lsp-ui-sideline-show-code-actions t
		lsp-ui-peek-show-directory t
		lsp-ui-peek-always-show t
		lsp-ui-peek-preserve-window t
		lsp-ui-peek-list-width 80
        lsp-ui-doc-enable t))

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration '(protobuf-mode . "protobuf"))
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection '("protols"))
    :activation-fn (lsp-activate-on "proto")
    :server-id 'protols)))

(setq lsp-ui-doc-show-with-cursor nil)
(setq lsp-ui-doc-show-with-mouse t)

(global-set-key (kbd "<s-mouse-1>") 'lsp-find-implementation)
(global-set-key (kbd "C-c l i") 'lsp-find-implementation)
(global-set-key (kbd "C-c l d") 'lsp-find-definition)
(global-set-key (kbd "C-c l r") 'lsp-find-references)
(global-set-key (kbd "C-c r r") 'lsp-rename)

(provide 'lsp-main)
