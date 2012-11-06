;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; emacs-lisp-mode(下のslimeモードとelispモードを分けるため)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq auto-mode-alist
      ;;; 拡張子とモードの対応
      (append
       '(("/.el" . emacs-lisp-mode))
       '(("/.emacs-*" . emacs-lisp-mode))
       '(("/.wl" . emacs-lisp-mode))
       auto-mode-alist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;slime
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(add-to-list 'load-path "~/.emacs.d/lisp/slime/")
(require 'hyperspec)
(setq common-lisp-hyperspec-root
      (concat "file://"
              (expand-file-name "~/.emacs.d/HyperSpec/"))
      common-lisp-hyperspec-symbol-table
      (expand-file-name "~/.emacs.d/HyperSpec/Data/Map_Sym.txt"))

;string= はそれだけで文字列比較の関数
(defun ime-onoff-slime ()
  (interactive)
  (if slime-mode
      (progn
        (slime-mode nil)
        (toggle-input-method))
    (if (string= major-mode "lisp-mode")
        (progn
          (slime-mode t)
          (toggle-input-method))
      (toggle-input-method))))

;;(or SBCL CLISP)
(defun slime-on (x)
  (progn (setq inferior-lisp-program x)
         (slime)))

(defun slime-clisp ()
  (interactive)
  (slime-on "clisp"))

(defun slime-sbcl ()
  (interactive)
  (slime-on "sbcl"))

(defun slime-abcl ()
  (interactive)
  (slime-on "/home/hidemi/lisp/abcl/abcl-src-0.22.0/abcl"))

;; (setq slime-lisp-implementations
;;  '((abcl ("/home/hidemi/lisp/abcl/abcl-src-0.22.0/abcl"))))
(slime-setup '(slime-asdf slime-fancy))

(require 'slime)
;; 日本語利用のための設定(emacsのデフォルトがutf-8ならutf-8-unix)

;;(setq inferior-lisp-program "sbcl")

;; ;; SBCL
;; (defun sbcl-start ()
;;   (interactive)
;;   (shell-command "sbcl --core ~/usr/lib/sbcl/sbcl.core --load ~/.slime.lisp &"))

(add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))
(add-hook 'slime-mode-hook
          (lambda ()
            (slime-mode t)
            (show-paren-mode 1)
            (define-key slime-mode-hook "\C-ci" 'hyperspec-lookup)
            (define-key lisp-mode-hook "\C-\\" 'ime-onoff-slime)
            (define-key lisp-mode-map (kbd "C-i") 'slime-fuzzy-complete-symbol)
            (setq slime-net-coding-system 'utf-8-unix
                  lisp-indent-function 'common-lisp-indent-function
                  slime-complete-symbol-function 'slime-fuzzy-complete-symbol
                  slime-log-events t
                  )))


;(slime-autodoc-mode)

;; ================ other slime setting from web ================
;;; SLIME
;; (require 'slime)
;; (setq slime-net-coding-system 'utf-8-unix)
;; (add-hook 'lisp-mode-hook (lambda ()
;;                             (slime-mode t)
;;                             (show-paren-mode)))
;; (add-hook 'slime-mode-hook
;;           (lambda ()
;;             (setq lisp-indent-function 'common-lisp-indent-function)))
;; (add-hook 'inferior-lisp-mode-hook
;;           (lambda ()
;;             (slime-mode t)
;;             (show-paren-mode)))
;; (setq inferior-lisp-program "/opt/local/bin/sbcl")

;; ;; Additional definitions by Pierpaolo Bernardi.
;; (defun cl-indent (sym indent)
;;   (put sym 'common-lisp-indent-function
;;        (if (symbolp indent)
;;            (get indent 'common-lisp-indent-function)
;;          indent)))

;; (cl-indent 'if '1)
;; (cl-indent 'generic-flet 'flet)
;; (cl-indent 'generic-labels 'labels)
;; (cl-indent 'with-accessors 'multiple-value-bind)
;; (cl-indent 'with-added-methods '((1 4 ((&whole 1))) (2 &body)))
;; (cl-indent 'with-condition-restarts '((1 4 ((&whole 1))) (2 &body)))
;; (cl-indent 'with-simple-restart '((1 4 ((&whole 1))) (2 &body)))

;; (setq slme-lisp-implementations
;;       '((sbcl ("sbcl") :coding-system utf-8-unix)
;;         (cmucl ("cmucl") :coding-system iso-latin-1-unix)))

;; ;; CMUCL
;; ;(defun cmucl-start ()
;; ;  (interactive)
;; ;  (shell-command ""))

;; ;; SBCL
;; (defun sbcl-start ()
;;   (interactive)
;;   (shell-command "sbcl --load $HOME/.slime.l &"))

;; ;; GNU CLISP
;; (defun clisp-start ()
;;   (interactive)
;;   (shell-command (format "clisp -K full -q -ansi -i %s/.slime.l &" (getenv "HOME"))))
