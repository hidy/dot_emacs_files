;;  -*- emacs-lisp -*- last modified : 2012-03-28-23:52:39 available 1773620
;; $Id: dot.emacs.el 321 2011-02-22 20:11:10Z hidemi $

;; I put this file in ~/lib/emacs/ and then byte-compile it.
;; The *.elc file is loaded from the following .emacs.el:
;;
;; ;; load all *.elc files...
;; (mapcar (lambda (x) (load-file x)) (directory-files "~/lib/emacs" t "\\.elc$"))

;; language environment
;; Mac   : Japanese (pre-configured by Carbon Emacs Package)
;; Linux : I am happy enough in English environment

;; first require cl library
(eval-when-compile (require 'cl))

;; version difference
(let ((v23 (string-match "^23\." emacs-version))
      (v22 (string-match "^22\." emacs-version)))
  (cond (v23
         (progn
           ))
        (v22
         (progn
           ;; Old emacs lacks apply-partially and mouse-event-p
           (defun apply-partially (fun &rest args)
             "Return a function that is a partial application of FUN to ARGS.
ARGS is a list of the first N arguments to pass to FUN.
The result is a new function which does the same as FUN, except that
the first N arguments are fixed at the values with which this function
was called."
             (lexical-let ((fun fun) (args1 args))
               (lambda (&rest args2) (apply fun (append args1 args2)))))

             (defun mouse-event-p (object)
               "Return non-nil if OBJECT is a mouse click event."
               (memq (event-basic-type object) '(mouse-1 mouse-2 mouse-3 mouse-movement)))
             ))))

;; convenience macro, just short your type.
(defmacro add-to-list-local (lis path)
  `(add-to-list ,lis (expand-file-name (concat "~/.emacs.d/" ,path))))

(defmacro add-lo-emacsd-to-loadpath (path)
  `(add-to-list 'load-path (expand-file-name (concat "~/.emacs.d/" ,path))))

;; another version variables
(when (<= emacs-major-version 23))

;; (set-language-environment 'Japanese)
;; (prefer-coding-system 'utf-8)

;; basic setup
(setq inhibit-startup-message t)        ; don't show the startup message
(setq kill-whole-line t)                ; C-k deletes the end of line
(column-number-mode 1)

;; mac setup
;; use alt as esc setup
(setq mac-command-key-is-meta nil)
(setq mac-optin-modifier 'meta)

;; enable mac shortcut
;(require 'mac-key-mode)
;(mac-key-mode 1)

;;; path stuff
;; add sub-directorys to load-path
(defun add-subdirs-to-load-path (dir)
  (flet ((is-last-slash-p (dir)
          (let ((last-char (substring dir -1)))
            (cond ((string= last-char "/") t)
                  (t nil)))))
    (let ((default-directory (if (is-last-slash-p dir)
                                 dir
                                 (concat dir "/"))))
      (normal-top-level-add-subdirs-to-load-path))))

(dolist (dir (mapcar #'expand-file-name '("~/.emacs.d" "~/.emacs.d/lisp")))
  (push dir load-path))

(add-subdirs-to-load-path "~/.emacs.d/lisp")

;; mac kotoeri ctl-@
(mac-add-ignore-shortcut '(ctl ?@))

;; recentf
(require 'recentf)
(setq recentf-auto-cleanup 'never)
(setq recentf-max-saved-items 500)
(setq recentf-max-menu-items 10)
(setq recent-exclude '("^/[^/:]:+:"))
(recentf-mode 1)
(define-key global-map "\C-@" 'recentf-open-files)

;; misc stuff
(setq htmlize-output-type 'font)
(setq imaxima-scale-factor 1.4)
(setq next-line-add-newlines nil)
(setq require-final-newline t)
(auto-compression-mode t)
(setq case-fold-search nil)
(setq case-replace nil)
;(require 'redo)

;; font setting
;; (if (eq window-system 'mac) (require 'carbon-font))
;; (fixed-width-set-fontset "osaka" 12)
;; (setq fixed-width-rescale nil)

;; 有効なフォントセットの確認用ここで出てくるフォントが使える。
;;(insert (prin1-to-string (x-list-fonts "*")))

(add-to-list 'default-frame-alist '(font . "fontset-default"))
;; 上の設定がすでにしてあって書き換えるなら下記のようにする。
;(setcdr (assoc 'font default-frame-alist) "fontset-default")

(set-fontset-font "fontset-default"
                  'japanese-jisx0208
                  '("ヒラギノ角ゴ pro w3*" . "jisx0208.*"))

(set-fontset-font "fontset-default"
                  'katakana-jisx0201
                  '("ヒラギノ角ゴ pro w3*" . "jisx0201.*"))


;; ============== keys ==================
;;(global-set-key "\C-z" 'undo)
(global-set-key "\C-_" 'redo)
(global-set-key "\C-x\C-b" 'electric-buffer-list)
(global-set-key "\C-c\C-i" 'indent-region) ; C-u C-c TAB => (un)indent-region
;;(global-set-key [\C-c\;] 'comment-or-uncomment-region)
(global-set-key "\C-c\;" 'comment-or-uncomment-region)
(global-set-key "\C-ck" (lambda () (interactive) (kill-line 0)))
(global-set-key "\C-cu" 'untabify)
(global-set-key "\C-u" 'backward-kill-sentence)
(global-set-key "\C-cn" 'other-frame)
(keyboard-translate ?\C-h ?\C-?)
(global-set-key "\M-?" 'help-command)

;; indent
(global-set-key "\C-m" 'reindent-then-newline-and-indent)
(global-set-key "\C-j" 'newline)
;; do not use tab for indent
(setq-default indent-tabs-mode nil)

;; filecache
(require 'filecache)
(file-cache-add-directory-list (list "~" "~/my_project"))  ;; enable filecache
(define-key minibuffer-local-completion-map
  "\C-c\C-f" 'file-cache-minibuffer-complete)


;; backup file setting
(setq make-backup-files t)
;; (setq backup-directory-alist
;;           (cons (cons "\\.*$" (expand-file-name "~/.emacs.d/backup"))
;;                         backup-directory-alist))

(setq backup-directory-alist
      (append `((".*" . ,(expand-file-name "~/.emacs.d/backup/"))) backup-directory-alist))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.emacs.d/backup/") t)))

;; auto save
;; (require 'auto-save-buffers)
;; (run-with-idle-timer 0.5 t 'auto-save-buffers)
;; default auto save
(setq auto-save-list-file-prefix nil)   ; don't make ~/.saves-PID-hostname
;;(setq auto-save-default nil)            ; disable auto-saving
(auto-save-mode t)


;; info add own info directory
(setq Info-default-directory-list
      (cons (expand-file-name "/opt/local/share/info/") Info-default-directory-list))
;; (setq Info-default-directory-list
;;       (cons (expand-file-name "/Application/Emacs.app/Contents/Resources/info/") Info-default-directory-list))

;; /opt/localにあるinfoを優先したい場合は下記設定を使う
;; (setq Info-default-directory-list
;;       (append Info-default-directory-list (list (expand-file-name "/opt/local/share/info/"))))


;; (let ((bds (bounds-of-thing-at-point 'pragraph)))
;;   (buffer-substring-no-properties (car bds) (cdr bds)))

;; (buffer-substring-no-properties 1 10)


;; dabbrev-ja
(load "dabbrev-ja")

;; w3m
(load "~/.emacs.d/misc.w3m.el")


;;; Here starts the new format of .emacs
;;; new format is design by sevral sections
;;; each section contains same kind of function.
;;----------------------------------
;; Behavior
;;----------------------------------
;; scroll
;; 一行づつスクロールするように
(setq scroll-conservatively 35
       scroll-margin 0
       scroll-step 1)

;; シェルモードでも一行づつスクロール
(setq comint-scroll-show-maximum-output t)

;;----------------------------------
;; auto-complete
;;----------------------------------
(add-lo-emacsd-to-loadpath "lisp/auto-complete")
(when (require 'auto-complete nil t)
  (global-auto-complete-mode t)
  (define-key ac-complete-mode-map "\C-n" 'ac-next)
  (define-key ac-complete-mode-map "\C-p" 'ac-previous))
(require 'auto-complete-extension)

;;----------------------------------
;; install-elisp
;;----------------------------------
;;auto-install
(eval-after-load "anything"
  '(progn
     (require 'auto-install)
     (setq auto-install-directory "~/.emacs.d/lisp/")
     (auto-install-update-emacswiki-package-name t)
     (auto-install-compatibility-setup)))

;;install-elisp
(require 'install-elisp)
(setq install-elisp-repository-directory "~/.emacs.d/lisp")

;;=======================================================================
;; dired
;;=======================================================================
(load "dired-x")
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
(setq ls-lisp-dirs-first t)

;; add [2009/06/22]
;; do not make buffer when using dired
(defun dired-my-advertised-find-file ()
  (interactive)
  (let ((kill-target (current-buffer))
        (check-file (dired-get-filename)))
    (funcall 'dired-advertised-find-file)
    (if (file-directory-p check-file)
        (kill-buffer kill-target))))

(defun dired-my-up-directory (&optional other-window)
  "Run dired on parent directory of current directory.
Find the parent directory either in this buffer or another buffer.
Creates a buffer if necessary."
  (interactive "P")
  (let* ((dir (dired-current-directory))
         (up (file-name-directory (directory-file-name dir))))
    (or (dired-goto-file (directory-file-name dir))
        ;; Only try dired-goto-subdir if buffer has more than one dir.
        (and (cdr dired-subdir-alist)
             (dired-goto-subdir up))
        (progn
          (if other-window
              (dired-other-window up)
            (progn
              (kill-buffer (current-buffer))
              (dired up))
          (dired-goto-file dir))))))

;; add [2009/07/28]
;;; フォルダを開く時, 新しいバッファを作成しない
;; バッファを作成したい時にはoやC-u ^を利用する
;; (defvar my-dired-before-buffer nil)
;; (defadvice dired-advertised-find-file
;;   (before kill-dired-buffer activate)
;;   (setq my-dired-before-buffer (current-buffer)))

;; (defadvice dired-advertised-find-file
;;   (after kill-dired-buffer-after activate)
;;   (if (eq major-mode 'dired-mode)
;;       (kill-buffer my-dired-before-buffer)))

;; (defadvice dired-up-directory
;;   (before kill-up-dired-buffer activate)
;;   (setq my-dired-before-buffer (current-buffer)))

;; (defadvice dired-up-directory
;;   (after kill-up-dired-buffer-after activate)
;;   (if (eq major-mode 'dired-mode)
;;       (kill-buffer my-dired-before-buffer)))

(define-key dired-mode-map "\C-m" 'dired-my-advertised-find-file)
(define-key dired-mode-map "^" 'dired-my-up-directory)

;; add [2010/01/26]
;; サブディレクトリにもコピーや削除を適応させる
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)

;;
;; tar,lzhなどの内容をdired内で確認
;;
(defun dired-do-tar-zvtf (arg)
  "Only one file line can be processed. If ARG, execute vzxf"
  (interactive "P")
  (let ((files (dired-get-marked-files t current-prefix-arg)))
    (if arg
        (dired-do-shell-command "tar zvxf * &" nil files)
      (dired-do-shell-command "tar zvtf * &" nil files))))

(defun dired-do-lha-v (arg)
  "Only one file line can be processed. If ARG, execute lha x"
  (interactive "P")
  (let ((files (dired-get-marked-files t current-prefix-arg)))
    (if arg
        (dired-do-shell-command "lha x * &" nil files)
      (dired-do-shell-command "lha v * &" nil files))))

(defun dired-do-mandoc (arg)
  "man source is formatted with col -xbf. If ARG, executes without col -xbf."
  (interactive "P")
  (let ((files (dired-get-marked-files t current-prefix-arg)))
    (if arg
        (dired-do-shell-command "groff -Tnippon -mandoc * &" nil files)
      (dired-do-shell-command "groff -Tnippon -mandoc * | col -xbf &" nil files))))

(define-key dired-mode-map "t" 'dired-do-tar-zvtf)
(define-key dired-mode-map "\eT" 'dired-do-lha-v)


;; add [2009/07/28]
;;; s を何回か入力すると，拡張子やサイズによる並び換えもできる
(add-hook 'dired-load-hook
          (lambda ()
            (require 'sorter)))
;;(load "sorter")

;;; ディレクトリを先に表示する
;;(setq ls-lisp-dirs-first t)  ;; this is not working on Carbon emacs

;; add [2009/08/20]
;; this is another way to show directories first
(defun ls-lisp-handle-switches (file-alist switches)
  ;; FILE-ALIST's elements are (FILE . FILE-ATTRIBUTES).
  ;; Return new alist sorted according to SWITCHES which is a list of
  ;; characters.  Default sorting is alphabetically.
  (let (index)
    (setq file-alist
          (sort file-alist
                (cond
                 ((memq ?S switches)    ; sorted on size
                  (function
                   (lambda (x y)
                     ;; 7th file attribute is file size
                     ;; Make largest file come first
                     (if (equal (nth 0 (cdr y))
                                (nth 0 (cdr x)))
                         (< (nth 7 (cdr y))
                            (nth 7 (cdr x)))
                       (nth 0 (cdr x))))))
                 ((memq ?t switches)    ; sorted on time
                  (setq index (ls-lisp-time-index switches))
                  (function
                   (lambda (x y)
                     (if (equal (nth 0 (cdr y))
                                (nth 0 (cdr x)))
                         (ls-lisp-time-lessp (nth index (cdr y))
                                             (nth index (cdr x)))
                       (nth 0 (cdr x))
                       ))))
                 ((memq ?X switches)    ; sorted on ext
                  (function
                   (lambda (x y)
                     (if (equal (nth 0 (cdr y))
                                (nth 0 (cdr x)))
                         (string-lessp (file-name-extension (upcase (car x)))
                                       (file-name-extension (upcase (car y))))
                       (nth 0 (cdr x))))))
                 (t                     ; sorted alphabetically
                  (if ls-lisp-dired-ignore-case
                      (function
                       (lambda (x y)
                         (if (equal (nth 0 (cdr y))
                                    (nth 0 (cdr x)))
                             (string-lessp (upcase (car x))
                                           (upcase (car y)))
                           (nth 0 (cdr x)))))
                    (function
                     (lambda (x y)
                       (if (equal (nth 0 (cdr y))
                                  (nth 0 (cdr x)))
                           (string-lessp (car x)
                                         (car y))
                         (nth 0 (cdr x)))))
                    ))))))

  (if (memq ?r switches)                ; reverse sort order
      (setq file-alist (nreverse file-alist)))
  file-alist)

(require 'master)
(load "dired-master")

;; change color of last-week and this-week
;; changed file
(defface face-file-edited-today
  '((((class color)
      (background dark))
     (:foreground "GreenYellow"))
    (((class color)
      (background light))
     (:foreground "magenta"))
    (t
     ())) nil)
(defface face-file-edited-this-week
  '((((class color)
      (background dark))
     (:foreground "LimeGreen"))
    (((class color)
      (background light))
     (:foreground "violet red"))
    (t
     ())) nil)
(defface face-file-edited-last-week
  '((((class color)
      (background dark))
     (:foreground "saddle brown"))
    (((class color)
      (background light))
     (:foreground "maroon"))
    (t
     ())) nil)

(defvar face-file-edited-today
  'face-file-edited-today)

(defvar face-file-edited-this-week
  'face-file-edited-this-week)

(defvar face-file-edited-last-week
  'face-file-edited-last-week)

(defun my-dired-today-search (arg)
  "Fontlock search function for dired."
  (search-forward-regexp
   (concat "\\(" (format-time-string "%b %e" (current-time))
           "\\|"(format-time-string "%m-%d" (current-time))
           "\\)"
           " [0-9]....") arg t))

(defun my-dired-date (time)
  "Fontlock search function for dired."
  (let ((now (current-time))
        (days (* -1 time))
        dateh datel daysec daysh daysl dir
        (offset 0))
    (setq daysec (* -1.0 days 60 60 24))
    (setq daysh (floor (/ daysec 65536.0)))
    (setq daysl (round (- daysec (* daysh 65536.0))))
    (setq dateh (- (nth 0 now) daysh))
    (setq datel (- (nth 1 now) (* offset 3600) daysl))
    (if (< datel 0)
        (progn
          (setq datel (+ datel 65536))
          (setq dateh (- dateh 1))))
    ;;(floor (/ offset 24))))))
    (if (< dateh 0)
        (setq dateh 0))
    ;;(insert (concat (int-to-string dateh) ":"))
    (list dateh datel)))

(defun my-dired-this-week-search (arg)
  "Fontlock search function for dired."
  (let ((youbi (string-to-int (format-time-string "%w" (current-time))))
        this-week-start this-week-end day ;;regexp
        (flg nil))
    (setq youbi (+ youbi 1))
    (setq regexp (concat "\\("))
    (while (not (= youbi 0))
      (setq regexp (concat regexp (if flg "\\|") (format-time-string "%b %e" (my-dired-date youbi))
                           "\\|" (format-time-string "%m-%d" (my-dired-date youbi))))
      ;;(insert (concat (int-to-string youbi) "\n"))
      (setq flg t)
      (setq youbi (- youbi 1))))
  (setq regexp (concat regexp "\\)"))
  (search-forward-regexp
   (concat regexp " [0-9]....") arg t))

(defun my-dired-last-week-search (arg)
  "Fontlock search function for dired."
  (let ((youbi
         (string-to-int
          (format-time-string "%w" (current-time))))
        this-week-start this-week-end day ;;regexp
        lyoubi
        (flg nil))
    (setq youbi (+ youbi 0))
    (setq lyoubi (+ youbi 7))
    (setq regexp
          (concat "\\("))
    (while (not (= lyoubi youbi))
      (setq regexp
            (concat
             regexp
             (if flg
                 "\\|")
             (format-time-string
              "%b %e"
              (my-dired-date lyoubi))
             "\\|"
             (format-time-string
              "%m-%d"
              (my-dired-date lyoubi))
             ))
      ;;(insert (concat (int-to-string youbi) "\n"))
      (setq flg t)
      (setq lyoubi (- lyoubi 1))))
  (setq regexp
        (concat regexp "\\)"))
  (search-forward-regexp
   (concat regexp " [0-9]....") arg t))

(font-lock-add-keywords
 major-mode
 (list
  '(my-dired-today-search . face-file-edited-today)
  '(my-dired-this-week-search . face-file-edited-this-week)
  '(my-dired-last-week-search . face-file-edited-last-week)))

;;====================================
;;; extended diff
;;====================================
(defun diff-with-original (ediff)
  "Examin diff of current buffer with original file.
        If with prefix, do interactive merge using `ediff-with-original'. "
  (interactive "P")
  (if ediff
      (ediff-with-original)
    ;; simple diff view with diff-mode
    (require 'ediff)
    (let ((diff-buf (get-buffer-create (format "*diff %s*" (buffer-file-name))))
          (ediff-diff-options "-u") ;; is it your favourite?
          (tmpfile (ediff-make-temp-file (current-buffer))))
      (save-excursion
        (set-buffer diff-buf)
        (setq buffer-read-only nil)
        (buffer-disable-undo)
        (erase-buffer))
      (ediff-make-diff2-buffer diff-buf
                               (buffer-file-name)
                               tmpfile)
      (delete-file tmpfile)
      (set-buffer diff-buf)
      (if (< (buffer-size) 1)
          (message "No differences with original file.")
        (condition-case nil
            (progn
              (require 'diff-mode)
              (diff-mode))
          (error))
        (goto-char 1)
        (pop-to-buffer diff-buf)))))

(defun ediff-with-original ()
  (interactive)
  ;; interactive merge using ediff
  (let ((file buffer-file-name)
        (buf (current-buffer))
        (orig-buf (get-buffer-create (concat "*orig " buffer-file-name "*"))))
    (set-buffer orig-buf)
    (setq buffer-read-only nil)
    (buffer-disable-undo)
    (erase-buffer)
    (insert-file file)
    (setq buffer-read-only t)
    (set-buffer-modified-p nil)
    (ediff-buffers orig-buf buf)))

;;====================================
;;; 折り返し表示ON/OFF
;;====================================
(defun toggle-truncate-lines ()
  "折り返し表示をトグル動作します."
  (interactive)
  (if truncate-lines
      (progn
        (setq truncate-lines nil)
        (setq truncate-partial-width-windows nil))
    (progn
      (setq truncate-lines t)
      (setq truncate-partial-width-windows t)))
  (recenter))

; 折り返し表示ON/OFF
(global-set-key "\C-cl" 'toggle-truncate-lines)

;=======================================================================
; Language
;=======================================================================
;; fortran
(add-hook 'fortran-mode-hook
          (lambda ()
            (setq fortran-comment-region "c")  ; comment character
            (fortran-auto-fill-mode 1)         ; wrap lines in 72 columns
            ))
(add-hook 'f90-mode-hook
          (lambda () (setq f90-comment-region "!") ))

;; ac-mode
;; ref. http://www.taiyaki.org/elisp/ac-mode/
(when (require 'ac-mode "ac-mode" t)
  (add-hook 'sh-mode-hook 'ac-mode-on)
  (add-hook 'makefile-mode-hook 'ac-mode-on)
  (add-hook 'cperl-mode-hook 'ac-mode-on)
  )

;; cperl-mode
(when (locate-library "cperl-mode")
  (add-to-list 'auto-mode-alist '("\\.pl\\'" . cperl-mode))
  (add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
  (setq cperl-indent-level 4)
  (setq imenu-max-items 32)
  (add-hook 'cperl-mode-hook 'imenu-add-menubar-index)
  )

;; smart-compile
;; ref. http://homepage.mac.com/zenitani/elisp-j.html#smart-compile
(when (require 'smart-compile "smart-compile" t)
  (global-set-key "\C-c\C-c" 'smart-compile)
  (add-hook 'c-mode-common-hook
            (lambda ()
              (local-set-key "\C-c\C-c" 'smart-compile)))
  (add-hook 'sh-mode-hook
            (lambda ()
              (local-set-key "\C-c\C-c" 'smart-compile)))
  )

;; time-stamp
;; update the modified date after "last updated : "
;; ref. http://homepage.mac.com/zenitani/elisp-j.html#time-stamp
(require 'time-stamp)
(setq time-stamp-active t)
(setq time-stamp-start "[Ll]ast [Mm]odified : ")
(setq time-stamp-format "%:y-%02m-%02d-%02H:%02M:%02S")
(setq time-stamp-end " \\|$")
(add-hook 'before-save-hook 'time-stamp)


;; chmod +x
;; ref. http://homepage.mac.com/zenitani/elisp-j.html#chmod
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;; delete file if empty
;; ref. http://www.bookshelf.jp/cgi-bin/goto.cgi?file=meadow&node=delete%20nocontents
(add-hook 'after-save-hook 'delete-file-if-no-contents t)
(defun delete-file-if-no-contents ()
  (when (and buffer-file-name (= (point-min) (point-max)))
    (if (y-or-n-p "Delete file and kill buffer? ")
      (let ((filename buffer-file-name))
        (delete-file filename)
        (kill-buffer (current-buffer))
        (message (concat "Deleted " (file-name-nondirectory filename)))
        ))))


;; --------- Window system ---------
(global-font-lock-mode t)  ; always turn on syntax highlighting (e21)
(if window-system
    (progn
      ;; default color
;;       (add-to-list 'default-frame-alist '(cursor-color . "SlateBlue2"))
;;       (add-to-list 'default-frame-alist '(mouse-color . "SlateBlue2"))
;;       (add-to-list 'default-frame-alist '(foreground-color . "white"))
;;       (add-to-list 'default-frame-alist '(background-color . "grey0"))
;;       (set-face-foreground 'modeline "white")
;;       (set-face-background 'modeline "SlateBlue2")
;;       (set-face-background 'region  "LightSteelBlue1")
      ;; default window position
;;       (add-to-list 'default-frame-alist '(width . 135))        ;; フレームの幅
;;       (add-to-list 'default-frame-alist '(height . 42))        ;; フレームの高さ
;;       (add-to-list 'default-frame-alist '(top . 0))            ;; Y 表示位置
;;       (add-to-list 'default-frame-alist '(left . 0))           ;; X 表示位置
      ;; faces
;;       (set-face-foreground 'font-lock-comment-face "MediumSeaGreen")
;;       (set-face-foreground 'font-lock-string-face  "purple")
;;       (set-face-foreground 'font-lock-keyword-face "blue")
;;       (set-face-foreground 'font-lock-function-name-face "blue")
;;       (set-face-bold-p 'font-lock-function-name-face t)
;;       (set-face-foreground 'font-lock-variable-name-face "yellow")
;;       (set-face-foreground 'font-lock-type-face "LightSeaGreen")
;;       (set-face-foreground 'font-lock-builtin-face "purple")
;;       (set-face-foreground 'font-lock-constant-face "red")
;;       (set-face-foreground 'font-lock-warning-face "blue")
;;       (set-face-bold-p 'font-lock-warning-face nil)
      ;; scroll bar
      (set-scroll-bar-mode 'right)
      ;; toolbar
      (tool-bar-mode -1)
      ;; pc-selection-mode
      (if (>= emacs-major-version 22)
          (progn (setq pc-select-selection-keys-only t)
                 (pc-selection-mode 1))
        (transient-mark-mode 1))
      ;; additional menu
      (require 'easymenu)
      (setq my-encoding-map (make-sparse-keymap "Encoding Menu"))
      (easy-menu-define my-encoding-menu my-encoding-map
        "Encoding Menu."
        '("Change File Encoding"
          ["UTF8 - Unix (LF)" (set-buffer-file-coding-system 'utf-8-unix) t]
          ["UTF8 - Mac (CR)" (set-buffer-file-coding-system 'utf-8-mac) t]
          ["UTF8 - Win (CR+LF)" (set-buffer-file-coding-system 'utf-8-dos) t]
          ["--" nil nil]
          ["Shift JIS - Mac (CR)" (set-buffer-file-coding-system 'sjis-mac) t]
          ["Shift JIS - Win (CR+LF)" (set-buffer-file-coding-system 'sjis-dos) t]
          ["--" nil nil]
          ["EUC - Unix (LF)"  (set-buffer-file-coding-system 'euc-jp-unix) t]
          ["JIS - Unix (LF)"  (set-buffer-file-coding-system 'junet-unix) t]
          ))
      (define-key-after menu-bar-file-menu [my-file-separator]
        '("--" . nil) 'kill-buffer)
      (define-key-after menu-bar-file-menu [my-encoding-menu]
        (cons "File Encoding" my-encoding-menu) 'my-file-separator)
      ))

;; save last window-size and position
(defun my-window-size-save ()
  (let* ((rlist (frame-parameters (selected-frame)))
         (ilist initial-frame-alist)
         (nCHeight (frame-height))
         (nCWidth (frame-width))
         (tMargin (if (integerp (cdr (assoc 'top rlist)))
                      (cdr (assoc 'top rlist)) 0))
         (lMargin (if (integerp (cdr (assoc 'left rlist)))
                      (cdr (assoc 'left rlist)) 0))
         buf
         (file "~/.framesize.el"))
    (if (get-file-buffer (expand-file-name file))
        (setq buf (get-file-buffer (expand-file-name file)))
      (setq buf (find-file-noselect file)))
    (set-buffer buf)
    (erase-buffer)
    (insert (concat
             ;; 初期値をいじるよりも modify-frame-parameters
             ;; で変えるだけの方がいい?
             "(delete 'width initial-frame-alist)\n"
             "(delete 'height initial-frame-alist)\n"
             "(delete 'top initial-frame-alist)\n"
             "(delete 'left initial-frame-alist)\n"
             "(setq initial-frame-alist (append (list\n"
             "'(width . " (int-to-string nCWidth) ")\n"
             "'(height . " (int-to-string nCHeight) ")\n"
             "'(top . " (int-to-string tMargin) ")\n"
             "'(left . " (int-to-string lMargin) "))\n"
             "initial-frame-alist))\n"
             ;;"(setq default-frame-alist initial-frame-alist)"
             ))
    (save-buffer)
    ))

(defun my-window-size-load ()
  (let ((file "~/.framesize.el"))
    (if (file-exists-p file)
        (load file))))
(my-window-size-load)
;; Call the function above at C-x C-c.
(defadvice save-buffers-kill-emacs
  (before save-frame-size activate)
  (my-window-size-save))

;; display time
(display-time-mode 1)


;; color
;; (if window-system (progn
;;   (setq initial-frame-alist '((width . 130) (height . 42)))
;;   (set-background-color "grey14")
;;   (set-foreground-color "green3")
;;   (set-cursor-color "snow")
;; ))

;; default-window-opacity setting
(add-to-list 'default-frame-alist '(alpha . 0.78))

;; current-window-opacity setting
;; (set-frame-parameter nil 'alpha 0.85)
(set-frame-parameter nil 'alpha 78)
;;(setq frame-alpha-lower-limit 10)

;; color showup paren
(require 'paren)
(show-paren-mode t)
(setq show-paren-ring-bell-on-mismatch t)
(setq show-paren-style 'mixed)

;; window move by shift+cursor
(windmove-default-keybindings)
(setq windmove-wrap-around t)

;; line number
;;(line-number-mode 1)

;; high-light line
;; (global-hl-line-mode)
;; (setq hl-linee-face 'underline)
;; (hl-line-mode 1)

;; 現在行をハイライト
(global-hl-line-mode t)
(defface my-hl-line-face
  '((((class color) (background dark))  ; カラーかつ, 背景が dark ならば,
     (:background "DarkSlateBlue" t))   ; 背景を黒に.
    (((class color) (background light)) ; カラーかつ, 背景が light ならば,
     (:background "ForestGreen" t))     ; 背景を ForestGreen に.
    (t (:bold t)))
  "hl-line's my face")
(setq hl-line-face 'my-hl-line-face)

;; set color-theme
(require 'color-theme)
;(color-theme-initialize)
;(color-theme-Arjen)
(color-theme-billw)

;; howm
(load "~/.emacs.d/misc.howm.el")

;; 行末のスペースを強調表示
(defun show-whitespace ()
  (when (boundp 'show-trailing-whitespace)
    (setq-default show-trailing-whitespace t)))

;; add [2009/08/20]
;;---------------------------------------
;; delete whitespace when save the file
;;---------------------------------------
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; add [2009/11/30]
;;---------------------------------------
;; rss reader
;;---------------------------------------
(setq load-path (cons (expand-file-name "~/.emacs.d/newsticker") load-path))
;;(add-to-list 'load-path "/path/to/newsticker/")
(autoload 'newsticker-start "newsticker" "Emacs Newsticker" t)
(autoload 'newsticker-show-news "newsticker" "Emacs Newsticker" t)

;;=======================================================================
;; language setting
;;=======================================================================
;;global settings for lang
;;cc-mode
;; (add-hook 'c-mode-common-hook
;;     '(lambda ()
;;        (c-set-style "k&r")
;;        (setq c-basic-offset 4)
;;        (setq indent-tabs-mode t)
;;        (setq tab-width 4)))

;; ==========================================================
;; emacs-lisp-mode
;; load setting for emacs lisp, first.
(load (expand-file-name "~/.emacs.d/lang.elisp.el"))
(add-hook 'emacs-lisp-mode-hook
          '(lambda()
             (show-paren-mode t)
             (show-whitespace)))

;;----------------------------------------------------------------
;;PHP
;;-----------------------------------------------------------------
;;(load "~/.emacs.d/lang.php.el")
(load-file "~/.emacs.d/lang.php.el")


;; ==========================================================
;; psvn (subversion emacs addon)
;; (require 'psvn)
;; (add-hook 'dired-mode-hook
;;           '(lambda ()
;;              (require 'dired-x)
;;              ;;(define-key dired-mode-map "V" 'cvs-examine)
;;              (define-key dired-mode-map "V" 'svn-status)
;;              (turn-on-font-lock)
;;              ))
;; (setq svn-status-hide-unmodified t)
;; (setq process-coding-system-alist
;;       (cons '("svn" . utf-8) process-coding-system-alist))

(autoload 'svn-status "dsvn" "Run `svn status'." t)
(autoload 'svn-update "dsvn" "Run `svn update'." t)


;;-----------------------------------------------------------------
;; ECB
;;-----------------------------------------------------------------
;;(setq load-path (cons (expand-file-name "~/.emacs.d/ecb-2.32") load-path))
;;(add-to-list 'load-path (expand-file-name "~/.emacs.d/ecb-2.32"))
(add-lo-emacsd-to-loadpath "ecb-latest")
(add-lo-emacsd-to-loadpath "cedet-1.0pre7/common")
;;(load-file "~/.emacs.d/cedet-1.0pre4/common/cedet.el")
(load-file "~/.emacs.d/cedet-1.0pre7/common/cedet.el")
(setq semantic-load-turn-useful-things-on t)

;; ECB
(require 'ecb)
(setq ecb-tip-of-the-day nil)
(setq ecb-windows-width 0.25)

(defun ecb-toggle ()
  (interactive)
  (if ecb-minor-mode
      (ecb-deactivate)
    (ecb-activate)))
(global-set-key [f2] 'ecb-toggle)


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.32")
 '(indent-region-mode t)
 '(jde-jdk-registry (quote (("1.6.0_24" . "/usr/bin/java"))))
 '(newsticker-html-renderer (quote w3m-region))
 '(newsticker-url-list (quote (("observing japan" "http://www.observingjapan.com/" nil nil nil))))
 '(newsticker-url-list-defaults (quote (("CNET News.com" "http://export.cnet.com/export/feeds/news/rss/1,11176,,00.xml") ("Emacs Wiki" "http://www.emacswiki.org/cgi-bin/wiki.pl?action=rss" nil 3600) ("slashdot" "http://slashdot.org/index.rss" nil 3600) ("Wired News" "http://www.wired.com/news_drop/netcenter/netcenter.rdf"))))
 '(nxhtml-global-minor-mode t)
 '(nxhtml-global-validation-header-mode t)
 '(nxhtml-skip-welcome t)
 '(safe-local-variable-values (quote ((Syntax . ANSI-Common-Lisp) (Base . 10)))))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;; flymake php & javascript setting
(when (require 'flymake nil t)
  (global-set-key "\C-cd" 'flymake-display-err-menu-for-current-line)
  (set-face-background 'flymake-errline "red4")
  (set-face-background 'flymake-warnline "dark slate blue")

  ;; PHP用設定
  (when (not (fboundp 'flymake-php-init))
    ;; flymake-php-initが未定義のバージョンだったら、自分で定義する
    (defun flymake-php-init ()
      (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                           'flymake-create-temp-inplace))
             (local-file  (file-relative-name
                           temp-file
                           (file-name-directory buffer-file-name))))
        (list "php" (list "-f" local-file "-l"))))
    (setq flymake-allowed-file-name-masks
          (append
           flymake-allowed-file-name-masks
           '(("\\.php[345]?$" flymake-php-init))))
    (setq flymake-err-line-patterns
          (cons
           '("\\(\\(?:Parse error\\|Fatal error\\|Warning\\): .*\\) in \\(.*\\) on line \\([0-9]+\\)" 2 3 nil 1)
           flymake-err-line-patterns)))
  ;; JavaScript用設定
  (when (not (fboundp 'flymake-javascript-init))
    ;; flymake-javascript-initが未定義のバージョンだったら、自分で定義する
    (defun flymake-javascript-init ()
      (let* ((temp-file (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-inplace))
             (local-file (file-relative-name
                          temp-file
                          (file-name-directory buffer-file-name))))
        ;;(list "js" (list "-s" local-file))
        (list "jsl" (list "-process" local-file))
        ))
    (setq flymake-allowed-file-name-masks
          (append
           flymake-allowed-file-name-masks
           '(("\\.json$" flymake-javascript-init)
             ("\\.js$" flymake-javascript-init))))
    (setq flymake-err-line-patterns
          (cons
           '("\\(.+\\)(\\([0-9]+\\)): \\(?:lint \\)?\\(\\(?:warning\\|SyntaxError\\):.+\\)" 1 2 nil 3)
           flymake-err-line-patterns)))
  (add-hook 'php-mode-hook
            '(lambda() (flymake-mode t)))
  (add-hook 'javascript-mode-hook
            '(lambda() (flymake-mode t))))


;===============================================
;; toggle shell
;===============================================
(load-library "~/.emacs.d/lisp/shell-toggle-patched.el")
(autoload 'shell-toggle "shell-toggle"
    "Toggles between the *shell* buffer and whatever buffer you are editing."
   t)
(autoload 'shell-toggle-cd "shell-toggle"
    "Pops up a shell-buffer and insert a \"cd <file-dir>\" command." t)
(global-set-key "\C-ct" 'shell-toggle)
(global-set-key "\C-cd" 'shell-toggle-cd)
(add-hook 'term-mode-hook
          (lambda ()
            (setq-default show-trailing-whitespace nil)))


;; tramp
(require 'tramp)
(setq tramp-default-method "sshx")
(add-to-list
  'tramp-multi-connection-function-alist
  '("sshx" tramp-multi-connect-rlogin "ssh -t %h -l %u /bin/sh%n"))
(add-to-list
  'tramp-multi-connection-function-alist
  '("sshp65000" tramp-multi-connect-rlogin "ssh -t %h -l %u -p 65000 /bin/sh%n"))

;;(setq tramp-debug-buffer t) ;; Debug Buffer の表示
;;(setq tramp-verbose 10) ;; 10 is max, 0 is min


;;; Linux の時だけ読み込む
;; (cond
;;  ((string-match "linux" system-configuration)
;;   (nconc  (cadr (assq 'tramp-login-args
;;          (assoc "ssh" tramp-methods))) '("/bin/zsh" "-i"))
;;   (setcdr       (assq 'tramp-remote-sh
;;          (assoc "ssh" tramp-methods))  '("/bin/zsh -i"))
;;   (setq tramp-completion-without-shell-p t)))

(defun sudo-edit (&optional arg)
  (interactive "p")
  (if arg
      (find-file (concat "/sudo::" (ido-read-file-name "File: ")))
    (find-alternate-file (concat "/sudo::" buffer-file-name))))

(defun sudo-edit-current-file ()
  (interactive)
  (let ((pos (point)))
    (find-alternate-file (concat "/sudo::" (buffer-file-name (current-buffer))))
    (goto-char pos)))


;; (defun sudo-edit-current-file ()
;;   (interactive)
;;   (save-excursion
;;     (find-alternate-file (concat "/sudo::" (buffer-file-name (current-buffer))))))

(global-set-key (kbd "C-c C-r") 'sudo-edit-current-file)


;;;;
;;;; Languages
;;;;

;;-----------------------------------------------------------------
;; ruby
;;-----------------------------------------------------------------
;;(load "~/.emacs.d/lang.ruby.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; gauche (scheme)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/lang.gauche.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; common lisp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun slime-sbcl ()
  (interactive)
  (load "~/.emacs.d/lang.CL.el"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; clojure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun slime-clojure ()
  (interactive)
  (progn
    ;; (shell-command (concat (expand-file-name "~/.lein/bin/swank-clojure") " &"))
    ;; (sleep-for 5)
    (load "~/.emacs.d/lang.clojure.el")
    ;; (slime-connect "127.0.0.1" 4005)
    ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; scala
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/lang.scala.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; haskell
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/lang.haskell.el")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; actionscript
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (add-lo-emacsd-to-loadpath "lisp/actionscript")
;; (autoload 'actionscript-mode "actionscript-mode" "actionscript" t)
;; (setq auto-mode-alist
;;       (append '(("\\.as$" . actionscript-mode)) auto-mode-alist))
;; Load original actionscript-mode extensions.
;;(eval-after-load "actionscript-mode" '(load "as-config"))

(setenv "CLASSPATH" (concat (expand-file-name "~/.emacs.d/lisp/flyparse-mode/lib/flyparse-parsers.jar")
                            ":"
                            (expand-file-name "~/.emacs.d/lisp/flyparse-mode/lib/antlr-runtime-3.1.jar")))
(add-lo-emacsd-to-loadpath "lisp/flyparse-mode")
(add-lo-emacsd-to-loadpath "lisp/as3-mode")

(when (require 'as3-mode nil t)
  (setq auto-mode-alist
        (append '(("\\.as$" . as3-mode)) auto-mode-alist))
  (add-hook 'as3-mode-hook
            '(lambda ()
               ;; (define-key as3-mode-map (kbd "C-c e f") 'flyparse-toggle-debug-overlays)
               (require 'flymake-as3)
               (setq flymake-check-was-interrupted t))))


;;; java
(add-lo-emacsd-to-loadpath "lisp/elib")
(add-lo-emacsd-to-loadpath "lisp/jdee/lisp")
(require 'jde)
(add-hook 'java-mode-hook
          (lambda ()
            ;; (tool-bar-mode t)
            ))

;;;; javascript
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))


;; anything
(load "~/.emacs.d/misc.anything.el")

;; nxhtml-mode (nxml-mode)
(load "~/.emacs.d/lang.nxhtml.el")

;----------------------------------
;; etags の追加関数(タグファイルの作成)
;----------------------------------
;; 再帰的にファイルを検索させて、etags を実行させる。
;; (defun etags-find (dir pattern)
;;  " find DIR -name 'PATTERN' |etags -"
;;  (interactive
;;   "DFind-name (directory): \nsFind-name (filename wildcard): ")
;;  (shell-command
;;   (concat "find " dir " -type f -name \"" pattern "\" | etags -")))

(defun etags-find (dir pattern save-dir)
 "recursively execute etags to files that given PATTERN"
 (interactive
  "DWhere To Find (directory): \nsFile To Find (filename wildcard): \nDWhere To Save (directory): ")
 (flet ((is-last-one-wordp (dir-n)
          (let ((last-char (substring dir-n -1)))
            (cond ((string= last-char "/") t)
                  (t nil)))))
   (let* ((save-path
           (concat (if (is-last-one-wordp save-dir)
                       save-dir
                       (concat save-dir "/"))
                   "TAGS"))
          (dir (if (is-last-one-wordp dir)
                   (substring dir 0 -1)
                   dir))
          (opt (if (file-exists-p save-path) "-a" ""))
          (ctags-pdir (cond ((equal system-configuration "i386-apple-darwin9.8.0")
                             (expand-file-name "~/bin/ctags/bin/"))
                            ;; ((equal system-configuration "powerpc-apple-darwin8.11.0")
;;                              "/usr/local/bin/")
                            (t ""))))
     (shell-command
      (concat ctags-pdir "ctags -f " save-path " -e " opt " `find " dir " -type f -name \"" pattern "\"`")))))


;===============================================
; yasnippet settings
;===============================================
(add-lo-emacsd-to-loadpath "lisp/yasnippet")
(require 'yasnippet)
(require 'anything-c-yasnippet)
(setq anything-c-yas-space-match-any-greedy t) ;[default: nil]
;; (add-hook 'yasnippet-mode-hook
;;           (lambda ()
;;             (define-key 'yasnippet-mode-map (kbd "C-c y") 'anything-c-yas-complete)
;;             ))
(global-set-key (kbd "C-c y") 'anything-c-yas-complete)

(yas/initialize)
(yas/load-directory "~/.emacs.d/lisp/yasnippet/snippets")
;; by update of anything itself, yas/extra-mode-hook dont need
;; any more.
;(add-to-list 'yas/extra-mode-hooks 'php-mode-hook)
;(add-to-list 'yas/extra-mode-hooks 'ruby-mode-hook)
;(add-to-list 'yas/extra-mode-hooks 'cperl-mode-hook)
(add-hook 'scala-mode-hook
            '(lambda ()
               (yas/minor-mode-on)
               ))

;; yas/define-snippets と同じ形式で snippet の追加をする
(defun _yas/add-snippets (mode snippets)
  (interactive)
  (let (snippet)
    (while snippets
      (setq snippet (car snippets))
      (yas/define mode (nth 0 snippet) (nth 1 snippet) (nth 2 snippet))
      (setq snippets (delete snippet snippets)))))

;; enable anything dropdown list
(require 'dropdown-list)
(setq yas/prompt-functions '(yas/dropdown-prompt))

;;====================================
;;; windows.el
;;====================================
;; キーバインドを変更．;
; デフォルトは C-c C-w
;; 変更しない場合」は，以下の 3 行を削除する
;; (setq win:switch-prefix "\C-z")
;; (define-key global-map win:switch-prefix nil)
;; (define-key global-map "\C-z1" 'win-switch-to-window)
(require 'windows)
;; 新規にフレームを作らない
(setq win:use-frame nil)
(win:startup-with-window)
;(define-key ctl-x-map "C" 'see-you-again)
;; C-x C-c で終了するとそのときのウィンドウの状態を保存する
;; C-x C なら保存しない
(define-key ctl-x-map "\C-c" 'see-you-again)
(define-key ctl-x-map "C" 'save-buffers-kill-emacs)

;; revive.el
(autoload 'save-current-configuration "revive" "Save status" t)
(autoload 'resume "revive" "Resume Emacs" t)
(autoload 'wipe "revive" "Wipe emacs" t)
;; *migemo* のようなバッファも保存
(setq revive:ignore-buffer-pattern "^ \\*")
;(resume-windows)

;; mac input method
(setq default-input-method "MacOSX")

;; info
(require 'info)
(setq Info-directory-list Info-default-directory-list)

;; info-lookup-alist

;; one-key
(add-lo-emacsd-to-loadpath  "lisp/one-key")
(require 'one-key)
(defvar one-key-menu-emms-alist nil
  "`One-Key' menu list for EMMS.")

(setq one-key-menu-emms-alist
      '((("g" . "Playlist Go") . emms-playlist-mode-go)
        (("d" . "Play Directory Tree") . emms-play-directory-tree)
        (("f" . "Play File") . emms-play-file)
        (("i" . "Play Playlist") . emms-play-playlist)
        (("t" . "Add Directory Tree") . emms-add-directory-tree)
        (("c" . "Toggle Repeat Track") . emms-toggle-repeat-track)
        (("w" . "Toggle Repeat Playlist") . emms-toggle-repeat-playlist)
        (("u" . "Play Now") . emms-play-now)
        (("z" . "Show") . emms-show)
        (("s" . "Emms Streams") . emms-streams)
        (("b" . "Emms Browser") . emms-browser)))

(defun one-key-menu-emms ()
  "`One-Key' menu for EMMS."
  (interactive)
  (one-key-menu "EMMS" one-key-menu-emms-alist t))

(global-set-key (kbd "C-c p") 'one-key-menu-emms)
(setq max-lisp-eval-depth 10000)
(setq max-specpdl-size 10000)

;; just temporary for us keybord
(global-set-key (kbd "C-;") 'anything)


;; for erlang
(add-lo-emacsd-to-loadpath  "lisp/erlang")
(add-to-list 'exec-path "/opt/local/bin")
(setq erlang-root-dir "/opt/local/lib/erlang")
(require 'erlang-start)

;; git
;; (add-to-list 'load-path "~/.emacs.d/lisp/git-emacs") ; or your installation path
;; (fmakunbound 'git-status)   ; Possibly remove Debian's autoloaded version
;; (require 'git-emacs-autoloads)

(add-lo-emacsd-to-loadpath "lisp/magit")
(require 'magit)
(require 'magit-svn)

(add-lo-emacsd-to-loadpath "lisp/tumble")
(require 'tumble)

;; figure out ip-add
(defun machine-ip-address (dev)
  (let ((info (network-interface-info dev)))
    (if info
        (format-network-address (car info) t))))

(defvar *nick* '("en1" "wlan0"))
(defun homep ()
  "difference of ip adderss is find out where at right now"
  (let ((ip (some #'machine-ip-address *nick*)))
    (and ip (eq 0 (string-match "^192\\.168\\.11\\." ip)))))


(require 'auto-save-buffers)
;; code from `auto-save-buffers.el' originally for saving all buffers automatically.
(defun save-all-buffers (&rest regexps)
  (interactive)
  "Just call `auto-save-buffer' function."
  (auto-save-buffers regexps))


;;; start.el ends here
