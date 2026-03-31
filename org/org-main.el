;; -*- lexical-binding: t; -*-

(require 'org)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((plantuml . t)))

(setq org-plantuml-exec-mode 'plantuml)
(setq plantuml-default-exec-mode 'server)

(setq org-agenda-files '("~/Documents/personal/org/journal/"))


;; Start scratch buffer in org mode
(setq initial-major-mode 'org-mode)
(setq initial-scratch-message "#+title: Scratch\n\n")

(with-eval-after-load 'org-faces
  ;; Resize Org headings
  (dolist (face '((org-level-1 . 135)
                  (org-level-2 . 130)
                  (org-level-3 . 120)
                  (org-level-4 . 110)
                  (org-level-5 . 110)
                  (org-level-6 . 110)
                  (org-level-7 . 110)
                  (org-level-8 . 110)))
    (set-face-attribute (car face) nil
                        :font "JetBrains Mono"
                        :weight 'bold
                        :height (cdr face)))

  ;; Document title
  (set-face-attribute 'org-document-title nil
                      :font "JetBrains Mono"
                      :weight 'bold
                      :height 180))

(setq org-src-fontify-natively t
	  org-src-tab-acts-natively t
      org-edit-src-content-indentation 0)

(use-package writeroom-mode
  :ensure t)
(add-hook 'org-mode-hook 'writeroom-mode)

(defun my/org-writing-setup ()
  ;; text layout
  (visual-line-mode 1)
  (visual-fill-column-mode 1)

  ;; fonts
  (variable-pitch-mode 1)

  ;; ui
  (display-line-numbers-mode -1)
  (setq cursor-type 'box)
  (blink-cursor-mode 0))

(add-hook 'org-mode-hook #'my/org-writing-setup)

(use-package org-superstar
  :ensure t
  :hook (org-mode . org-superstar-mode))
(use-package org-modern
  :ensure t
  :hook (org-mode . org-modern-mode))
(use-package org-appear
  :ensure t
  :hook (org-mode . org-appear-mode))
(use-package mixed-pitch
  :ensure t
  :hook (org-mode . mixed-pitch-mode))
(use-package visual-fill-column
  :ensure t
  :hook (org-mode . visual-fill-column-mode))
;; core org settings
(setq org-hide-leading-stars t
      org-startup-indented   t)

;; ox-hugo: org-mode to hugo markdown exporter
(use-package ox-hugo
  :ensure t
  :pin melpa
  :after ox)

(provide 'org-main)
