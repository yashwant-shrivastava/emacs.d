;; -*- lexical-binding: t; -*-

(use-package magit
  :ensure t
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

(put 'magit-clean 'disabled nil)

(use-package git-link
     :ensure t)
(setq git-link-default-remote "zomato")
(setq git-link-default-branch "master")
(global-set-key (kbd "C-c g l") 'git-link)
(global-set-key (kbd "C-c g c") 'git-link-commit)


(provide 'tool-git)
