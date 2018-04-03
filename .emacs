;;; package --- Summary
;;; Commentary:

;;; Code:

;; Delay Garbage Collection to be every 8 million bytes
(setq gc-cons-threshold 800000000)

;; Package Manager
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)
(package-refresh-contents)

;; use-package Set Up
;; To make setting up other packages easier and more efficient
(package-install 'use-package)
(eval-when-compile
  (require 'use-package))
(package-initialize)

;; Load the real init file
(org-babel-load-file (expand-file-name "~/.emacs.d/init-config.org"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (spacemacs-dark)))
 '(custom-safe-themes
   (quote
	("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default)))
 '(font-use-system-font t)
 '(package-selected-packages
   (quote
	(company-irony-c-headers irony-eldoc dmenu use-package markdown-mode switch-window ido-vertical-mode evil-surround spaceline flycheck spacemacs-theme evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(provide 'emacs)
;;; .emacs ends here
