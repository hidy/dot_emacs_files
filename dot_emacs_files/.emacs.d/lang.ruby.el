;; add directory with extra ruby el-files
(setq load-path
      (append (list "~/.emacs.d/lisp/ruby/"
                    "~/.emacs.d/lisp/ruby/emacs-rails/")
              load-path))

;; ruby-mode
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(setq auto-mode-alist
      (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
                                     interpreter-mode-alist))
(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
          '(lambda () (inf-ruby-keys)))

;; ruby-electric
(require 'ruby-electric)
(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))

;; rubydb
(autoload 'rubydb "rubydb3x"
  "run rubydb on program file in buffer *gud-file*.
the directory containing file becomes the initial working directory
and source-file directory for your debugger." t)

;; rails
(defun try-complete-abbrev (old)
  (if (expand-abbrev) t nil))
(setq hippie-expand-try-functions-list
      '(try-complete-abbrev
        try-complete-file-name
        try-expand-dabbrev))
(setq rails-use-mongrel t)
(require 'cl)
(require 'rails)

;; ruby-block
(require 'ruby-block)
(ruby-block-mode t)
;; ミニバッファに表示し, かつ, オーバレイする.
(setq ruby-block-highlight-toggle t)

;; rcodetools
(require 'rcodetools)

;; ECB
;;(setq load-path (cons (expand-file-name "~/elisp/ecb-2.32") load-path))
;;(load-file "~/elisp/cedet-1.0pre3/common/cedet.el")
;; (setq semantic-load-turn-useful-things-on t)
;; (require 'ecb)
;; (setq ecb-tip-of-the-day nil)
;; (setq ecb-windows-width 0.25)
;; (defun ecb-toggle ()
;;   (interactive)
;;   (if ecb-minor-mode
;;       (ecb-deactivate)
;;     (ecb-activate)))
;; (global-set-key [f2] 'ecb-toggle)
