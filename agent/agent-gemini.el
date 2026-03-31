;; -*- lexical-binding: t; -*-

(use-package popup :ensure t)

(use-package gemini-cli
  :straight (:type git :host github :repo "linchen2chris/gemini-cli.el" :branch "main"
                   :files ("*.el" (:exclude "demo.gif")))
  :config
  (gemini-cli-mode))

(setq gemini-cli-terminal-backend 'vterm)

