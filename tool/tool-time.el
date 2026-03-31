;; -*- lexical-binding: t; -*-


(defun get-epoch-time ()
  "Return the current epoch time as an integer."
  (floor (float-time (current-time))))

(provide 'tool-time)
