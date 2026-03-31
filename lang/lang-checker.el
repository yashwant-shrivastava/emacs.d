;; -*- lexical-binding: t; -*-


(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)

  ;; Set up flycheck for Go mode only
  (add-hook 'go-mode-hook
            (lambda ()
              (flycheck-mode 1)  ;; Enable Flycheck in Go mode
              ;; Customize the visual error indicators for Go files
              (setq flycheck-indication-mode 'left-fringe)
              (setq flycheck-highlighting-mode 'symbols)  ;; Show errors in the buffer and scrollbar
              (set-face-background 'flycheck-fringe-error "red")  ;; Red error line in the scrollbar
              (set-face-background 'flycheck-fringe-warning "yellow"))))  ;; Yellow for warnings (optional)

(provide 'lang-checker)
