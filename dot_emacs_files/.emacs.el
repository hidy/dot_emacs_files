;======================================================================
; 言語・文字コード関連の設定
;======================================================================
;;(require 'un-define)

;; no need for ntemacs
;;(set-language-environment "Japanese")
;; this is already set for ntemacs
;;(setq default-file-name-coding-system 'japanese-shift-jis-dos)
;; (set-terminal-coding-system 'utf-8)
;; (set-keyboard-coding-system 'utf-8)
;; (set-buffer-file-coding-system 'utf-8)
;; (setq default-buffer-file-coding-system 'utf-8)
;; (prefer-coding-system 'utf-8)
;extend settings for utf-8 env
;; (setq file-name-coding-system 'utf-8)
;; (set-clipboard-coding-system 'utf-8)
;(set-default-coding-system 'utf-8)

;;
;======================================================================
; Anthy
;    CTRL-\で入力モード切替え
;======================================================================
;;(load-library "anthy")
;;(setq default-input-method "japanese-anthy")
;;(setq anthy-accept-timeout 1)
;;
;=======================================================================
;フォント
;=======================================================================
;; (cond (window-system
;;      (set-default-font "-*-fixed-medium-r-normal--10-*-*-*-*-*-*-*")
;;        (progn
;;          (set-face-font 'default
;;                         "-shinonome-gothic-medium-r-normal--10-*-*-*-*-*-*-*")
;;          (set-face-font 'bold
;;                         "-shinonome-gothic-bold-r-normal--10-*-*-*-*-*-*-*")
;;          (set-face-font 'italic
;;                         "-shinonome-gothic-medium-i-normal--10-*-*-*-*-*-*-*")
;;          (set-face-font 'bold-italic
;;                         "-shinonome-gothic-bold-i-normal--10-*-*-*-*-*-*-*")
;;        )))
;;

;; Font setting for Emacs23
;; (cond ( (string-match "^23\." emacs-version)
;;   (cond (window-system
;;     (set-default-font "Bitstream Vera Sans Mono-10.8")
;;     (set-fontset-font (frame-parameter nil 'font)
;;                                           'japanese-jisx0208
;;                                           '("VL ゴシック" . "unicode-bmp"))))))

;=======================================================================
; load-path (put where your own elisp)
;=======================================================================
(setq load-path
      (append (list "~/.emacs.d"
                    "~/.emacs.d/lisp")
              load-path))

;; (add-to-list 'load-path "~/.emacs.d/lisp")
;; (setq load-path
;;       (cons (expand-file-name "~/.emacs.d/lisp") load-path))

;=======================================================================
;フレームサイズ・位置・色など
;=======================================================================
;; (setq initial-frame-alist
;;         (append (list
;;                    '(foreground-color . "white")        ;; 文字色
;;                    '(background-color . "grey10")       ;; 背景色
;;                    '(border-color . "black")
;;                    '(mouse-color . "white")
;;                    '(cursor-color . "white")
;;                '(width . 120)                       ;; フレームの幅
;;                '(height . 40)                       ;; フレームの高さ
;;                '(top . 0)                           ;; Y 表示位置
;;                '(left . 0)                          ;; X 表示位置
;;                    )
;;                 initial-frame-alist))
;; (setq default-frame-alist initial-frame-alist)

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
  (let* ((file "~/.framesize.el"))
    (if (file-exists-p file)
        (load file))))
(my-window-size-load)
;; Call the function above at C-x C-c.
(defadvice save-buffers-kill-emacs
  (before save-frame-size activate)
  (my-window-size-save))


;=======================================================================
; Misc
;=======================================================================
;; 一行づつスクロールするように
(setq scroll-conservatively 35
       scroll-margin 0
       scroll-step 1)
;; シェルモードでも一行づつスクロール
(setq comint-scroll-show-maximum-output t)

(setq inhibit-startup-message t)                        ;; don't show the startup message
;; add [2009/06/19]
(setq initial-scratch-message "")                       ;; do not show message in scratch buffer
;;(mouse-wheel-mode)                                    ;;ホイールマウス
(global-font-lock-mode t)                               ;;文字の色つけ
(setq line-number-mode t)                               ;;カーソルのある行番号を表示
(auto-compression-mode t)                               ;;日本語infoの文字化け防止
(set-scroll-bar-mode 'right)                            ;;スクロールバーを右に表示
(tool-bar-mode 0)                                     ;; hide toolbar

(setq frame-title-format                                ;;フレームのタイトル指定
        (concat "%b - emacs@" system-name))

(display-time)                                          ;;時計を表示
;(setq make-backup-files nil)                           ;;バックアップファイルを作成しない
(setq visible-bell t)                                   ;;警告音を消す
;(setq kill-whole-line t)                               ;;カーソルが行頭にある場合も行全体を削除

;; add [2009/07/29]
;; [M-k] kill whole line before cursor
(defun kill-whole-line (&optional numlines)
  "One line is deleted wherever there is a cursor."
  (interactive "p")
  (setq pos (current-column))
  (beginning-of-line)
  (kill-line numlines)
  (move-to-column pos))
(define-key esc-map "k" 'kill-whole-line)

;;タブではなくスペースを使う
(setq-default indent-tabs-mode nil)
(setq indent-line-function 'indent-relative-maybe)
;; indent
(global-set-key "\C-m" 'reindent-then-newline-and-indent)
(global-set-key "\C-j" 'newline)

(defun show-whitespace ()
  (when (boundp 'show-trailing-whitespace)
    (setq-default show-trailing-whitespace t)))         ;; 行末のスペースを強調表示
(show-whitespace)

(column-number-mode t)                                  ;; show column number
(line-number-mode t)                                    ;; show line number
(setq truncate-lines nil)                               ;; truncate line nil(not) t(yes)
(setq transient-mark-mode t)                            ;; markup region
(setq highlight-nonselected-windows t)                  ;; hold markup region when switch buffer
(setq next-line-add-newlines nil)                       ;; do not put newline endof buffer

(require 'paren)
(show-paren-mode t)
(setq show-paren-ring-bell-on-mismatch t)
(setq show-paren-style 'mixed)

;;(auto-fill-mode 1)
(require 'filecache)
(file-cache-add-directory-list (list "~"))  ;; enable filecache
(define-key minibuffer-local-completion-map
  "\C-c\C-f" 'file-cache-minibuffer-complete)

;; backup file setting
(setq make-backup-files t)
(setq backup-directory-alist
          (cons (cons "\\.*$" (expand-file-name "~/.emacs.d/backup"))
                backup-directory-alist))

;;================================================
;; delete-region
;;================================================
;; when region is active, delete 'em all
;; (when transient-mark-mode
;;   (defadvice backward-delete-char-untabify
;;     (around ys:backward-delete-region activate)
;;     (if (and transient-mark-mode mark-active)
;;         (delete-region (region-beginning) (region-end))
;;       ad-do-it)))

(defadvice kill-new (before ys:no-kill-new-duplicates activate)
  (setq kill-ring (delete (ad-get-arg 0) kill-ring)))

;; delete-region
;; (when transient-mark-mode
;;   (defadvice backward-delete-char-untabify
;;     (around delete-region-like-windows activate)
;;     (if mark-active
;;         (delete-region (region-beginning) (region-end))
;;       ad-do-it)))

;; you can also do this way
(delete-selection-mode 1)
;;================================================

;; redo
;;(require 'redo)

;; window move by shift+cursor
(windmove-default-keybindings)
(setq windmove-wrap-around t)

;----------------------------------
;; auto-complete
;----------------------------------
(add-to-list 'load-path "~/.emacs.d/lisp/auto-complete")
(require 'auto-complete)
(global-auto-complete-mode t)
(require 'auto-complete-extension)

;----------------------------------
; install-elisp
;----------------------------------
;; auto-install
(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/lisp/")
;(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)
;; install-elisp
(require 'install-elisp)
(setq install-elisp-repository-directory "~/.emacs.d/lisp")


;----------------------------------
;; yank-pop
;----------------------------------
(autoload 'yank-pop-forward "yank-pop-summary" nil t)
(autoload 'yank-pop-backward "yank-pop-summary" nil t)
(global-set-key "\M-y" 'yank-pop-forward)
(global-set-key "\C-\M-y" 'yank-pop-backward)

;; recentf
(require 'recentf)
(setq recentf-auto-cleanup 'never)
(setq recentf-max-saved-items 500)
(setq recentf-max-menu-items 10)
(setq recent-exclude '("^/[^/:]:+:"))
(recentf-mode 1)
;; add [2010/11/22]
;;(recentf-exclude (quote (".ftp:.*" ".sudo:.*")))
;;(recentf-keep (file-remote-p file-readable-p))
;; ==================
(define-key global-map "\C-@" 'recentf-open-files)

;; resize minibuffer
;;(resize-minibuffer-mode 1)
(temp-buffer-resize-mode 1)

;; where autosave file at
(setq auto-save-list-file-prefix (expand-file-name "~/.emacs.d/auto-save-list/"))

;; dont care capital or not
(setq completion-ignore-case t)

;; select buffer like I-search
;;(iswitchb-default-keybindings)
;;(require 'uniquify)
;;(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

(setq gc-cons-threshold 5242880)

;; dabbrev-ja
(load "dabbrev-ja")

;; set color-theme
(require 'color-theme)
;;(color-theme-initialize)
;(color-theme-Arjen)
(color-theme-billw)

;; add [2009/07/29]
;;---------------------------------------
;; sdic dictionary
;;---------------------------------------
(autoload 'sdic-describe-word "sdic" "単語の意味を調べる" t nil)
(global-set-key "\C-cw" 'sdic-describe-word)
(autoload 'sdic-describe-word-at-point "sdic" "カーソル位置の単語の意味を調べる" t nil)
(global-set-key "\C-cW" 'sdic-describe-word-at-point)
;; 動作と見かけの調整
(setq sdic-window-height 10
      sdic-disable-select-window t)
;; 英和-和英辞書の設定
(setq sdic-eiwa-dictionary-list
      '((sdicf-client "/usr/share/dict/gene.sdic")))
(setq sdic-waei-dictionary-list
      '((sdicf-client "/usr/share/dict/jedict.sdic")))

;; add [2010/02/18]
;---------------------------------------
;; info
;---------------------------------------
;; (require 'info)
;; (setq Info-directory-list
;;       (cons (expand-file-name "/home/bob/info")
;;             Info-directory-list))

;; add [2009/07/01]
;---------------------------------------
;; delete whitespace when save the file
;---------------------------------------
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; old version
;; (add-hook 'after-save-hook
;;        (lambda ()
;;          (save-excursion
;;            (beginning-of-buffer)
;;            (perform-replace "  *$" "" nil t nil))))


;----------------------------------
;; etags の追加関数(タグファイルの作成)
;----------------------------------
;; 再帰的にファイルを検索させて、etags を実行させる。
(defun etags-find (dir pattern)
 " find DIR -name 'PATTERN' |etags -"
 (interactive
  "DFind-name (directory): \nsFind-name (filename wildcard): ")
 (shell-command
  (concat "find " dir " -type f -name \"" pattern "\" | etags -")))

(defadvice find-tag (before c-tag-file activate)
  "Automatically create tags file."
  (let ((tag-file (concat default-directory "TAGS")))
    (unless (file-exists-p tag-file)
      (shell-command "etags *.[ch] *.el .*.el -o TAGS 2>/dev/null"))
    (visit-tags-table tag-file)))


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
      (setq truncate-partial-width-windows nil)))
  (recenter))

; 折り返し表示ON/OFF
(global-set-key "\C-cl" 'toggle-truncate-lines)

;===============================================
;; ホイールマウス対応
;===============================================
;(mouse-wheel-mode)
;(setq mouse-wheel-follow-mouse t)
(defun up-slightly () (interactive) (scroll-up 5))
(defun down-slightly () (interactive) (scroll-down 5))
(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly)

(defun up-one () (interactive) (scroll-up 1))
(defun down-one () (interactive) (scroll-down 1))
(global-set-key [S-mouse-4] 'down-one)
(global-set-key [S-mouse-5] 'up-one)

(defun up-a-lot () (interactive) (scroll-up))
(defun down-a-lot () (interactive) (scroll-down))
(global-set-key [C-mouse-4] 'down-a-lot)
(global-set-key [C-mouse-5] 'up-a-lot)

;===============================================
; key bindings
;===============================================
(global-set-key "\C-h" 'backward-delete-char) ;;Ctrl-Hでバックスペース
;;(global-set-key "\C-z" 'undo)                         ;;UNDO
;;(global-set-key "\C-_" 'redo)
(global-set-key "\C-c\C-i" 'indent-region) ;;C-u C-c TAB => (un)indent-region
(global-set-key "\C-c;" 'comment-or-uncomment-region)
(global-set-key "\C-cn" 'other-frame)         ; フレーム移動
(global-set-key "\M--" 'help-command)        ; ヘルプ
(keyboard-translate ?\C-h ?\C-?)
;;(global-set-key [?\M-?] 'help-command)        ; ヘルプ


;=======================================================================
; howm
;=======================================================================
(load-file "~/.emacs.d/misc.howm.el")
;; (add-to-list 'load-path "~/.emacs.d/lisp/howm")
;; (setq howm-menu-lang 'ja)
;; (global-set-key "\C-c,," 'howm-menu)
;; (autoload 'howm-menu "howm" "Hitori Otegaru Wiki Modoki" t)


;=======================================================================
; tramp
;=======================================================================
(require 'tramp)
;(setq tramp-shell-prompt-pattern "^[ $]+")
;;(setq tramp-default-method "ssh")
(setq tramp-default-method "sshx")
;(setq tramp-debug-buffer t) ;; Debug Buffer の表示
;; (add-to-list
;;   'tramp-multi-connection-function-alist
;;   '("sshx" tramp-multi-connect-rlogin "ssh -t %h -l %u /bin/sh%n"))
;; (add-to-list
;;   'tramp-multi-connection-function-alist
;;   '("sshp65000" tramp-multi-connect-rlogin "ssh -t %h -l %u -p 65000 /bin/sh%n"))
(add-to-list 'tramp-default-proxies-alist '("\\'" "\\`root\\'" "/sshx:%h:"))      ;; 追加
(add-to-list 'tramp-default-proxies-alist '("hidemi-laptop\\'" "\\`root\\'" nil)) ;; 追加
(add-to-list 'tramp-default-proxies-alist '("localhost\\'" "\\`root\\'" nil))    ;; 追加

;;; Linux の時だけ読み込む
(cond
 ((string-match "linux" system-configuration)
  (nconc  (cadr (assq 'tramp-login-args
         (assoc "ssh" tramp-methods))) '("/bin/zsh" "-i"))
  (setcdr       (assq 'tramp-remote-sh
         (assoc "ssh" tramp-methods))  '("/bin/zsh -i"))
  (setq tramp-completion-without-shell-p t)))


;=======================================================================
; dired
;=======================================================================
(load "dired-x")
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
(setq ls-lisp-dirs-first t)

;; add [2009/06/22]
;; do not make any buffer with using dired
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

;; add [2009/07/28]
;;; s を何回か入力すると，拡張子やサイズによる並び換えもできる
(load "sorter")
;;; ディレクトリを先に表示する
(setq ls-lisp-dirs-first t)


;; add [2009/07/28]
;; session.el
;; store any kind of history in minibuffer
(require 'session)
(add-hook 'after-init-hook 'session-initialize)
(setq session-undo-check -1)

;; add [2009/07/29]
;; copy, delete recursivelly
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)

;; add [2009/07/29]
;; this is the function module of show list of subdirectory
;; this file helps for making own elisp
;; (require 'dirtree)

;=======================================================================
; language settings
;=======================================================================
;; emacs-lisp-mode
(add-hook 'emacs-lisp-mode-hook
          '(lambda()
             (show-paren-mode t)
             (show-whitespace)))

;; php-mode
;;(load-file "~/.emacs.d/lang.php.el")
(add-to-list 'load-path "~/.emacs.d/lisp/php")
(setq auto-mode-alist
        (cons (cons "\\.\\(phtml\\|ctp\\|thtml\\|inc\\|php[s34]?\\)" 'php-mode) auto-mode-alist))
        (autoload 'php-mode "php-mode" "PHP mode" t)

(add-hook 'php-mode-hook
          '(lambda ()
             (show-whitespace)
             (require 'php-completion)
             (php-completion-mode t)
             (define-key php-mode-map (kbd "C-o") 'phpcmp-complete)
             (when (require 'auto-complete nil t)
               (make-variable-buffer-local 'ac-sources)
               ;;(add-to-list 'ac-sources 'ac-source-php-completion)
               ;; if you like patial match,
               ;; use `ac-source-php-completion-patial' instead of `ac-source-php-completion'.
               (add-to-list 'ac-sources 'ac-source-php-completion-patial)
               (auto-complete-mode t))
             ))

(add-hook 'php-mode-user-hook
          '(lambda ()
             (define-key php-mode-map "\M-j" 'php-complete-function)
             (define-key php-mode-map "\C-m" 'newline-and-indent)
             (c-toggle-auto-hungry-state 1)
             (setq tab-width 4
                   c-basic-offset 4
                   c-hanging-comment-ender-p nil
                   indent-tabs-mode (not
                                     (and (string-match "/\(PEAR\|pear\)/" (buffer-file-name))
                                          (string-match ".php$" (buffer-file-name))))
                   php-manual-path "/usr/share/doc/php-doc/html"
                   php-manual-url "http://www.phppro.jp/phpmanual/"
                   tags-file-name "/usr/share/php/etags/TAGS")
             (show-whitespace)
             ))

(setq php-mode-force-pear t)

;; add [2010/01/10]
;; PHP eval
;; eval php-code in region
(defun php-eval-region nil
  "PHP eval"
  (interactive)
  (shell-command-on-region (region-beginning) (region-end) "php ~/.emacs.d/php/eval.php")
  ;;(shell-command-on-region (point-min) (point-max) "php ~/.emacs.d/php/eval.php")
  )
;;(global-set-key "\C-c\C-e" 'php-eval-region)

;; add [2010/01/10]
;; PHP eval (another version)
(defun php-eval (beg end)
  "Run selected region as PHP code"
  ;(interactive)
  (interactive "r")
  (let ((code (concat "<?php " (buffer-substring beg end))))
    (with-temp-buffer
      (insert code)
      (shell-command-on-region (point-min) (point-max) "php")
      )))
(global-set-key "\C-c\C-e" 'php-eval)

;===============================================
; another settings
;===============================================
;;;css-mode(autoload 'css-mode "css-mode")
;(setq auto-mode-list   (cons '("\\.css\\'" .css-mode) auto-mode-alist))
;(setq cssm-indet-function #'cssm-c-style-indenter)

;;;javascript mode
;(add-to-list 'auto-mode-alist(cons "\\.js\\'" 'javascript-mode))
;(autoload 'javascript-mode "javascript" nil t)
;(setq js-indent-level 4)

;;;mmm-mode
;; (require 'mmm-auto)
;; (setq mmm-global-mode 'maybe)
;; (setq mmm-submode-decoration-level 2)
;; (set-face-bold-p 'mmm-default-submode-face t)
;; (set-face-background 'mmm-default-submode-face "black")
;; (mmm-add-classes
;; '((embedded-css
;;   :submode css-mode
;;   :font "<style[^>]*>"
;;   :back "</style>")))
;; (mmm-add-mode-ext-class nil "\\.html\\'" 'embedded-css)

;; (mmm-add-group 'html-php
;;  '((html-php-output
;;     :submode php-mode
;;     :face mmm-output-submode-face
;;     :front "<\\?php *echo "
;;     :back "\\?>"
;;     :include-front t
;;     :front-offset 5
;;     )
;;    (html-php-code
;;     :submode php-mode
;;     :face mmm-code-submode-face
;;     :front "<\\?\\(php\\)?"
;;     :back "\\?>"
;;     )))
;; (add-to-list 'auto-mode-alist '("\\.php?\\'" . html-helper-mode))
;; (add-to-list 'mmm-mode-ext-classes-alist '(html-helper-mode nil html-php))
;; (set-face-background 'mmm-default-submode-face "nil")
;; (setq mmm-submode-decoration-level 1)

;===============================================
; flymake settings (php, javascript)
;===============================================
(when (require 'flymake nil t)
  (global-set-key "\C-cd" 'flymake-display-err-menu-for-current-line)
  (custom-set-faces
  '(flymake-errline ((((class color)) (:background "red4"))))
  '(flymake-warnline ((((class color)) (:background "blue4")))))
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
;; shell toggle
;===============================================
(load-library "~/.emacs.d/lisp/shell-toggle-patched.el")
(autoload 'shell-toggle "shell-toggle"
  "Toggles between the *shell* buffer and whatever buffer you are editing."
  t)
(autoload 'shell-toggle-cd "shell-toggle"
  "Pops up a shell-buffer and insert a \"cd <file-dir>\" command." t)
(global-set-key "\C-ct" 'shell-toggle)
(global-set-key "\C-cd" 'shell-toggle-cd)

;===============================================
;; gauche (scheme)
;===============================================
;;(load "~/.emacs.d/lang.gauche.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;slime
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(load "~/.emacs.d/lang.CL.el")

;===============================================
;; Haskell
;===============================================
;; (load "haskell-site-file")
;; (setq auto-mode-alist
;;       (append auto-mode-alist
;;               '(("\\.[hg]s$"  . haskell-mode)
;;                 ("\\.hi$"     . haskell-mode)
;;                 ("\\.l[hg]s$" . literate-haskell-mode))))
;; (autoload 'haskell-mode "haskell-mode"
;;    "Major mode for editing Haskell scripts." t)
;; (autoload 'literate-haskell-mode "haskell-mode"
;;    "Major mode for editing literate Haskell scripts." t)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-decl-scan)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-ghci)
;; (add-hook 'haskell-mode-hook 'font-lock-mode)

;; (setq haskell-literate-default 'latex)
;; (setq haskell-doc-idle-delay 0)

;;-----------------------------------------------------------------
;; psvn (subversion emacs addon)
;;-----------------------------------------------------------------
(setq load-path (cons (expand-file-name "~/.emacs.d") load-path))
(require 'psvn)
(add-hook 'dired-mode-hook
          '(lambda ()
             (require 'dired-x)
             ;;(define-key dired-mode-map "V" 'cvs-examine)
             (define-key dired-mode-map "V" 'svn-status)
             (turn-on-font-lock)
             ))
(setq svn-status-hide-unmodified t)
(setq process-coding-system-alist
      (cons '("svn" . utf-8) process-coding-system-alist))

;;-----------------------------------------------------------------
;; ruby
;;-----------------------------------------------------------------
;;(load "~/.emacs.d/lang.ruby.el")

;;-----------------------------------------------------------------
;; ECB
;;-----------------------------------------------------------------
;; ;;(setq load-path (cons (expand-file-name "~/.emacs.d/ecb-2.32") load-path))
;; ;;(load-file "~/.emacs.d/cedet-1.0pre4/common/cedet.el")
;; (setq semantic-load-turn-useful-things-on t)
;; ;; ECB
;; (require 'ecb)
;; (setq ecb-tip-of-the-day nil)
;; (setq ecb-windows-width 0.25)

;; (defun ecb-toggle ()
;;   (interactive)
;;   (if ecb-minor-mode
;;       (ecb-deactivate)
;;     (ecb-activate)))
;; (global-set-key [f2] 'ecb-toggle)

;; ;;; start.el ends here.
;; (custom-set-variables
;;   ;; custom-set-variables was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  '(ecb-options-version "2.32"))
;; (custom-set-faces
;;   ;; custom-set-faces was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  )

;----------------------------------
; one-key
;----------------------------------
;;(add-to-list 'load-path "~/.emacs.d/lisp/one-key")
;;(require 'one-key)
;; ; one-key.el も一緒に読み込んでくれる
;; (require 'one-key-default)
;; ; one-key.el をより便利にする
;; (require 'one-key-config)
;; ; one-key- で始まるメニュー使える様になる
;; (one-key-default-setup-keys)
;; ;; C-x にコマンドを定義
;; (define-key global-map "\C-x" 'one-key-menu-C-x)
;; ;; some custom settings
;; (setq max-lisp-eval-depth 10000)
;; (setq max-specpdl-size 10000)

;;----------------------------------
;; javascript
;;----------------------------------
(load "lang.js")

;;----------------------------------
;; w3m
;;----------------------------------
;;(load "~/.emacs.d/misc.w3m.el")

;;----------------------------------
;; anything
;;----------------------------------
(load "~/.emacs.d/misc.anything.el")

;===============================================
; yasnippet settings
;===============================================
(add-to-list 'load-path "~/.emacs.d/plugins")
(require 'yasnippet)
(require 'anything-c-yasnippet)
(setq anything-c-yas-space-match-any-greedy t) ;[default: nil]
(global-set-key (kbd "C-c y") 'anything-c-yas-complete)
(yas/initialize)
(yas/load-directory "~/.emacs.d/snippets/")
(add-to-list 'yas/extra-mode-hooks 'php-mode-hook)
(add-to-list 'yas/extra-mode-hooks 'ruby-mode-hook)
;;(add-to-list 'yas/extra-mode-hooks 'cperl-mode-hook)

;; yas/define-snippets と同じ形式で snippet の追加をする
(defun _yas/add-snippets (mode snippets)
  (interactive)
  (let (snippet)
    (while snippets
      (setq snippet (car snippets))
      (yas/define mode (nth 0 snippet) (nth 1 snippet) (nth 2 snippet))
      (setq snippets (delete snippet snippets)))))

;;====================================
;;; windows.el
;;====================================
;; キーバインドを変更．
;; デフォルトは C-c C-w
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

(load "~/.emacs.d/init.el")
