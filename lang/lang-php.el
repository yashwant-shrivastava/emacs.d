;; -*- lexical-binding: t; -*-

(use-package php-doc-block
  :straight (:host github :repo "moskalyovd/emacs-php-doc-block" :files ("*.el"))
  :ensure t
  :bind ("C-c d" . php-doc-block))

(provide 'lang-php)
