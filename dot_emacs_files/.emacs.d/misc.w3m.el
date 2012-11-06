;; 4.1. 基本
;;     次の設定を ~/.emacs に追加してください．
;;(add-to-list 'load-path "/Applications/Emacs.app/Contents/Resource/site-lisp/w3m")
(require 'w3m-load)
(autoload 'w3m "w3m" "Interface for w3m on Emacs." t)

;;     付属プログラムを使用するには，追加の設定が必要な場合があります．詳
;;     細については，個々の付属プログラムのソースファイルの先頭に記載され
;;     ているコメントを参照してください．良く分からない場合は，とりあえず，
;;     以下の設定を ~/.emacs に追加しておいてください．

(autoload 'w3m-find-file "w3m" "w3m interface function for local file." t)
(autoload 'w3m-search "w3m-search" "Search QUERY using SEARCH-ENGINE." t)
(autoload 'w3m-weather "w3m-weather" "Display weather report." t)
(autoload 'w3m-antenna "w3m-antenna" "Report chenge of WEB sites." t)
(autoload 'w3m-namazu "w3m-namazu" "Search files with Namazu." t)

;; (setq w3m-icon-directory
;;       (cond
;;        ((featurep 'mac-carbon) "/Applications/Emacs.app/Contents/Resource/etc/w3m")
;;        ((featurep 'dos-w32) "D:/cygwin//usr/local/emacs/etc/w3m")))

;; (setq w3m-namazu-tmp-file-name
;;       (cond
;;        ((featurep 'mac-carbon) "~/.nmz.html")
;;        ((featurep 'dos-w32) "d:/cygwin/home/hoge/.nmz.html")))

(setq w3m-namazu-index-file "~/.w3m-namazu.index")

;; (setq w3m-bookmark-file
;;       (cond
;;        ((featurep 'mac-carbon) "~/.w3m/bookmark.html")
;;        ((featurep 'dos-w32) "d:/cygwin/home/hoge/public_html/bookmark.html")))

;; (if (featurep 'dos-w32)
;;   (setq w3m-imagick-convert-program "d:/cygwin/usr/local/bin/convert.exe"))

;;; ■■ browse-url
;;;   以下のように設定しておくと、URI に類似した文字列がある場所で C-x m と
;;;   入力すれば、w3m で表示されるようになる。
(setq browse-url-browser-function 'w3m-browse-url)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
(global-set-key "\C-xm" 'browse-url-at-point)

;;; ■■ dired
;;;   以下のように設定しておくと、dired-mode のバッファでファイルを選択して
;;;   いる状態で C-x m と入力すれば、該当ファイルが w3m で表示されるように
;;;   なる。

(add-hook 'dired-mode-hook
          (lambda ()
            (define-key dired-mode-map "\C-xm" 'dired-w3m-find-file)))

(defun dired-w3m-find-file ()
  (interactive)
  (require 'w3m)
  (let ((file (dired-get-filename)))
    (if (y-or-n-p (format "Open 'w3m' %s " (file-name-nondirectory file)))
        (w3m-find-file file))))

;; ;; (1) Install SEMI.
;; ;; (2) Put this file to appropriate directory.
;; ;; (3) Write these following code to your ~/.emacs or ~/.gnus.
;; ;; w3m でhtml パートを表示する。
;; (require 'mime-w3m)

;; ;; w3mのバッファーでは、デフォルトで、inline image 表示
;; (setq w3m-default-display-inline-images t)

;; ;; wanderlust の、message buffer では、html メールに関しては、デフォルトでは
;; ;; inline image off にしておく。

;; (setq mime-w3m-safe-url-regexp nil)
;; (setq mime-w3m-display-inline-images nil)

;; ;; message buffer で、C-u M-i で、inline image 表示
;; ;; 安全だと思われる、メールだけ、表示する。

;; (defun wl-summary-w3m-safe-toggle-inline-images (&optional arg)
;;   "Toggle displaying of all images in the message buffer.
;; If the prefix arg is given, all images are considered to be safe."
;;   (interactive "P")
;;   (save-excursion
;;     (set-buffer wl-message-buffer)
;;     (w3m-safe-toggle-inline-images arg)))

;; (eval-after-load "wl-summary"
;;   '(define-key wl-summary-mode-map
;;      "\M-i" 'wl-summary-w3m-safe-toggle-inline-images))
