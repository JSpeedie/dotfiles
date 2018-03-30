;;; package --- Summary
;;; Commentary:

;; TODO:
;; 1. Get line numbers padded and right justified
;; 2. disable mouse
;; 3. Get tab autocomplete for M-x and etc to be like zsh
;; [DONE] [y in evil mode, C-k in emacs] 4a. Get copy working
;; [DONE] [p in evil mode, C-y in emacs] 4b. Get paste working
;; 5. Get ctrl - a working as increment number not beginning of life
;; 6. Get actual colour column not some dumb line highlight
;; 7. Fix dumb tab thing where hitting enter to break a line makes last
;;        level of indentation like 2 spaces instead of a tab
;; 8. Fix thing where backspacing a tab creates 4 spaces which then have to
;;         be backspaced too
;; [DONE] 9. Change tab symbols
;; 10. Change font to hermit or tamzen?
;; 11. Speed up macro execution?
;; 12. Show file name after write, regardless of if there are changes to be saved
;; [DONE] 13. get 'gn' motions working
;; [TEMP] 14. Non eletric tab. Only inserts tabs
;; [DONE] 15. Make j at bottom of screen or k at top of screen not move up half a page at a time
;; 16. Fix * and # just doing w and not like W
;; 17. Fix terminal to be bash and make shortcut for opening it
;; 18. Block style cursor in insert mode?
;; 19. Consider learning and installing avy?
;; 20. Get ansi-term working properly
;;     20a. Typing and backspacing and entering runs all
;;     20b. Vim is broke
;;     20c. Colours for prompt don't work
;;     20d. Check Uncle Dave's guide on ansi-term
;; 21. Fix .emacs to make functional emacs after 1 run, not 3
;; 22. Fix ability to resize cleanly with mouse. Probably fixed once
;;         mouse is disabled
;; 23. Install and config company? Uncle Dave ep. 12 for more info
;; 24. Fix .emacs so that it doesn't take 3 runs to get
;;         functioning emacs install
;; 25. No confirmation when making a new file
;; [DONE] 26. Setup Org bullets
;;
;; Notes:
;; C-h k <key series> to get documentation/name of function executed to key series
;; zM to close all folds works wonders in markdown mode
;; zR to open all folds

;;; Code:

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
	(dmenu telephone-line use-package markdown-mode switch-window ido-vertical-mode evil-surround spaceline auto-complete flycheck spacemacs-theme evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(provide 'emacs)
;;; .emacs ends here
