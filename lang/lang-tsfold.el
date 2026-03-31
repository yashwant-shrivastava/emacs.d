;; -*- lexical-binding: t; -*-

;; treesit-fold uses Emacs 29+ built-in treesit (not the old tsc/tree-sitter package).
;; This avoids the tsc-lang-abi-too-new error caused by tree-sitter-langs shipping
;; grammars with ABI 15 while the old tsc package only supports ABI <= 13.
(use-package treesit-fold
  :straight (treesit-fold :type git :host github :repo "emacs-tree-sitter/treesit-fold")
  :hook ((go-ts-mode . treesit-fold-mode)
         (php-ts-mode . treesit-fold-mode))
  :bind (("C-c C-f" . treesit-fold-toggle)
         ("C-c C-o" . treesit-fold-open)
         ("C-c C-+" . treesit-fold-open-all)
         ("C-c C--" . treesit-fold-close-all)
         ("C-c C-c" . treesit-fold-close)))

(provide 'lang-tsfold)
