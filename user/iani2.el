
(set-fontset-font "fontset-default"
                  'japanese-jisx0208
                  '("Hiragino Mincho Pro" . "iso10646-1"))
(set-fontset-font "fontset-default"
                  'greek
 ;; Note: iso10646-1 = Universal Character set (UCS)
 ;; It is compatible to Unicode, in its basic range
                  '("Menlo" . "iso10646-1"))

(maximize-frame) ;; maximize frame on startup
(defun toggle-fullscreen ()
  "Toggle full screen"
  (interactive)
  (set-frame-parameter
   nil 'fullscreen
   (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))
(tool-bar-mode -1)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(el-get 'sync)

(require 'dash)

(desktop-save-mode 1)

(require 'ido)
(require 'imenu+)
(require 'auto-complete)
(ido-mode t)
(icicle-mode)
;; (yas-global-mode) : interferes with auto-complete in emacs-lisp mode.

(setq projectile-completion-system 'grizzl)

(defun projectile-dired-project-root ()
  "Dired root of current project.  Can be set as value of
projectile-switch-project-action to dired root of project when switching.
Note: projectile-find-dir (with grizzl) does not do this, but it
asks to select a *subdir* of selected project to dired."
  (interactive)
  (dired (projectile-project-root)))

(setq projectile-switch-project-action 'projectile-commander)

(defun projectile-post-project ()
  "Which project am I actually in?"
  (interactive)
  (message (projectile-project-root)))

(defun projectile-add-project ()
  "Add folder of current buffer's file to list of projectile projects"
  (interactive)
  (if (buffer-file-name (current-buffer))
      (projectile-add-known-project
       (file-name-directory (buffer-file-name (current-buffer))))))

(global-set-key (kbd "H-p c") 'projectile-commander)
(global-set-key (kbd "H-p h") 'helm-projectile)
(global-set-key (kbd "H-p s") 'projectile-switch-project)
(global-set-key (kbd "H-p d") 'projectile-find-dir)
(global-set-key (kbd "H-p f") 'projectile-find-file)
(global-set-key (kbd "H-p w") 'projectile-post-project)
(global-set-key (kbd "H-p D") 'projectile-dired-project-root)
(global-set-key (kbd "H-p +") 'projectile-add-project)
(global-set-key (kbd "H-p -") 'projectile-remove-known-project)
(global-set-key (kbd "H-p g") 'projectile-grep) ;; could not work it

;; must call these to initialize  helm-source-find-files

(require 'helm-files) ;; (not auto-loaded by system!)
(require 'helm-projectile)

;; Don't bicker if not in a project:
(setq projectile-require-project-root)

;; Add add-to-projectile action after helm-find-files.
(let ((find-files-action (assoc 'action helm-source-find-files)))
  (setcdr find-files-action
          (cons
           (cadr find-files-action)
           (cons '("Add to projectile" . helm-add-to-projectile)
                 (cddr find-files-action)))))

;; Use helm-find-files actions in helm-projectile
(let ((projectile-files-action (assoc 'action helm-source-projectile-files-list)))
    (setcdr projectile-files-action (cdr (assoc 'action helm-source-find-files))))

(defun helm-add-to-projectile (path)
  "Add directory of file to projectile projects.
Used as helm action in helm-source-find-files"
  (projectile-add-known-project (file-name-directory path)))

(global-set-key (kbd "H-h p") 'helm-projectile)
(global-set-key (kbd "H-h g") 'helm-do-grep)
(global-set-key (kbd "H-h f") 'helm-find-files)
(global-set-key (kbd "H-h r") 'helm-resume)
(global-set-key (kbd "H-h b") 'helm-bookmarks)
(global-set-key (kbd "H-h l") 'helm-buffers-list)
(global-set-key (kbd "H-M-h") 'helm-M-x)
(global-set-key (kbd "H-h w") 'helm-world-time)

(setq display-time-world-list
      '(("America/Los_Angeles" "Santa Barbara")
        ("America/New_York" "New York")
        ("Europe/London" "London")
        ("Europe/Lisbon" "Lisboa")
        ("Europe/Madrid" "Barcelona")
        ("Europe/Paris" "Paris")
        ("Europe/Berlin" "Berlin")
        ("Europe/Rome" "Rome")
        ;; ("Europe/Albania" "Gjirokastra") ;; what city to name here?
        ("Europe/Athens" "Athens")
        ("Asia/Calcutta" "Kolkatta")
        ("Asia/Jakarta" "Jakarta")
        ("Asia/Shanghai" "Shanghai")
        ("Asia/Tokyo" "Tokyo")))

(require 'switch-window)
(global-set-key (kbd "C-x o") 'switch-window)

(require 'lacarte)
(global-set-key [?\e ?\M-x] 'lacarte-execute-command)

(global-set-key (kbd "<C-s-up>") 'windmove-up)
(global-set-key (kbd "<C-s-down>") 'windmove-down)
(global-set-key (kbd "<C-s-right>") 'windmove-right)
(global-set-key (kbd "<C-s-left>") 'windmove-left)

(require 'buffer-move)
(global-set-key (kbd "<S-prior>") 'buf-move-up)
(global-set-key (kbd "<S-next>") 'buf-move-down)
(global-set-key (kbd "<S-end>") 'buf-move-right)
(global-set-key (kbd "<S-home>") 'buf-move-left)

(global-set-key (kbd "<s-home>") 'previous-buffer)
(global-set-key (kbd "<s-end>") 'next-buffer)

;; Smex: Autocomplete meta-x command
(global-set-key [(meta x)]
                (lambda ()
                  (interactive)
                  (or (boundp 'smex-cache)
                      (smex-initialize))
                  (global-set-key [(meta x)] 'smex)
                  (smex)))

(global-set-key [(shift meta x)]
                (lambda ()
                  (interactive)
                  (or (boundp 'smex-cache)
                      (smex-initialize))
                  (global-set-key [(shift meta x)] 'smex-major-mode-commands)
                  (smex-major-mode-commands)))

(require 'multiple-cursors)
(global-set-key (kbd "C-c m") 'helm-mini)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-M->") 'mc/mark-more-like-this-extended)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
;; (global-set-key (kbd "C->") 'mc/mark-next-symbol-like-this)
;; (global-set-key (kbd "C->") 'mc/mark-next-word-like-this)

(defun turn-off-whitespace-mode () (whitespace-mode -1))
(defun turn-on-whitespace-mode () (whitespace-mode 1))

(require 'key-chord)
(key-chord-mode 1)

(defun paren-sexp ()
  (interactive)
  (insert "(")
  (forward-sexp)
  (insert ")"))

(defun code-quote-sexp ()
  (interactive)
  (insert "=")
  (forward-sexp)
  (insert "="))

(key-chord-define-global "jk"     'ace-jump-char-mode)
(key-chord-define-global "jj"     'ace-jump-word-mode)
(key-chord-define-global "jl"     'ace-jump-line-mode)

(key-chord-define-global "hj"     'undo)

(key-chord-define-global "{}"     "{   }\C-b\C-b\C-b")
(key-chord-define-global "()"     'paren-sexp)
(key-chord-define-global "(_"     "()\C-b")
(key-chord-define-global "=="     'code-quote-sexp)

;; Exit auto-complete, keeping the current selection,
;; while avoiding possible side-effects of TAB or RETURN.
(key-chord-define-global "KK"      "\C-f\C-b")
;; Trick for triggering yasnippet when using in tandem with auto-complete:
;; Move forward once to get out of auto-complete, then backward once to
;; end of keyword, and enter tab to trigger yasnippet.
(key-chord-define-global "KL"      "\C-f\C-b\C-i")

;; Jump to any symbol in buffer using ido-imenu
(key-chord-define-global "KJ"      'ido-imenu)

(require 'dired+)
(require 'dirtree)
(global-set-key (kbd "H-d d") 'dirtree-show)
(require 'sr-speedbar)
(global-set-key (kbd "H-d H-s") 'sr-speedbar-toggle)

(define-key dired-mode-map (kbd "<SPC>")
  (lambda () (interactive)
    (let ((lawlist-filename (dired-get-file-for-visit)))
      (if (equal (file-name-extension lawlist-filename) "pdf")
          (start-process "default-pdf-app" nil "open" lawlist-filename)))))

(load "dired-x")

(eval-after-load "dired"
'(progn
   (define-key dired-mode-map "F" 'my-dired-find-file)
   (defun my-dired-find-file (&optional arg)
     "Open each of the marked files, or the file under the point, or when prefix arg, the next N files "
     (interactive "P")
     (let* ((fn-list (dired-get-marked-files nil arg)))
       (mapc 'find-file fn-list)))))

(defun open-finder ()
  (interactive)
  ;; IZ Dec 25, 2013 (3:25 PM): Making this work in dired:
  (if (equal major-mode 'dired-mode)
      (open-finder-dired)
      (let ((path
             (if (equal major-mode 'dired-mode)
                 (file-truename (dired-file-name-at-point))
               (buffer-file-name)))
            dir file)
        (when path
          (setq dir (file-name-directory path))
          (setq file (file-name-nondirectory path))
          (open-finder-1 dir file)))))

(defun open-finder-1 (dir file)
  (message "open-finder-1 dir: %s\nfile: %s" dir file)
  (let ((script
         (if file
             (concat
              "tell application \"Finder\"\n"
              " set frontmost to true\n"
              " make new Finder window to (POSIX file \"" dir "\")\n"
              " select file \"" file "\"\n"
              "end tell\n")
           (concat
            "tell application \"Finder\"\n"
            " set frontmost to true\n"
            " make new Finder window to {path to desktop folder}\n"
            "end tell\n"))))
    (start-process "osascript-getinfo" nil "osascript" "-e" script)))

;;; Directory of SuperCollider support, for quarks, plugins, help etc.
(defvar sc_userAppSupportDir
  (expand-file-name "~/Library/Application Support/SuperCollider"))

;; Make path of sclang executable available to emacs shell load path
(add-to-list
 'exec-path
 "/Applications/SuperCollider/SuperCollider.app/Contents/Resources/")

;; Global keyboard shortcut for starting sclang
(global-set-key (kbd "C-c M-s") 'sclang-start)
;; overrides alt-meta switch command
(global-set-key (kbd "C-c W") 'sclang-switch-to-workspace)

;; Disable switching to default SuperCollider Workspace when recompiling SClang
(setq sclang-show-workspace-on-startup nil)

;; Save results of sc evaluation in elisp variable for access in emacs
(defvar sclang-return-string  nil
  "The string returned by sclang process after evaluating expressions.")

(defadvice sclang-process-filter (before provide-sclang-eval-results)
  "Pass sc eval return string to elisp by setting sclang-return-string variable."
  (setq sclang-return-string (ad-get-arg 1)))

(ad-activate 'sclang-process-filter)

(require 'sclang)

;; paredit mode breaks re-starting sclang! Therefore, do not use it.
;; Note: Paredit-style bracket movement commands d, u, f, b, n, p work
;; in sclang-mode without loading Paredit.
;; (add-hook 'sclang-mode-hook 'paredit-mode)
(add-hook 'sclang-mode-hook 'rainbow-delimiters-mode)
(add-hook 'sclang-mode-hook 'hl-sexp-mode)
(add-hook 'sclang-mode-hook 'sclang-ac-mode)
;; Following possibly breaks auto-complete in my setup:  Disabled for now.
;; (add-hook 'sclang-mode-hook 'sclang-extensions-mode)

;; Global keyboard shortcut for starting sclang
(global-set-key (kbd "C-c M-s") 'sclang-start)
;; Show workspace
(global-set-key (kbd "C-c C-M-w") 'sclang-switch-to-workspace)

;; (add-hook 'emacs-lisp-mode-hook 'hl-sexp-mode)
(add-hook 'emacs-lisp-mode-hook 'hl-sexp-mode)
(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)
(add-hook 'emacs-lisp-mode-hook 'turn-on-whitespace-mode)
(add-hook 'emacs-lisp-mode-hook 'auto-complete-mode)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)

(add-hook 'org-mode-hook 'visual-line-mode)
(add-hook 'org-mode-hook 'turn-off-whitespace-mode)
(add-hook 'org-shiftup-final-hook 'windmove-up)
(add-hook 'org-shiftleft-final-hook 'windmove-left)
(add-hook 'org-shiftdown-final-hook 'windmove-down)
(add-hook 'org-shiftright-final-hook 'windmove-right)

(setq org-startup-indented t) ;; auto-indent text in subtrees
(setq org-hide-leading-stars t) ;; hide leading stars in subtree headings
(setq org-src-fontify-natively t) ;; colorize source-code blocks natively

(global-set-key "\C-ca" 'org-agenda)

(require 'calfw-org)

(global-set-key "\C-c\M-a" 'cfw:open-org-calendar)
(global-set-key "\C-c\C-xm" 'org-mark-ring-goto)

(defun org-set-date (&optional inactive property)
  "Set DATE property with current time.  Active timestamp."
  (interactive "P")
  (org-set-property
   (if property property "DATE")
   (let ((stamp (format-time-string (cdr org-time-stamp-formats) (current-time))))
     (if inactive
         (concat "[" (substring stamp 1 -1) "]")
       stamp))))

;; Note: This keybinding is in analogy to the standard keybinding:
;; C-c . -> org-time-stamp
(eval-after-load 'org
  '(define-key org-mode-map (kbd "C-c C-.") 'org-set-date))

(defun log (expense)
  "Write countdown file for countdown geeklet.
  Ask user number of seconds to plan countdown in future."
  (interactive "P")

  (let* ((topic (completing-read "Enter topic: " '("Mtg" "Expense" "Note")))
        (timer-string
         (concat
          (replace-regexp-in-string " " "_" topic)
          (format-time-string ": %D_%T" (current-time)))))
    (if (< (length topic) 1) (setq topic "Untitled task"))
    (find-file
     "/Users/iani2/Dropbox/000WORKFILES/org/monitoring/stopwatch.txt")
;;    (beginning-of-buffer)
;;    (kill-line)
    (erase-buffer)
    (insert timer-string)
    (save-buffer)
    (message (concat "Now timing: " timer-string))
    (find-file
     "/Users/iani2/Dropbox/000WORKFILES/org/monitoring/log.org")
    (widen)
    (end-of-buffer)
    (if (> (org-outline-level) 1) (outline-up-heading 100 t))
    (org-set-date t "END_TIME")
    (org-set-property
     "TIMER_SPAN"
     (concat
      (replace-regexp-in-string
       ">" "]"
       (replace-regexp-in-string "<" "[" (org-entry-get (point) "START_TIME")))
      "--"
      (org-entry-get (point) "END_TIME")))
    (let* ((seconds
            (-
             (org-float-time
              (apply
               'encode-time
               (org-parse-time-string (org-entry-get (point) "END_TIME"))))
             (org-float-time
              (apply
               'encode-time
               (org-parse-time-string (org-entry-get (point) "START_TIME"))))
             ))
           (hours (floor (/ seconds 3600)))
           (seconds (- seconds (* 3600 hours)))
           (minutes (floor (/ seconds 60))))
      (org-set-property
       "DURATION"
       (replace-regexp-in-string " " "0" (format "%2d:%2d" hours minutes))))
    (end-of-buffer)
    (insert-string "\n* ")
    (insert-string (replace-regexp-in-string "_" " " timer-string))
    ;;      (insert-string "\n")
    (org-set-date nil "START_TIME")
    (org-set-date t) ;; also set DATE property: for blog entries
    (org-id-get-create)
    (when expense
      (org-set-tags-to '("expense"))
      (org-set-property "EXPENSE" nil))
    (org-set-tags-command)
;;    (if narrow-p
    (org-narrow-to-subtree)
    (goto-char (point-max))
    (org-show-subtree)
    (org-show-entry)
    (save-buffer)
;;    )
    ))

(global-set-key (kbd "C-M-l") 'log)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (sh . t)
   (ruby . t)
   (python . t)
   (perl . t)
   ))

(defun org-babel-load-current-file ()
  (interactive)
  (org-babel-load-file (buffer-file-name (current-buffer))))

;; Note: Overriding default key binding to provide consistent pattern:
;; C-c C-v f -> tangle, C-c C-v C-f -> load
(eval-after-load 'org
  '(define-key org-mode-map (kbd "C-c C-v C-f") 'org-babel-load-current-file))

;;; Load latex package
(require 'ox-latex)

;;; Use xelatex instead of pdflatex, for support of multilingual fonts (Greek etc.)
(setq org-latex-pdf-process (list "xelatex -interaction nonstopmode -output-directory %o %f" "xelatex -interaction nonstopmode -output-directory %o %f" "xelatex -interaction nonstopmode -output-directory %o %f"))

;;; Add beamer to available latex classes, for slide-presentaton format
(add-to-list 'org-latex-classes
             '("beamer"
               "\\documentclass\[presentation\]\{beamer\}"
               ("\\section\{%s\}" . "\\section*\{%s\}")
               ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
               ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))

;;; Add memoir class (experimental)
(add-to-list 'org-latex-classes
             '("memoir"
               "\\documentclass[12pt,a4paper,article]{memoir}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(require 'org-crypt)
(org-crypt-use-before-save-magic)
(setq org-tags-exclude-from-inheritance (quote ("crypt")))
;; GPG key to use for encryption
;; Either the Key ID or set to nil to use symmetric encryption.
(setq org-crypt-key nil)

(require 'ox-reveal)

(fset 'org-toggle-drawer
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([67108896 3 16 14 tab 24 24] 0 "%d")) arg)))

(eval-after-load 'org
  '(define-key org-mode-map (kbd "C-c M-d") 'org-toggle-drawer))

(defun org-cycle-current-entry ()
  "toggle visibility of current entry from within the etnry."
  (interactive)
  (save-excursion)
  (outline-back-to-heading)
  (org-cycle))

(eval-after-load 'org
  '(define-key org-mode-map (kbd "C-c C-/") 'org-cycle-current-entry))

(defun org-select-heading ()
  "Go to heading of current node, select heading."
  (interactive)
  (outline-previous-heading)
  (search-forward (plist-get (cadr (org-element-at-point)) :raw-value))
  (set-mark (point))
  (beginning-of-line)
  (search-forward " "))

(eval-after-load 'org
  '(define-key org-mode-map (kbd "C-c C-h") 'org-select-heading))

(require 'org-crypt)
(org-crypt-use-before-save-magic)
(setq org-tags-exclude-from-inheritance (quote ("crypt")))
;; GPG key to use for encryption
;; Either the Key ID or set to nil to use symmetric encryption.
(setq org-crypt-key nil)

(add-hook 'org-mode-hook
          (lambda () (imenu-add-to-menubar "Imenu")))
(setq org-imenu-depth 3)

(defun org-icicle-occur ()
  "In org-mode, show entire buffer contents before running icicle-occur.
 Otherwise icicle-occur will not place cursor at found location,
 if the location is hidden."
  (interactive)
  (show-all)
  (icicle-occur (point-min) (point-max)))

(eval-after-load 'org
  '(define-key org-mode-map (kbd "C-c C-'") 'org-icicle-occur))
(eval-after-load 'org
  '(define-key org-mode-map (kbd "C-c i o") 'org-icicle-occur))
(defun org-icicle-imenu ()
  "In org-mode, show entire buffer contents before running icicle-imenu.
 Otherwise icicle-occur will not place cursor at found location,
 if the location is hidden."
  (interactive)
  (show-all)
  (icicle-imenu (point-min) (point-max) t))

(eval-after-load 'org
  '(define-key org-mode-map (kbd "C-c C-=") 'org-icicle-imenu))
(eval-after-load 'org
  '(define-key org-mode-map (kbd "C-c i m") 'org-icicle-imenu))

;; install alternative for org-mode C-c = org-table-eval-formula
;; which is stubbornly overwritten by icy-mode.
(eval-after-load 'org
  '(define-key org-mode-map (kbd "C-c C-x =") 'org-table-eval-formula))

;; this is a redundant second try for the above, to be removed after testing:
(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c M-=") 'org-table-eval-formula)))

;;; ???? Adapt org-mode to icicle menus when refiling (C-c C-w)
;;; Still problems. Cannot use standard org refiling with icicles activated!
(setq org-outline-path-complete-in-steps nil)

(add-hook 'org-mode-hook (lambda () (prelude-mode -1)))

(defun org-refile-icy (as-subtree &optional do-copy-p)
  "Alternative to org-refile using icicles.
Refile or copy current section, to a location in the file selected with icicles.
Without prefix argument: Place the copied/cut section it *after* the selected section.
With prefix argument: Make the copied/cut section *a subtree* of the selected section.

Note 1: If quit with C-g, this function will have removed the section that
is to be refiled.  To get it back, one has to undo, or paste.

Note 2: Reason for this function is that icicles seems to break org-modes headline
buffer display, so onehas to use icicles for all headline navigation if it is loaded."
  (interactive "P")
  (outline-back-to-heading)
  (if do-copy-p (org-copy-subtree) (org-cut-subtree))
  (show-all)
  (icicle-imenu (point-min) (point-max) t)
  (outline-next-heading)
  (unless (eq (current-column) 0) (insert "\n"))
  (org-paste-subtree)
  (if as-subtree (org-demote-subtree)))

(defun org-copy-icy (as-subtree)
  "Copy section to another location in file, selecting the location with icicles.
See org-refile-icy."
  (interactive "P")
  (org-refile-icy as-subtree t))

(eval-after-load 'org
  '(define-key org-mode-map (kbd "C-c i r") 'org-refile-icy))
(eval-after-load 'org
  '(define-key org-mode-map (kbd "C-c i c") 'org-copy-icy))

(defun org-from ()
  "Set property 'FROM'."
  (interactive)
  (org-set-property "FROM" (ido-completing-read "From whom? " '("ab" "iz"))))

(defun org-to ()
  "Set property 'TO'."
  (interactive)
  (org-set-property "TO" (ido-completing-read "To whom? " '("ab" "iz"))))

(eval-after-load 'org
  '(define-key org-mode-map (kbd "C-c x f") 'org-from))
(eval-after-load 'org
  '(define-key org-mode-map (kbd "C-c x t") 'org-to))

(defvar fname-parts-1-2 nil)
(defvar fname-part-3 nil)
(defvar fname-root "~/Dropbox/000Workfiles/2014/")
(defvar fname-filename-components
  (concat fname-root  "00000fname-filename-components.org"))
(defun fname-find-file-standardized ()
  (interactive)
  (unless fname-part-3 (fname-load-file-components))
  (setq *grizzl-read-max-results* 40)
  (let* ((root fname-root)
         (index-1 (grizzl-make-index
                   (mapcar 'car fname-parts-1-2)))
         (name-1 (grizzl-completing-read "Part 1: " index-1))
         (index-2 (grizzl-make-index (cdr (assoc name-1 fname-parts-1-2))))
         (name-2 (grizzl-completing-read "Part 2: " index-2))
         (index-3 (grizzl-make-index fname-part-3))
         (name-3 (grizzl-completing-read "Part 3: " index-3))
         (path (concat root name-1 "_" name-2 "_" name-3 "_"))
         (candidates (file-expand-wildcards (concat path "*")))
         extension-index extension final-choice)
    (setq final-choice
          (completing-read "Choose file or enter last component: " candidates))
    (cond ((string-match (concat "^" path) final-choice)
           (setq path final-choice))
      (t
       (setq extension (ido-completing-read
                        "Enter extension:" '("org" "el" "html" "scd" "sc" "ck")))
       (setq path (concat path final-choice
                          (format-time-string "_%Y-%m-%d-%H-%M" (current-time))
                          "." extension))))
    (find-file path)
    (set-visited-file-name
     (replace-regexp-in-string
      "_[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}-[0-9]\\{2\\}-[0-9]\\{2\\}"
      (format-time-string "_%Y-%m-%d-%H-%M" (current-time)) path))))

(defun fname-load-file-components ()
  (interactive)
  (let ((buffer (find-file fname-filename-components)))
    (set-buffer buffer)
    (setq fname-parts-1-2 nil)
    (setq fname-part-3 nil)
    (save-excursion
      (let ((levels1_2-section (car (org-map-entries '(point) "LEVELS1_2")))
            (level3-section (car (org-map-entries '(point) "LEVEL3")))
            level3 level)
        (setq fname-parts-1-2 '(1))
        (goto-char levels1_2-section)
        (save-restriction
          (org-narrow-to-subtree)
          (org-map-entries
           (lambda ()
             (let* ((section (cadr (org-element-at-point)))
                    (level (plist-get section :level))
                    (heading (plist-get section :raw-value)))
              (setq level level)
              (cond
               ((equal 2 level)
                (setq last (list heading))
                (setcdr (last fname-parts-1-2) (list last)))
               ((equal 3 level)
                (setcdr (last last) (list heading)))))))
          (setq fname-parts-1-2 (cdr fname-parts-1-2)))
        (goto-char level3-section)
        (save-restriction
          (setq fname-part-3 '(1))
          (org-narrow-to-subtree)
          (org-map-entries
           (lambda ()
             (setq level (plist-get (cadr (org-element-at-point)) :level))
             (cond
              ((equal 2 level)
               (setq last (org-get-heading))
               (setcdr (last fname-part-3) (list last))))))
          (setq fname-part-3 (cdr fname-part-3)))))
    (kill-buffer buffer))
  (message "file component list updated"))

(defun fname-load-file-components-from-buffer (buffer)
  (set-buffer buffer)
  (goto-char (point-min))
  (let ((levels1_2-section (car (org-map-entries '(point) "LEVELS1_2")))
        (level3-section (car (org-map-entries '(point) "LEVEL3")))
        level3 level)
    (setq fname-parts-1-2 '(1))
    (goto-char levels1_2-section)
    (save-restriction
      (org-narrow-to-subtree)
      (org-map-entries
       (lambda ()
         (let* ((section (cadr (org-element-at-point)))
                (level (plist-get section :level))
                (heading (plist-get section :raw-value)))
           (setq level level)
           (cond
            ((equal 2 level)
             (setq last (list heading))
             (setcdr (last fname-parts-1-2) (list last)))
            ((equal 3 level)
             (setcdr (last last) (list heading)))))))
      (setq fname-parts-1-2 (cdr fname-parts-1-2)))
    (goto-char level3-section)
    (save-restriction
      (setq fname-part-3 '(1))
      (org-narrow-to-subtree)
      (org-map-entries
       (lambda ()
        (let* ((section (cadr (org-element-at-point)))
               (level (plist-get section :level))
               (heading (plist-get section :raw-value)))
          (cond
           ((equal 2 level)
            (setq last heading)
            (setcdr (last fname-part-3) (list last)))))))
      (setq fname-part-3 (cdr fname-part-3)))))

(defun fname-edit-file-components ()
  (interactive)
  (find-file fname-filename-components)
  (add-to-list 'write-contents-functions
               (lambda ()
                 (fname-load-file-components-from-buffer (current-buffer))
                 (message "Updated file name components from: %s" (current-buffer))
                 (set-buffer-modified-p nil))))

  (defun fname-menu ()
  (interactive)
  (let ((action (ido-completing-read
                 "Choose action: "
                 '("fname-edit-file-components"
                  "fname-load-file-components"
                  "fname-find-file-standardized"))))
    (funcall (intern action))))

(global-set-key (kbd "H-f f") 'fname-find-file-standardized)
(global-set-key (kbd "H-f m") 'fname-menu)
(global-set-key (kbd "H-f e") 'fname-edit-file-components)
(global-set-key (kbd "H-f l") 'fname-load-file-components)

(setq magit-repo-dirs
      '(
        "~/Dropbox/000WORKFILES/org"
        "~/Documents/Dev"
        "~/.emacs.d/personal"
))

(fset 'org-toggle-drawer
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([67108896 3 16 14 tab 24 24] 0 "%d")) arg)))

(eval-after-load 'org
  '(define-key org-mode-map (kbd "C-c M-d") 'org-toggle-drawer))
