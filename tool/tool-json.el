;; -*- lexical-binding: t; -*-

(defun json-escape-string (s)
  "Escape string S for JSON."
  (replace-regexp-in-string
   "[\\\"\b\f\n\r\t]"
   (lambda (c)
     (pcase c
       ("\\" "\\\\")
       ("\"" "\\\"")
       ("\b" "\\b")
       ("\f" "\\f")
       ("\n" "\\n")
       ("\r" "\\r")
       ("\t" "\\t")))
   s t t))

(defun json-unescape-string (s)
  "Unescape JSON string S (safe, literal replacements)."
  (let ((result s))
    (setq result (replace-regexp-in-string "\\\\\\\\" "\\" result nil 'literal)) ; double backslash first!
    (setq result (replace-regexp-in-string "\\\\\"" "\"" result nil 'literal))
    (setq result (replace-regexp-in-string "\\\\b" "\b" result nil 'literal))
    (setq result (replace-regexp-in-string "\\\\f" "\f" result nil 'literal))
    (setq result (replace-regexp-in-string "\\\\n" "\n" result nil 'literal))
    (setq result (replace-regexp-in-string "\\\\r" "\r" result nil 'literal))
    (setq result (replace-regexp-in-string "\\\\t" "\t" result nil 'literal))
    result))


(defun json-escape-region (start end)
  "Escape JSON in region."
  (interactive "r")
  (let ((escaped (json-escape-string (buffer-substring-no-properties start end))))
    (delete-region start end)
    (insert escaped)))

(defun json-unescape-region (start end)
  "Unescape JSON in region."
  (interactive "r")
  (let ((unescaped (json-unescape-string (buffer-substring-no-properties start end))))
    (delete-region start end)
    (insert unescaped)))


(defun stringify-buffer-to-json (&optional to-buffer)
  "Stringify the current buffer content into a JSON-compatible string.
If TO-BUFFER is non-nil, output goes to a new buffer; otherwise, it's copied to the kill ring."
  (interactive "P")
  (let ((stringified (json-encode-string (buffer-substring-no-properties (point-min) (point-max)))))
    (if to-buffer
        (with-current-buffer (get-buffer-create "*Stringified JSON*")
          (erase-buffer)
          (insert stringified)
          (json-mode)
          (pop-to-buffer (current-buffer)))
      (kill-new stringified)
      (message "Buffer content stringified and copied to clipboard."))))


(provide 'tool-json)
