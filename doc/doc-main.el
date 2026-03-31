;;

;; -*- lexical-binding: t; -*-

  ;; Read ePub files
(use-package nov
  :init
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . nov-mode)))

(require  'calibredb)
(setq calibredb-root-dir "~/Documents/Books/calibre")
(setq calibredb-db-dir "~/Documents/Books/calibre/metadata.db")
(setq calibredb-library-alist '(("~/Documents/Books/calibre")
                                 ("~/Documents/Books/calibre/Books Library")))

(setq sql-sqlite-program "/usr/bin/sqlite3")
(setq calibredb-program "/Applications/calibre.app/Contents/MacOS/calibredb")

(provide 'doc-main)
