;;
;; flymake-php.el
;; 
;; Made by ht User
;; Login   <ht@ubuntu.intra.pc-seibishi.org>
;; 
;; Started on  Wed Sep  3 17:10:30 2008 ht User
;; Last update Wed Sep  3 17:28:34 2008 ht User
;;

;; Flymake PHP Extension
(require 'flymake)

(defconst flymake-allowed-php-file-name-masks '(
                                               (".php3'" flymake-php-init)
                                               (".inc'" flymake-php-init)
                                               (".php'" flymake-php-init))
"Filename extensions that switch on flymake-php mode syntax checks")

    (defconst flymake-php-err-line-pattern-re '("(Parse|Fatal) error: (.*) in (.*) on line ([0-9]+)" 3 4 nil 2)
      "Regexp matching PHP error messages")

    (defun flymake-php-init ()
      (let* ((temp-file       (flymake-init-create-temp-buffer-copy
                               'flymake-create-temp-inplace))
             (local-file  (file-relative-name
                           temp-file
                           (file-name-directory buffer-file-name))))
        (list "php" (list "-f" local-file "-l"))))

    (defun flymake-php-load ()
      (setq flymake-allowed-file-name-masks (append flymake-allowed-file-name-masks flymake-allowed-php-file-name-masks))
      (setq flymake-err-line-patterns (cons flymake-php-err-line-pattern-re flymake-err-line-patterns))
      (flymake-mode t)
      (local-set-key "C-cd" 'flymake-display-err-menu-for-current-line))

    (provide 'flymake-php)

