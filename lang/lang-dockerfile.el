;; -*- lexical-binding: t; -*-


(use-package dockerfile-mode
  :ensure t
  :mode ("\\`Dockerfile\\'" . dockerfile-ts-mode))

(provide 'lang-dockerfile)
