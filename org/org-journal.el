;;; -*- lexical-binding: t; -*-

;;; org-journal.el --- Personal journaling system

;;; Commentary:
;; All journaling-related configuration:
;; - daily / weekly / monthly reviews
;; - templates
;; - navigation commands
;; - agenda integration

(require 'org)
(require 'org-agenda)

;;; Paths
(setq org-directory "~/Documents/personal/org/")
(setq my/journal-dir (expand-file-name "journal/" org-directory))

;;; Agenda
(setq org-agenda-files (list my/journal-dir))

;;; Daily journal
(defun my/journal-daily ()
  "Open today's daily journal file and insert template if new."
  (interactive)
  (let* ((base-dir "~/Documents/personal/org/journal/")
         (date (current-time))
         (year (format-time-string "%Y" date))
         (month (format-time-string "%m" date))
         (day (format-time-string "%d" date))
         (dir (expand-file-name (format "%s/%s/" year month) base-dir))
         (file (expand-file-name (format "%s_daily.org" day) dir)))
    ;; ensure directory exists
    (unless (file-directory-p dir)
      (make-directory dir t))

    ;; open file
    (find-file file)

    ;; insert template only if file is new
    (when (= (buffer-size) 0)
      (insert (format-time-string
               "#+TITLE: Daily Review – %Y-%m-%d\n"))
      (insert (format-time-string
               "#+DATE: <%Y-%m-%d %a>\n"))
      (insert "#+STARTUP: folded\n\n")

      (insert "* 🌅 Morning Intention\n- \n\n")
      (insert "* 💻 Work / Functions\n- [ ] \n\n")
      (insert "* 🧠 Learnings\n- \n\n")
      (insert "* 🧩 Decisions Made\n- \n\n")
      (insert "* 🔥 Highlights\n- \n\n")
      (insert "* ⚠️ Challenges\n- \n\n")
      (insert "* 😊 Mood & Energy\n- Mood ::\n- Energy ::\n\n")
      (insert "* 🙏 Gratitude\n- \n\n")
      (insert "* 📝 Notes\n- \n"))))

;;; Weekly review
(defun my/journal-weekly ()
  "Open this week's journal review file."
  (interactive)
  (let* ((base-dir "~/Documents/personal/org/journal/")
         (date (current-time))
         (year (format-time-string "%Y" date))
         (month (format-time-string "%m" date))
         (week (format-time-string "%V" date))
         (dir (expand-file-name (format "%s/%s/" year month) base-dir))
         (file (expand-file-name (format "%s_weekly.org" week) dir)))
    ;; ensure directory exists
    (unless (file-directory-p dir)
      (make-directory dir t))

    ;; open file
    (find-file file)

    ;; insert template if new
    (when (= (buffer-size) 0)
      (insert (format-time-string
               "#+TITLE: Weekly Review – Week %V (%Y)\n"))
      (insert (format-time-string
               "#+DATE: <%Y-%m-%d %a>\n"))
      (insert "#+STARTUP: folded\n\n")

      (insert "* 🧭 Weekly Overview\n")
      (insert "- Theme of the week ::\n")
      (insert "- Overall feeling ::\n\n")

      (insert "* ✅ Highlights\n- \n\n")
      (insert "* ⚠️ Challenges / Friction\n- \n\n")
      (insert "* 🧠 Key Learnings\n- \n\n")
      (insert "* 🧩 Important Decisions\n- \n\n")

      (insert "* 📊 Work Summary\n")
      (insert "- What went well ::\n")
      (insert "- What didn’t ::\n\n")

      (insert "* 🔁 Patterns Observed\n- \n\n")
      (insert "* 🙏 Gratitude\n- \n\n")
      (insert "* 🎯 Focus for Next Week\n- \n"))))
  

;;; Monthly review
(defun my/journal-monthly ()
  "Open this month's journal review file."
  (interactive)
  (let* ((base-dir "~/Documents/personal/org/journal/")
         (date (current-time))
         (year (format-time-string "%Y" date))
         (month (format-time-string "%m" date))
         (dir (expand-file-name (format "%s/%s/" year month) base-dir))
         (file (expand-file-name "monthly.org" dir)))
    ;; ensure directory exists
    (unless (file-directory-p dir)
      (make-directory dir t))

    ;; open file
    (find-file file)

    ;; insert template if new
    (when (= (buffer-size) 0)
      (insert (format-time-string
               "#+TITLE: Monthly Review – %B %Y\n"))
      (insert (format-time-string
               "#+DATE: <%Y-%m-%d %a>\n"))
      (insert "#+STARTUP: folded\n\n")

      (insert "* 🧭 Month at a Glance\n")
      (insert "- Theme of the month ::\n")
      (insert "- Overall mood ::\n\n")

      (insert "* 🏆 Key Wins\n- \n\n")
      (insert "* ⚠️ Challenges & Pain Points\n- \n\n")
      (insert "* 🧠 Major Learnings\n- \n\n")
      (insert "* 🧩 Important Decisions\n- \n\n")

      (insert "* 📊 Work & Life Summary\n")
      (insert "** Work\n")
      (insert "- What went well ::\n")
      (insert "- What didn’t ::\n\n")
      (insert "** Personal\n")
      (insert "- Health ::\n")
      (insert "- Relationships ::\n")
      (insert "- Finances ::\n\n")

      (insert "* 🔁 Patterns & Trends\n- \n\n")
      (insert "* 🙏 Gratitude\n- \n\n")
      (insert "* ❌ What to Stop Doing\n- \n\n")
      (insert "* 🔄 What to Continue\n- \n\n")
      (insert "* ➕ What to Start\n- \n\n")
      (insert "* 🎯 Focus for Next Month\n- \n"))))

;;; Keybindings
(global-set-key (kbd "C-c j d") #'my/journal-daily)
(global-set-key (kbd "C-c j w") #'my/journal-weekly)
(global-set-key (kbd "C-c j m") #'my/journal-monthly)

(provide 'org-journal)
