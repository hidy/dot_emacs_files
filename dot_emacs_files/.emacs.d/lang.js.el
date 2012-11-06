;; js2-mode
(add-to-list 'load-path "~/.emacs.d/lisp/javascript")
(autoload 'js2-mode "js2" nil t)
;;(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(setq-default c-basic-offset 4)
(when (load "js2" t)
  (setq js2-cleanup-whitespace nil
        ;;js2-mirror-mode nil     ;;autoinput closed paren(default t)
        js2-bounce-indent-flag nil)
  (defun indent-and-back-to-indentation ()
    (interactive)
    (indent-for-tab-command)
    (let ((point-of-indentation
           (save-excursion
             (back-to-indentation)
             (point))))
      (skip-chars-forward "\s " point-of-indentation)))
  (define-key js2-mode-map "\C-i" 'indent-and-back-to-indentation)
  (define-key js2-mode-map "\C-m" nil)
  (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode)))
