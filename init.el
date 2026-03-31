;; -*- lexical-binding: t; -*-

(setq inhibit-startup-message t)
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 20)        ; Give some breathing room
(menu-bar-mode t)           ; Disable the menu
(delete-selection-mode 1) ;; Replace selection when inserting text
(global-font-lock-mode 1)
(setq-default cursor-type 'box)
(blink-cursor-mode 0)
(setq-default tab-width 4)
(global-hl-line-mode 1)
(global-display-line-numbers-mode)
(global-set-key (kbd "C-f") 'forward-char)
(global-set-key (kbd "C-b") 'backward-char)
(scroll-bar-mode 1)
(global-set-key (kbd "s-<backspace>") 'kill-whole-line)
(global-set-key (kbd "s-l") 'goto-line)
(global-set-key (kbd "C-x k") 'kill-current-buffer)
(global-auto-revert-mode t)
(setq auto-revert-check-vc-info t)
(setq backup-directory-alist '(("." . "~/.emacs-backups")))
(setq auto-save-default nil)
(setq idle-update-delay 0.5)
(setq jit-lock-defer-time 0)
(setq debug-on-error t)
(setq frame-resize-pixelwise t)
(setq window-resize-pixelwise t)
(defconst CACHE-DIR (expand-file-name "cache/" user-emacs-directory))
(defconst PRIV-DIR (expand-file-name "private/" user-emacs-directory))
(defconst RES-DIR   (expand-file-name "resources/" user-emacs-directory))
(defconst IS-MAC    (eq system-type 'darwin))
(defconst IS-LINUX  (eq system-type 'gnu/linux))
(defconst IS-TERM   (not (display-graphic-p)))

(defun get-env-variable (var-name)
  (getenv var-name))

(add-to-list 'exec-path (expand-file-name "~/go/bin"))

(require 'package)
(require 'use-package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
						 ("elpa" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(package-initialize)                 ; Initializes the package system and prepares it to be used
(unless package-archive-contents     ; Unless a package archive already exists,
  (package-refresh-contents))        ; Refresh package contents so that Emacs knows which packages to load

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)   ; Enable evaluation of Emacs Lisp code blocks
   (python . t)       ; Enable evaluation of Python code blocks
   (shell . t)        ; Enable evaluation of shell commands
   ))

(add-hook 'text-mode-hook 'auto-fill-mode)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-hook 'window-setup-hook 'toggle-frame-fullscreen t)
(set-face-attribute 'default nil :height 140)
(put 'erase-buffer 'disabled nil)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

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


(add-to-list 'load-path (expand-file-name "org" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "ui" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "agent" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "music" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "doc" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lang" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "tool" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lsp" user-emacs-directory))

(require 'ui-main)
(require 'doc-main)
(require 'tool-beautify)
(require 'tool-nav)
(require 'lang-treesitter)
(require 'lang-tsfold)
(require 'lang-checker)
(require 'lsp-main)
(require 'lsp-python)
(require 'lang-go)
(require 'lang-protobuf)
(require 'lang-php)
(require 'lang-dockerfile)
(require 'lang-yaml)
(require 'tool-json)
(require 'tool-time)
(require 'tool-string)
(require 'tool-beautify)
(require 'tool-custom)
(require 'tool-git)
(require 'tool-debug)
(require 'org-main)
(require 'org-journal)
(require 'agent-gptel)
(require 'agent-copilot)
(require 'agent-claudecode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("0325a6b5eea7e5febae709dab35ec8648908af12cf2d2b569bedc8da0a3a81c1"
	 "45631691477ddee3df12013e718689dafa607771e7fd37ebc6c6eb9529a8ede5"
	 default))
 '(package-vc-selected-packages
   '((gemini-cli :url "https://github.com/linchen2chris/gemini-cli.el")))
 '(warning-suppress-types '((treesit) (treesit))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
