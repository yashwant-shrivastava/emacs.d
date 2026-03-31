;; -*- lexical-binding: t; -*-

(use-package dap-mode
  :ensure t
  :config
  (dap-auto-configure-mode)

  ;; Auto-install Go debug adapter if missing
  (require 'dap-dlv-go))

;; --- OPTIONAL UI ---
(use-package dap-ui
  :after dap-mode
  :config
  (dap-ui-mode 1))

;; --- Go helpers ---
(require 'dap-dlv-go)

(defun my/dap-go-test-at-point ()
  "Debug Go test at point."
  (interactive)
  (let ((test-name
         (save-excursion
           (end-of-line)
           (when (re-search-backward "^func \\(Test[^(]+\\)" nil t)
             (match-string 1)))))
    (if test-name
        (dap-debug
         (list :type "go"
               :request "launch"
               :mode "test"
               :program "."
               :args (list "-test.run" (concat "^" test-name "$"))))
      (message "No test found at point"))))

(defun my/dap-go-test-package ()
  "Debug all Go tests in package."
  (interactive)
  (dap-debug
   (list :type "go"
         :request "launch"
         :mode "test"
         :program ".")))

;; --- Keybindings ---
(with-eval-after-load 'go-ts-mode
  (define-key go-ts-mode-map (kbd "C-c d d") #'my/dap-go-test-at-point)
  (define-key go-ts-mode-map (kbd "C-c d p") #'my/dap-go-test-package)
  (define-key go-ts-mode-map (kbd "<f5>") #'dap-continue)
  (define-key go-ts-mode-map (kbd "<f9>") #'dap-breakpoint-toggle))

(provide 'tool-debug)
