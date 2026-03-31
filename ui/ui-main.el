;; -*- lexical-binding: t; -*-

;; Theme settle
(use-package modus-themes
  :ensure t
  :demand t
  :config
  ;; Your customizations here:
  (setq modus-themes-to-toggle '(modus-operandi modus-vivendi)
        modus-themes-to-rotate modus-themes-items
        modus-themes-mixed-fonts t
        modus-themes-variable-pitch-ui t
        modus-themes-italic-constructs t
        modus-themes-bold-constructs t
        modus-themes-completions '((t . (bold)))
        modus-themes-prompts '(bold)
        modus-themes-headings
        '((agenda-structure . (variable-pitch light 2.2))
          (agenda-date . (variable-pitch regular 1.3))
          (t . (regular 1.15))))

  (setq modus-themes-common-palette-overrides nil)
  (modus-themes-load-theme 'modus-operandi-tinted))

;; font family
(set-face-attribute 'default nil
                    :family "JetBrains Mono"
                    :height 140
                    :weight 'regular)

;; ligature mode enabled
(use-package ligature
  :load-path "path-to-ligature-repo"
  :config
  (ligature-set-ligatures
   't
   '("==" "!=" "===" "!==" "=>"
     "->" "<-" "<->"
     "<=" ">=" "&&" "||"
     "::" "..." "++" "***" "///"))
  (global-ligature-mode t))

(provide 'ui-main)

