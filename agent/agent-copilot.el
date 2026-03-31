;; -*- lexical-binding: t; -*-


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
(add-hook 'prog-mode-hook #'copilot-nes-mode)
(provide 'agent-copilot)
