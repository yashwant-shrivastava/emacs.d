;; -*- lexical-binding: t; -*-

(use-package multiple-cursors
  :ensure t)

(defun copy-directory-path()
  "Copy the current directory path relative to the project root to the clipboard."
  (interactive)
  (let* ((project-root (projectile-project-root))
         (current-dir (file-name-directory (or (buffer-file-name) default-directory)))
         (relative-dir (file-relative-name current-dir project-root)))
    (kill-new relative-dir)
    (message "Copied directory path: %s" relative-dir)))
(global-set-key (kbd "C-c C-d") 'copy-directory-path)

(defun my-emacs-config()
   "Open the ~/.emacs.d directory in dired."
  (interactive)
  (dired "~/.emacs.d/"))

(defun my/xref-select-and-close ()
  "Select xref item and close the xref window"
  (interactive)
  (xref-goto-xref)
  (delete-windows-on "*xref*"))

;; Bind s-RET (Super + Enter) to the close-after-select function in xref window
(with-eval-after-load 'xref
(define-key xref--xref-buffer-mode-map (kbd "C-<return>") 'my/xref-select-and-close))

;; vterm: multiple sessions support
(use-package vterm
  :ensure t
  :config
  (setq vterm-max-scrollback 10000))

(defun vterm-new (name)
  "Create a new vterm buffer with NAME."
  (interactive "sVterm buffer name: ")
  (vterm (concat "*vterm-" name "*")))

(global-set-key (kbd "C-c t t") 'vterm)        ;; open or switch to existing vterm
(global-set-key (kbd "C-c t n") 'vterm-new)    ;; create a new named vterm

(add-hook 'vterm-mode-hook
          (lambda ()
            (setq-local global-hl-line-mode nil)
            (hl-line-mode -1)
            (display-line-numbers-mode -1)
            (display-fill-column-indicator-mode -1)))

(defun my/aws-credentials-from-input (profile)
  "Paste AWS exports in a temp buffer and save to ~/.aws/credentials."
  (interactive "sProfile (default): ")

  (let ((profile (if (string-empty-p profile) "default" profile)))
    (switch-to-buffer "*AWS Credentials Input*")
    (erase-buffer)
    (text-mode)

    (insert ";; Paste AWS exports below, then press C-c C-c\n\n")

    (local-set-key
     (kbd "C-c C-c")
     (lambda ()
       (interactive)
       (let* ((input (buffer-string))
              (access-key (when (string-match "AWS_ACCESS_KEY_ID=\\([^ \n]+\\)" input)
                            (match-string 1 input)))
              (secret-key (when (string-match "AWS_SECRET_ACCESS_KEY=\\([^ \n]+\\)" input)
                            (match-string 1 input)))
              (session-token (when (string-match "AWS_SESSION_TOKEN=\\([^ \n]+\\)" input)
                               (match-string 1 input)))
              (cred-file (expand-file-name "~/.aws/credentials")))

         (unless (and access-key secret-key session-token)
           (error "Could not parse all AWS credentials"))

         (with-temp-buffer
           ;; Load existing credentials
           (when (file-exists-p cred-file)
             (insert-file-contents cred-file))

           ;; Remove existing profile block
           (goto-char (point-min))
           (when (re-search-forward (format "^\\[%s\\]" profile) nil t)
             (let ((start (match-beginning 0)))
               (if (re-search-forward "^\\[" nil t)
                   (delete-region start (match-beginning 0))
                 (delete-region start (point-max)))))

           ;; Append new credentials
           (goto-char (point-max))
           (insert (format "[%s]\naws_access_key_id=%s\naws_secret_access_key=%s\naws_session_token=%s\n"
                           profile access-key secret-key session-token))

           ;; Save file
           (write-region (point-min) (point-max) cred-file))

         (kill-buffer)
         (message "✅ AWS credentials updated for profile: %s" profile))))))

(provide 'tool-custom)
