;; -*- lexical-binding: t; -*-

(use-package agent-shell
    :ensure t
    :ensure-system-package
    ;; Add agent installation configs here
    ((claude . "brew install claude-code")
     (claude-agent-acp . "npm install -g @zed-industries/claude-agent-acp")))

(provide 'agent-acp)
