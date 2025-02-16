(setq inhibit-startup-message t)
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 20)        ; Give some breathing room
(menu-bar-mode t)           ; Disable the menu
(delete-selection-mode 1) ;; Replace selection when inserting text

(setq debug-on-error t)
(defconst CACHE-DIR (expand-file-name "cache/" user-emacs-directory))
(defconst PRIV-DIR (expand-file-name "private/" user-emacs-directory))
(defconst RES-DIR   (expand-file-name "resources/" user-emacs-directory))
(defconst IS-MAC    (eq system-type 'darwin))
(defconst IS-LINUX  (eq system-type 'gnu/linux))
(defconst IS-TERM   (not (display-graphic-p)))

(defun get-env-variable (var-name)
  (getenv var-name))

(require 'package)
(require 'use-package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
						 ("elpa" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(package-initialize)                 ; Initializes the package system and prepares it to be used

(unless package-archive-contents     ; Unless a package archive already exists,
  (package-refresh-contents))        ; Refresh package contents so that Emacs knows which packages to load

(setq-default tab-width 4)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)   ; Enable evaluation of Emacs Lisp code blocks
   (python . t)       ; Enable evaluation of Python code blocks
   (shell . t)        ; Enable evaluation of shell commands
   ;; Add more languages as needed
   ))

(add-hook 'text-mode-hook 'auto-fill-mode)

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-hook 'window-setup-hook 'toggle-frame-fullscreen t)
(set-face-attribute 'default nil :height 140)
(put 'erase-buffer 'disabled nil)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'org-mode-hook 'org-indent-mode)
(setq column-number-mode t)


(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package emacs
  :ensure nil
  :config
  (defalias 'yes-or-no-p 'y-or-n-p)
  
  (setq ring-bell-function 'ignore)
  (defun beginning-of-line-or-indentation ()
  "Move to beginning of line, or indentation."
  (interactive)
  (let ((pt (point)))
    (beginning-of-line-text)
    (when (eq pt (point))
      (beginning-of-line)))))


  ;; Read ePub files
(use-package nov
  :init
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . nov-mode)))

(require 'calibredb)
(setq calibredb-root-dir "~/Documents/Books/calibre")
(setq calibredb-db-dir "~/Documents/Books/calibre/metadata.db")
(setq calibredb-library-alist '(("~/Documents/Books/calibre")
                                ("~/Documents/Books/calibre/Books Library")))

(setq sql-sqlite-program "/usr/bin/sqlite3")
(setq calibredb-program "/Applications/calibre.app/Contents/MacOS/calibredb")

(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 1
        company-ip-align-annotations t))


(use-package tree-sitter
  :ensure t)

(use-package treesit
  :config
  (setq treesit-font-lock-level 4) ;; Maximum highlighting
  (add-hook 'php-ts-mode-hook #'font-lock-mode)
  (add-hook 'go-ts-mode-hook #'font-lock-mode)
  (add-hook 'php-ts-mode-hook #'treesit-font-lock-recompute-features)
  (add-hook 'go-ts-mode-hook #'treesit-font-lock-recompute-features))


(unless (treesit-language-available-p 'go)
  (treesit-install-language-grammar 'go))

(unless (treesit-language-available-p 'gomod)
  (treesit-install-language-grammar 'gomod))

(unless (treesit-language-available-p 'php)
  (treesit-install-language-grammar 'php))

(when (treesit-available-p)
  (add-to-list 'major-mode-remap-alist '(php-mode . php-s-mode))
  (add-to-list 'major-mode-remap-alist '(go-mode . go-ts-mode)))

(use-package go-ts-mode
  :ensure nil
  :mode "\\.go\\'"
  :init
  (add-to-list 'treesit-language-source-alist '(go "https://github.com/tree-sitter/tree-sitter-go"))
  (add-to-list 'treesit-language-source-alist '(gomod "https://github.com/camdencheek/tree-sitter-go-mod"))
;;  (dolist (lang '(go gomod)) (treesit-install-language-grammar lang))
  (add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
  (add-to-list 'auto-mode-alist '("/go\\.mod\\'" . go-mod-ts-mode))
  (add-to-list 'tree-sitter-major-mode-language-alist '(go-ts-mode . go))
  (add-to-list 'tree-sitter-major-mode-language-alist '(go-mod-ts-mode . gomod))
  :config
  (setq-default go-ts-mode-indent-offset tab-width))

(use-package php-ts-mode
  :ensure nil
  :mode "\\.php\\'"
  :init
  (add-to-list 'treesit-language-source-alist '(php "https://github.com/tree-sitter/tree-sitter-php"))
  (add-to-list 'auto-mode-alist '("\\.php\\'" . php-ts-mode))
  (add-to-list 'tree-sitter-major-mode-language-alist '(php-ts-mode . php))
  :config
  (setq-default indent-tabs-mode nil)  ;; Use spaces instead of tabs
  (setq-default tab-width 4)           ;; Ensure tab width is 4 spaces
  (setq-default php-ts-mode-indent-offset 4)) ;; Ensure proper indentation


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

(add-hook 'go-mode-hook 'my-lsp-enable-for-go-mod)

(use-package ts-fold
  :straight (ts-fold :type git :host github :repo "emacs-tree-sitter/ts-fold")
  :ensure t
  :hook ((go-ts-mode . ts-fold-mode)
         (php-ts-mode . ts-fold-mode))
  :bind (("C-c C-f" . ts-fold-toggle)
         ("C-c C-o" . ts-fold-open)
		 ("C-c C-+" . ts-fold-open-all)
		 ("C-c C--" . ts-fold-close-all)
         ("C-c C-c" . ts-fold-close))
  :config
  (with-eval-after-load 'ts-fold
    ;; Folding configurations for PHP
    (add-to-list 'ts-fold-range-alist
                 '(php-ts-mode
                   (namespace_use_group . ts-fold-range-seq)
                   (declaration_list . ts-fold-range-seq)
                   (use_list . ts-fold-range-seq)
                   (switch_block . ts-fold-range-seq)
                   (compound_statement . ts-fold-range-seq)
                   (comment lambda (node offset)
							(if (string-prefix-p "#" (tsc-node-text node))
								(ts-fold-range-line-comment node offset "#")
							  (ts-fold-range-c-like-comment node offset)))))
    
    ;; Folding configurations for Go
    (add-to-list 'ts-fold-range-alist
                 '(go-ts-mode
                   (block . ts-fold-range-seq)
                   (comment . ts-fold-range-c-like-comment)
                   (const_declaration lambda (node offset)
									  (ts-fold-range-markers node offset "(" ")"))
                   (field_declaration_list . ts-fold-range-seq)
                   (import_spec_list . ts-fold-range-seq)
                   (interface_type lambda (node offset)
								   (ts-fold-range-markers node offset "{" "}"))))))

(use-package gotest
  :ensure t
  :config
  (setq go-test-verbose t)
  :bind (:map go-ts-mode-map
			  ("C-c t" . go-test-current-test))
  )

(use-package protobuf-mode
  :ensure t
  :mode ("\\.proto\\'" . protobuf-mode))

(use-package lsp-mode
  :hook ((go-ts-mode . lsp-deferred)
         (php-ts-mode . lsp)
         (go-ts-mode . (lambda () (add-hook 'before-save-hook #'lsp-format-buffer nil t))))
  :commands lsp
  :init
  (setq lsp-gopls-server-path "gopls")  ;; specify the path to gopls if it's not in your PATH
  :config
  (setq lsp-intelephense-licence-key (get-env-variable "intelephense_license_key"))
  (setq lsp-intelephense-files-max-size 5000000)
  (setq lsp-file-watch-ignored '())
  (setq lsp-enable-snippet t)
  (setq lsp-enable-file-watchers t)
  (setq lsp-warn-no-watchers nil)
  (setq lsp-response-timeout 30)
  (setq lsp-file-watch-threshold 10000)
  (setq lsp-prefer-flymake nil)  ;; prefer lsp-ui and flycheck over flymake
  (setq lsp-enable-on-type-formatting nil)  ;; disable on-type formatting
  (setq lsp-headerline-breadcrumb-enable t))  ;; enable breadcrumb navigation

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

(add-hook 'protobuf-mode-hook #'lsp)
(setq lsp-protobuf-format-command "buf format")
(add-hook 'lsp-after-open-hook #'lsp-origami-try-enable)

(use-package php-doc-block
  :straight (:host github :repo "moskalyovd/emacs-php-doc-block" :files ("*.el"))
  :ensure t
  :bind ("C-c d" . php-doc-block))

(defun my/xref-select-and-close ()
  "Select xref item and close the xref window"
  (interactive)
  (xref-goto-xref)
  (delete-windows-on "*xref*"))

;; Bind s-RET (Super + Enter) to the close-after-select function in xref window
(with-eval-after-load 'xref
(define-key xref--xref-buffer-mode-map (kbd "C-<return>") 'my/xref-select-and-close))

(use-package flycheck
  :init (global-flycheck-mode))

(use-package yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))

(require 'dap-dlv-go)

(use-package copilot
  :straight (:host github :repo "copilot-emacs/copilot.el" :files ("*.el"))
  :ensure t
  :hook ((prog-mode . copilot-mode))
  :config
  (copilot-diagnose)
  (setq copilot-indent-offset-warning-disable t
        copilot-max-char-warning-disable t
        copilot-max-char 10000)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("M-p" . 'copilot-previous-completion)
	          ("M-n" . 'copilot-next-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

(global-set-key (kbd "<s-mouse-1>") 'lsp-find-implementation)
(global-set-key (kbd "C-c l i") 'lsp-find-implementation)
(global-set-key (kbd "C-c l d") 'lsp-find-definition)
(global-set-key (kbd "C-c l r") 'lsp-find-references)

(defun copy-directory-path()
  "Copy the current directory path relative to the project root to the clipboard."
  (interactive)
  (let* ((project-root (projectile-project-root))
         (current-dir (file-name-directory (or (buffer-file-name) default-directory)))
         (relative-dir (file-relative-name current-dir project-root)))
    (kill-new relative-dir)
    (message "Copied directory path: %s" relative-dir)))
(global-set-key (kbd "C-c C-d") 'copy-directory-path)


;; Ensure `vertico` is installed and enabled
(use-package vertico
  :straight t   ;; Use :ensure t if using package.el
  :init
  (vertico-mode)) ;; Enable vertico globally

;; Projectile configuration
(use-package projectile
  :straight t
  :config
  (projectile-mode +1)
  ;; Set projectile indexing method
  (setq projectile-indexing-method 'alien)
  (setq projectile-completion-system 'default)
  
  ;; Define a key map prefix for projectile
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(global-display-line-numbers-mode)

(global-set-key (kbd "C-f") 'forward-char)
(global-set-key (kbd "C-b") 'backward-char)

(set-face-attribute 'default nil
                    :family "JetBrains Mono"  ;; Replace with your preferred font
                    :height 140)             ;; Font size in 10ths of a point

(use-package yasnippet
  :ensure t
  :hook (php-ts-mode . yas-minor-mode)
  :hook (lsp-mode . yas-minor-mode)
  :config
  (yas-global-mode 1))

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

(use-package smartparens
  :ensure t
  :config
  (smartparens-global-mode t))

(use-package multiple-cursors
  :ensure t)

(scroll-bar-mode 1)

(use-package flycheck
  :ensure t
  :init
  ;; Set up flycheck for Go mode only
  (add-hook 'go-mode-hook
            (lambda ()
              (flycheck-mode 1)  ;; Enable Flycheck in Go mode
              ;; Customize the visual error indicators for Go files
              (setq flycheck-indication-mode 'left-fringe)
              (setq flycheck-highlighting-mode 'symbols)  ;; Show errors in the buffer and scrollbar
              (set-face-background 'flycheck-fringe-error "red")  ;; Red error line in the scrollbar
              (set-face-background 'flycheck-fringe-warning "yellow"))))  ;; Yellow for warnings (optional)

(global-set-key (kbd "s-<backspace>") 'kill-whole-line)
(global-set-key (kbd "s-l") 'goto-line)

(use-package prettier-js
  :ensure t
  :hook ((js-mode . prettier-js-mode)
         (typescript-mode . prettier-js-mode)))

(global-auto-revert-mode t)
(setq auto-revert-check-vc-info t)

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

;; Optionally install embark-consult for better integration
(use-package embark-consult
  :straight t
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(defun my-emacs-config()
   "Open the ~/.emacs.d directory in dired."
  (interactive)
  (dired "~/.emacs.d/"))

(global-set-key (kbd "C-c a") 'er/expand-region)
(global-set-key (kbd "C-c r r") 'lsp-rename)

 (use-package blamer
  :ensure t
  :custom
  (blamer-idle-time 0.3)          ;; Delay before showing blame info
  (blamer-min-offset 70)          ;; Adjust text offset for blame info
  (blamer-view 'overlay)          ;; Inline blame as an overlay
  (blamer-author-formatter " ✎ %s") ;; Format: author
  (blamer-commit-formatter " | %s") ;; Format: commit hash
  :config
  (global-blamer-mode 0))         ;; Enable blamer globally


(setq create-lockfiles nil)
(setq lsp-ui-doc-show-with-cursor nil)
(setq lsp-ui-doc-show-with-mouse t)

(use-package magit
  :ensure t)

(put 'magit-clean 'disabled nil)

(use-package json-rpc-server
  :ensure t)

(global-set-key (kbd "M-j") 'json-pretty-print)
(global-set-key (kbd "M--") 'json-navigator-navigate-region)
(global-set-key (kbd "C-x k") 'kill-current-buffer)
(use-package git-link
     :ensure t)
(setq git-link-default-remote "zomato")
(setq git-link-default-branch "master")
(global-set-key (kbd "C-c g l") 'git-link)
(global-set-key (kbd "C-c g c") 'git-link-commit)


(use-package magit
  :commands (magit-status magit-dispatch)
  :init
  :config
  (setq magit-refresh-status-buffer nil)
  (setq magit-auto-revert-mode nil)
  (setq magit-save-repository-buffers nil)

  (setq magit-diff-refine-hunk t)

  (setq magit-status-headers-hook '(magit-insert-head-branch-header))
  ;; This gives some performance boost to magit
  (remove-hook 'magit-status-sections-hook 'magit-insert-tags-header)
  ;; (remove-hook 'magit-status-sections-hook 'magit-insert-status-headers)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-pushremote)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-pushremote)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-upstream)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-upstream-or-recent)
  (remove-hook 'magit-status-sections-hook 'magit-insert-sequencer-sequence)
  (add-hook 'magit-popup-mode-hook #'hide-mode-line-mode))

(global-hl-line-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("45631691477ddee3df12013e718689dafa607771e7fd37ebc6c6eb9529a8ede5"
	 default))
 '(warning-suppress-types '((treesit))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package consult-gh
  :straight (consult-gh :type git :host github :repo "armindarvish/consult-gh")
  :after consult
  :config
  (require 'consult-gh-transient)
  (require 'consult-gh-embark)
  (require 'consult-gh-forge)
  (consult-gh-embark-mode +1)
  (consult-gh-forge-mode +1))


(defun validation-response-copier()
  "Take a `curl` command from the current buffer, ensure it has `-s`, execute it, pass its output to `validation_response_copier.sh`, and show final output."
  (interactive)
  (let* ((script-path (expand-file-name "~/Documents/zomato/scripts/validation_response_copier.sh"))
         (curl-buffer (get-buffer-create "*curl-output*"))
         (output-buffer (get-buffer-create "*validation-response-output*"))
         (raw-curl-command (buffer-substring-no-properties (point-min) (point-max)))
         (modified-curl-command (if (string-match-p "\\s-\\(-s\\|--silent\\)\\s-" raw-curl-command)
                                    raw-curl-command  ;; Already has -s, keep it as is
                                  (replace-regexp-in-string "\\b\\(curl\\)\\b" "curl -s" raw-curl-command))))
    (unless (file-executable-p script-path)
      (error "Script not found or not executable: %s" script-path))
    (when (string-blank-p raw-curl-command)
      (error "Current buffer is empty or does not contain a curl command"))
    ;; Run modified curl and store output in *curl-output* buffer
    (with-current-buffer curl-buffer
      (erase-buffer)
      (call-process-shell-command modified-curl-command nil t)) ;; Execute the curl command
    ;; Process curl output with the script
    (with-current-buffer output-buffer
      (erase-buffer))
    (with-current-buffer curl-buffer
      (call-process-region (point-min) (point-max) script-path nil output-buffer nil))
    ;; Show the final processed output
    (display-buffer output-buffer)))
