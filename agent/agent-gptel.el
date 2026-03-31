;; lexical-binding: t;

(straight-use-package 'gptel)
(gptel-make-gemini "Gemini" :key (get-env-variable "GEMINI_API_KEY") :stream t)

(provide 'agent-gptel)
