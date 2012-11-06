;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; gauche (scheme)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq load-path (append (list "~/.emacs.d/lisp/gauche/") load-path))

(require 'gauche-mode)
(setq process-coding-system-alist
          (cons '("gosh" utf-8 . utf-8) process-coding-system-alist))

(setq auto-mode-alist
      (cons (cons "\\.scm$" 'gauche-mode) auto-mode-alist))

;; where gosh bin is
(setq scheme-program-name "/usr/bin/gosh -i ~/scripts/tgosh.scm")
;(autoload 'scheme-mode "cmuscheme" "Major mode for Scheme." t)
(autoload 'run-scheme "cmuscheme" "Run as inferior Scheme process." t)
(autoload 'gauche-mode "gauche-mode" "A mode for editing Gauche Scheme codes in Emacs" t)

;; separate window one for eval buffer
(defun scheme-other-window ()
  "Run scheme on other window"
  (inteactive)
  (switch-to-buffer-other-window
   (get-buffer-create "*scheme*"))
  (run-scheme scheme-program-name))

(defun scheme-other-frame ()
  "Run scheme on other frame"
  (interactive)
  (switch-to-buffer-other-frame
   (get-buffer-create "*scheme*"))
  (run-scheme scheme-program-name))

(defun run-scheme-run (place)
  (concat "Run scheme on other " place)
  (interactive)
  (make-symbol (concat "switch-to-buffer-other-" place)
;;  (switch-to-buffer-other-frame
   (get-buffer-create "*scheme*"))
  (run-scheme scheme-program-name))

(defun gauche-info ()
  (interactive)
  (switch-to-buffer-other-frame
   (get-buffer-create "*info*"))
  (info
   "/usr/share/info/gauche-refj.info.gz"))

;; (define-key global-map
;;   "\C-cs"
;;   ;;  'scheme-other-window)
;;   (run-scheme-run "window")

(define-key global-map
  "\C-cs"
   'scheme-other-window)

(define-key global-map
  "\C-xs" 'scheme-other-frame)

;; (define-key global-map
;;   "\C-ci" 'gauche-info)

(show-paren-mode t)

(add-hook 'gauche-mode-hook
          '(lambda()
          (define-key gauche-mode-map "\C-ci" 'info-lookup-symbol)
             (show-paren-mode t)
             (show-whitespace)))

;; (custom-set-variables
;;  '(file-coding-system-alist
;;    (cons
;;     (quote ("gauche-refj\\.info.*\\'" utf-8 . utf-8))
;;     file-coding-system-alist)))

;; indent defanition
(put 'and-let* 'scheme-indent-function 1)
(put 'begin0 'scheme-indent-function 0)
(put 'call-with-client-socket 'scheme-indent-function 1)
(put 'call-with-input-conversion 'scheme-indent-function 1)
(put 'call-with-input-file 'scheme-indent-function 1)
(put 'call-with-input-process 'scheme-indent-function 1)
(put 'call-with-input-string 'scheme-indent-function 1)
(put 'call-with-iterator 'scheme-indent-function 1)
(put 'call-with-output-conversion 'scheme-indent-function 1)
(put 'call-with-output-file 'scheme-indent-function 1)
(put 'call-with-output-string 'scheme-indent-function 0)
(put 'call-with-temporary-file 'scheme-indent-function 1)
(put 'call-with-values 'scheme-indent-function 1)
(put 'dolist 'scheme-indent-function 1)
(put 'dotimes 'scheme-indent-function 1)
(put 'if-match 'scheme-indent-function 2)
(put 'let*-values 'scheme-indent-function 1)
(put 'let-args 'scheme-indent-function 2)
(put 'let-keywords* 'scheme-indent-function 2)
(put 'let-match 'scheme-indent-function 2)
(put 'let-optionals* 'scheme-indent-function 2)
(put 'let-syntax 'scheme-indent-function 1)
(put 'let-values 'scheme-indent-function 1)
(put 'let/cc 'scheme-indent-function 1)
(put 'let1 'scheme-indent-function 2)
(put 'letrec-syntax 'scheme-indent-function 1)
(put 'make 'scheme-indent-function 1)
(put 'multiple-value-bind 'scheme-indent-function 2)
(put 'match 'scheme-indent-function 1)
(put 'parameterize 'scheme-indent-function 1)
(put 'parse-options 'scheme-indent-function 1)
(put 'receive 'scheme-indent-function 2)
(put 'rxmatch-case 'scheme-indent-function 1)
(put 'rxmatch-cond 'scheme-indent-function 0)
(put 'rxmatch-if  'scheme-indent-function 2)
(put 'rxmatch-let 'scheme-indent-function 2)
(put 'syntax-rules 'scheme-indent-function 1)
(put 'unless 'scheme-indent-function 1)
(put 'until 'scheme-indent-function 1)
(put 'when 'scheme-indent-function 1)
(put 'while 'scheme-indent-function 1)
(put 'with-builder 'scheme-indent-function 1)
(put 'with-error-handler 'scheme-indent-function 0)
(put 'with-error-to-port 'scheme-indent-function 1)
(put 'with-input-conversion 'scheme-indent-function 1)
(put 'with-input-from-port 'scheme-indent-function 1)
(put 'with-input-from-process 'scheme-indent-function 1)
(put 'with-input-from-string 'scheme-indent-function 1)
(put 'with-iterator 'scheme-indent-function 1)
(put 'with-module 'scheme-indent-function 1)
(put 'with-output-conversion 'scheme-indent-function 1)
(put 'with-output-to-port 'scheme-indent-function 1)
(put 'with-output-to-process 'scheme-indent-function 1)
(put 'with-output-to-string 'scheme-indent-function 1)
(put 'with-port-locking 'scheme-indent-function 1)
(put 'with-string-io 'scheme-indent-function 1)
(put 'with-time-counter 'scheme-indent-function 1)
(put 'with-signal-handlers 'scheme-indent-function 1)
(put 'with-locking-mutex 'scheme-indent-function 1)
(put 'guard 'scheme-indent-function 1)

(require 'gca)
;; C-c C-uで(use module)をインサートする
(define-key scheme-mode-map "\C-c\C-u" 'gca-insert-use)
(let ((m (make-sparse-keymap)))
  ;; C-c C-d h でドキュメントを検索する
  (define-key m "h" 'gca-show-info)
  ;; C-c C-d i でauto-info-modeの切り替えを行う。(ONの場合自動的にinfoを表示します)
  (define-key m "i" 'auto-info-mode)
  (define-key scheme-mode-map "\C-c\C-d" m))
;; C-c C-,でinfoの次のトピックを表示します(検索結果が複数あった場合)
(define-key scheme-mode-map [(control c) (control ,)] 'gca-info-next)
;; C-. でシンボルを補完する
(define-key scheme-mode-map [(control .)] 'gca-completion-current-word)
;; C-c C-. でコードのひな形をインサートする
(define-key scheme-mode-map [(control c) (control .)] 'gca-insert-template)
(define-key c-mode-map [(control c) (control .)] 'gca-insert-template)
;; C-c t でテストケースをインサートする (run-schemeでtgosh.scmを使う必要があります)
;; C-u で引数を与えると、その番号で実行された結果をもとにしてテストケースを作成します。
;; 省略時は直前の実行結果が使われます。
(define-key scheme-mode-map "\C-ct" 'gca-make-test)
;; C-c h で履歴をみる (run-schemeでtgosh.scmを使う必要があります)
(define-key scheme-mode-map "\C-ch" 'gca-show-history)


;; kahau
;; (require 'kahua)
;; (setq auto-mode-alist
;;        (append '(("\\.kahua$" . kahua-mode)) auto-mode-alist))
;; (setq kahua-site-bundle (expand-file-name "~/my_project/kahua/site"))
