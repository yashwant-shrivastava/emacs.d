;; -*- lexical-binding: t; -*-



(use-package treesit
  :ensure nil
  :init
  ;; Must be set early
  (setq treesit-font-lock-level 4))

(unless (treesit-language-available-p 'go)
  (treesit-install-language-grammar 'go))

(unless (treesit-language-available-p 'gomod)
  (treesit-install-language-grammar 'gomod))

(setq treesit-language-source-alist
      '((php "https://github.com/tree-sitter/tree-sitter-php")
		(go "https://github.com/tree-sitter/tree-sitter-go")
        (gomod "https://github.com/camdencheek/tree-sitter-go-mod")))

(dolist (lang '(go gomod php))
  (unless (treesit-language-available-p lang)
    (treesit-install-language-grammar lang)))

(when (treesit-available-p)
  (add-to-list 'major-mode-remap-alist '(php-mode . php-s-mode))
  (add-to-list 'major-mode-remap-alist '(go-mode . go-ts-mode)))

(use-package go-ts-mode
  :ensure nil
  :mode "\\.go\\'"
  :init
  (add-to-list 'treesit-language-source-alist '(go "https://github.com/tree-sitter/tree-sitter-go"))
  (add-to-list 'treesit-language-source-alist '(gomod "https://github.com/camdencheek/tree-sitter-go-mod"))
  (add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
  (add-to-list 'auto-mode-alist '("/go\\.mod\\'" . go-mod-ts-mode))
  :config
  (setq-default go-ts-mode-indent-offset tab-width))


(use-package php-ts-mode
  :ensure nil
  :mode "\\.php\\'"
  :init
  (add-to-list 'treesit-language-source-alist '(php "https://github.com/tree-sitter/tree-sitter-php"))
  (add-to-list 'auto-mode-alist '("\\.php\\'" . php-ts-mode))
  :config
  (setq-default indent-tabs-mode nil)  ;; Use spaces instead of tabs
  (setq-default tab-width 4)           ;; Ensure tab width is 4 spaces
  (setq-default php-ts-mode-indent-offset 4)) ;; Ensure proper indentation


(use-package typescript-ts-mode
  :ensure nil
  :mode "\\.ts\\'"
  :init
  (add-to-list 'treesit-language-source-alist '(php "https://github.com/tree-sitter/tree-sitter-typescript"))
  (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
  :config
  (setq-default indent-tabs-mode nil)  ;; Use spaces instead of tabs
  (setq-default tab-width 4)           ;; Ensure tab width is 4 spaces
  (setq-default typescript-ts-mode-indent-offset 4)) ;; Ensure proper indentation

(use-package javascript-ts-mode
  :ensure nil
  :mode "\\.js\\'"
  :init
  (add-to-list 'treesit-language-source-alist '(php "https://github.com/tree-sitter/tree-sitter-javascript"))
  (add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-ts-mode))
  :config
  (setq-default indent-tabs-mode nil)  ;; Use spaces instead of tabs
  (setq-default tab-width 4)           ;; Ensure tab width is 4 spaces
  (setq-default javascript-ts-mode-indent-offset 4)) ;; Ensure proper indentation

(provide 'lang-treesitter)
