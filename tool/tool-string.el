;; -*- lexical-binding: t; -*-


(defun print-stringify-string()
  "Unescape \\n sequences in the selected region like Python would."
  (interactive)
  (let ((input (buffer-substring-no-properties (region-beginning) (region-end)))
        unescaped)
    (setq unescaped (read (concat "\"" input "\""))) ; read evaluates the escape sequences
    (with-output-to-temp-buffer "*Unescaped Output*"
      (princ unescaped))))

(provide 'tool-string)
