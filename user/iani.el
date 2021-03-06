
(set-fontset-font "fontset-default"
                  'japanese-jisx0208
                  '("Hiragino Mincho Pro" . "iso10646-1"))
(set-fontset-font "fontset-default"
                  'greek
 ;; Note: iso10646-1 = Universal Character set (UCS)
 ;; It is compatible to Unicode, in its basic range
                  '("Menlo" . "iso10646-1"))

;; (maximize-frame) ;; maximize frame on startup
(defun toggle-fullscreen ()
  "Toggle full screen"
  (interactive)
  (set-frame-parameter
   nil 'fullscreen
   (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))
(tool-bar-mode -1)

(global-set-key (kbd "M-B") 'backward-sentence)
(global-set-key (kbd "M-F") 'forward-sentence)
(global-set-key (kbd "M-[") 'backward-sentence)
(global-set-key (kbd "M-]") 'forward-sentence)

(defun insert-timestamp (&optional type)
  "Insert a timestamp."
  (interactive "P")
  (insert (format-time-string "%a, %b %e %Y, %R %Z")))

(global-set-key (kbd "C-c C-x t") 'insert-timestamp)

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

(require 'switch-window)
(global-set-key (kbd "C-x o") 'switch-window)

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

(require 'ido)
(require 'imenu+)
(require 'auto-complete)
(ido-mode t)
;; (icicle-mode) ;; broken on Wed, Mar  5 2014, after loading one-key, hexrgb
;; could not fix
;; guide-key causes errating post tempo at SC post buf. Therefore avoid!
;; (require 'guide-key)
;; (setq guide-key/guide-key-sequence '("C-x r" "C-x 4" "H-h" "H-m" "H-p" "H-d" "C-c"))
;;  (guide-key-mode 1)  ; Enable guide-key-mode
;; (yas-global-mode) ; interferes with auto-complete in elisp mode.

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
(global-set-key (kbd "H-p g") 'projectile-grep)

;; must call these to initialize  helm-source-find-files

(require 'helm-files) ;; (not auto-loaded by system!)
(require 'helm-projectile)
(require 'helm-swoop) ;; must be put into packages
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
(global-set-key (kbd "H-h s") 'helm-swoop)

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

;; (message "%s" display-time-world-list)

(eval-after-load "icicles-opt.el"
    (add-hook
     'icicle-mode-hook
     (lambda ()
       (setq my-icicle-top-level-key-bindings
             (mapcar (lambda (lst)
                       (unless (string= "icicle-occur" (nth 1 lst)) lst))
                     icicle-top-level-key-bindings))
       (setq icicle-top-level-key-bindings my-icicle-top-level-key-bindings) )))

;;  (icy-mode)

(require 'lacarte)
(global-set-key [?\e ?\M-x] 'lacarte-execute-command)

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
(key-chord-define-global "-="     'code-quote-sexp)
;; to add: quote, single quote around word/sexp
;; Exit auto-complete, keeping the current selection,
;; while avoiding possible side-effects of TAB or RETURN.
(key-chord-define-global "KK"      "\C-f\C-b")
;; Trick for triggering yasnippet when using in tandem with auto-complete:
;; Move forward once to get out of auto-complete, then backward once to
;; end of keyword, and enter tab to trigger yasnippet.
(key-chord-define-global "KL"      "\C-f\C-b\C-i")

;; Jump to any symbol in buffer using ido-imenu
(key-chord-define-global "KJ"      'ido-imenu)

(require 'hl-sexp)
;; (require 'highlight-sexps)
;; Include color customization for dark color theme here.
(custom-set-variables
 '(hl-sexp-background-colors (quote ("gray0"  "#0f003f"))))

(require 'dired+)
(require 'dirtree)
(global-set-key (kbd "H-d d") 'dirtree-show)
(require 'sr-speedbar)
(speedbar-add-supported-extension ".sc")
(speedbar-add-supported-extension ".scd")
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
;; sclang-ac-mode is included in sclang-extensions-mode:
;; (add-hook 'sclang-mode-hook 'sclang-ac-mode)
;; ac mode constantly tries to run code.
;; that can lead to loops that hang, for example constantly creating a view.
;; (add-hook 'sclang-mode-hook 'sclang-extensions-mode)

;; Global keyboard shortcut for starting sclang
(global-set-key (kbd "C-c M-s") 'sclang-start)
;; Show workspace
(global-set-key (kbd "C-c C-M-w") 'sclang-switch-to-workspace)

(add-hook 'emacs-lisp-mode-hook 'hl-sexp-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(global-set-key (kbd "H-l h") 'hs-hide-level)
(global-set-key (kbd "H-l s") 'hs-show-all)
(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
(require 'paredit)
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
;; following broken on Wed, Mar 19 2014, 07:14 GMT:
;;  (setq org-src-fontify-natively t) ;; colorize source-code blocks natively

(global-set-key "\C-ca" 'org-agenda)

(defvar org-agenda-list-save-path
  "~/.emacs.d/savefile/org-agenda-list.el"
"Path to save the list of files belonging to the agenda.")

(defun org-agenda-save-file-list ()
  "Save list of desktops from file in org-agenda-list-save-path"
  (interactive)
  (save-excursion
    (let ((buf (find-file-noselect org-agenda-list-save-path)))
      (set-buffer buf)
      (erase-buffer)
      (print (list 'quote org-agenda-files) buf)
      (save-buffer)
      (kill-buffer)
      (message "org-agenda file list saved to: %s" org-agenda-list-save-path))))

(defun org-agenda-load-file-list ()
  "Load list of desktops from file in org-agenda-list-save-path"
  (interactive)
  (save-excursion
    (let ((buf (find-file-noselect org-agenda-list-save-path)))
      (set-buffer buf)
      (setq org-agenda-files (eval (read (buffer-string))))
      (kill-buffer)
      (message "org-agenda file list loaded from: %s" org-agenda-list-save-path))))

(defun org-agenda-add-this-file-to-agenda ()
  "Add the file from the current buffer to org-agenda-files list."
  (interactive)
  (let (path)
    ;; (org-agenda-file-to-front) ;; adds path relative to user home dir
    ;; (message "Added current buffer to agenda files.")
    (let ((path (buffer-file-name (current-buffer))))
      (cond (path
        (add-to-list 'org-agenda-files path)
        (org-agenda-save-file-list)
        (message "Added file '%s' to agenda file list"
                 (file-name-base path)))
            (t (message "Cannot add buffer to file list. Save buffer first."))))))

(defun org-agenda-remove-this-file-from-agenda (&optional select-from-list)
  "Remove a file from org-agenda-files list.
If called without prefix argument, remove the file of the current buffer.
If called with prefix argument, then select a file from org-agenda-files list."
  (interactive "P")
  (let (path)
   (if select-from-list
       (let  ((menu (grizzl-make-index org-agenda-files)))
         (setq path (grizzl-completing-read "Choose an agenda file: " menu)))
     (setq path (buffer-file-name (current-buffer))))
   (setq org-agenda-files
         (remove (buffer-file-name (current-buffer)) org-agenda-files)))
  (org-agenda-save-file-list)
  (message "Removed file '%s' from agenda file list"
           (file-name-base (buffer-file-name (current-buffer)))))

(defun org-agenda-open-file ()
  "Open a file from the current agenda file list."
  (interactive)
  (let* ((menu (grizzl-make-index org-agenda-files))
        (answer (grizzl-completing-read "Choose an agenda file: " menu)))
    (find-file answer)))

(defun org-agenda-list-files ()
  "List the paths that are currently in org-agenda-files"
  (interactive)
  (let  ((menu (grizzl-make-index org-agenda-files)))
    (grizzl-completing-read "These are currently the files in list org-agenda-files. " menu)))

(defun org-agenda-list-menu ()
 "Present menu with commands for loading, saving, adding and removing
files to org-agenda-files."
 (interactive)
 (let* ((menu (grizzl-make-index
               '("org-agenda-save-file-list"
                 "org-agenda-load-file-list"
                 "org-agenda-list-files"
                 "org-agenda-open-file"
                 "org-agenda-add-this-file-to-agenda"
                 "org-agenda-remove-this-file-from-agenda")))
        (command (grizzl-completing-read "Choose a command: " menu)))
   (call-interactively (intern command))))

(global-set-key (kbd "H-a H-a") 'org-agenda-list-menu)

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
  '(progn
     (define-key org-mode-map (kbd "C-c C-.") 'org-set-date)
     ;; Prelude defines C-c d as duplicate line
     ;; But we disable prelude in org-mode because of other, more serious conflicts,
     ;; So we keep this alternative key binding:
     (define-key org-mode-map (kbd "C-c d") 'org-set-date)))

(defun org-set-due-property ()
  (interactive)
  (org-set-property
   "DUE"
   (format-time-string (cdr org-time-stamp-formats) (org-read-date t t))))

(eval-after-load 'org
  '(define-key org-mode-map (kbd "C-c M-.") 'org-set-due-property))

(defun log (expense)
  "Simple way to capture notes/activities with some extra features:
- Set task start time
- Set completion time of previous task.
- Calculate duration of previous task
- Write task to stopwatch.txt file for use by geeklet to display task timer
- If called with prefix argument, prompt for expense value and set expense task.

TODO: Store timestamp of last task in separate file, so as to be able to retrieve it
even if the text of the previous entry is corrupt. "
  (interactive "P")

  (let* ((topic (read-from-minibuffer "Enter topic: "))
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
    (message "testing expense arg: %s %s" expense (equal expense '(4)))
    (cond ((equal expense '(4))
           (org-set-tags-to '("expense"))
           ;; this causes orgmode to prompt of the value of EXPENSE!
           (org-set-property "EXPENSE" nil)   )
          ((equal expense '(16))
           (org-set-tags-to '("email"))
           )
          )
    (org-set-tags-command)
    (org-narrow-to-subtree)
    (goto-char (point-max))
    (org-show-subtree)
    (org-show-entry)
    (save-buffer)))

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

(eval-after-load 'org
  '(define-key org-mode-map (kbd "H-W") 'widen))

(fset 'org-toggle-drawer
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([67108896 3 16 14 tab 24 24] 0 "%d")) arg)))

(eval-after-load 'org
  '(define-key org-mode-map (kbd "C-c M-d") 'org-toggle-drawer))

(defun org-cycle-current-entry ()
  "toggle visibility of current entry from within the entry."
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
