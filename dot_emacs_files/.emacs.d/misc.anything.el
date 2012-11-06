;; anything
(add-to-list 'load-path "~/.emacs.d/lisp/anything")
(require 'anything-config)
(require 'anything-etags)

;; [05/15/2009]
(setq anything-idle-delay 0.3)
(setq anything-candidate-number-limit 100)
;; (setq anything-c-locate-db-file "/log/home.simple.locatedb")
;; (setq anything-c-locate-options `("locate" "-d" ,anything-c-locate-db-file "-i" "-r" "--"))

(setq anything-sources (list anything-c-source-buffers
                             anything-c-source-bookmarks
                             anything-c-source-recentf
                             anything-c-source-file-name-history
                             anything-c-source-locate
                             anything-c-source-complex-command-history
                             anything-c-source-file-cache))
(define-key anything-map (kbd "C-p") 'anything-previous-line)
(define-key anything-map (kbd "C-n") 'anything-next-line)
(define-key anything-map (kbd "C-v") 'anything-next-source)
(define-key anything-map (kbd "M-v") 'anything-previous-source)
(global-set-key (kbd "C-:") 'anything)

(require 'descbinds-anything)
(descbinds-anything-install)

;;[05/01/2009]
(require 'anything-yaetags)
(add-to-list 'anything-sources 'anything-c-source-yaetags-select)
;;(global-set-key (kbd "M-.") 'anything-yaetags-find-tag)

;;[05/03/2009]
(require 'ac-anything)
(define-key ac-complete-mode-map (kbd "C-:") 'ac-complete-with-anything)

;;[05/04/2009]
(require 'anything-complete)
(anything-lisp-complete-symbol-set-timer 150)
(anything-read-string-mode 1)

;;[05/07/2009]
(require 'anything-dabbrev-expand)
(global-set-key "\M-/" 'anything-dabbrev-expand)
(define-key anything-dabbrev-map "\M-/" 'anything-dabbrev-find-all-buffers)

;;(require 'anything-rcodetools)
;; Command to get all RI entries.
(setq rct-get-all-methods-command "PAGER=cat fri -l")
;; See docs
(define-key anything-map "\C-z" 'anything-execute-persistent-action)

;; [05/07/2009]
;; http://d.hatena.ne.jp/rubikitch/20071228/anythingpersistent
;; this function is not kill anything-buffer when command is executed
(defun anything-execute-persistent-action ()
  "If a candidate was selected then perform the associated action without quitting anything."
  (interactive)
  (save-selected-window
    (select-window (get-buffer-window anything-buffer))
    (select-window (setq minibuffer-scroll-window
                         (if (one-window-p t) (split-window) (next-window (selected-window) 1))))
    (let* ((anything-window (get-buffer-window anything-buffer))
           (selection (if anything-saved-sources
                          ;; the action list is shown
                          anything-saved-selection
                        (anything-get-selection)))
           (default-action (anything-get-action))
           (action (assoc-default 'persistent-action (anything-get-current-source))))
      (setq action (or action default-action))
      (if (and (listp action)
               (not (functionp action)))  ; lambda
        ;; select the default action
          (setq action (cdar action)))
      (set-window-dedicated-p anything-window t)
      (unwind-protect
          (and action selection (funcall action selection))
        (set-window-dedicated-p anything-window nil)))))
(define-key anything-map "\C-z" 'anything-execute-persistent-action)
