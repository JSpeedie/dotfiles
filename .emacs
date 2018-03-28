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
;;
;; Notes:
;; C-h k <key series> to get documentation/name of function executed to key series
;; zM to close all folds works wonders in markdown mode
;; zR to open all folds

;;; Code:

;; ======================
;; = Disabled Defaults  =
;; ======================
;; Remove various bars from top of screen
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(setq inhibit-splash-screen t)
(setq inhibit-startup-screen t)

;; Add support for downloading and managing packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)
(package-refresh-contents)

;; Packages I use
(package-install 'evil)                     ;; For evil mode >:^]
(package-install 'evil-surround)            ;; For surrounding
                                            ;; add surrounding:
                                            ;; ys<text-obj> or yS<text-obj> in normal
                                            ;; change surrounding:
                                            ;; cs<old-text-obj><new-text-obj>
                                            ;; delete surrounding:
                                            ;; ds<text-obj>
(package-install 'flycheck)                 ;; For syntax checking
(package-install 'spacemacs-theme)          ;; For spacemacs colour theme
(package-install 'auto-complete)            ;; For tab completion
(package-install 'spaceline)                ;; For spacemacs themed mode line
(package-install 'telephone-line)           ;; For another nice mode line
(package-install 'ido-vertical-mode)        ;; For a nicer ido experience
(package-install 'switch-window)            ;; To make window navigation faster
(package-install 'markdown-mode)            ;; For markdown syntax highlighting
(package-install 'dashboard)                ;; For a start up dashboard

;; Add support for native vim C-u when editing
(setq-default evil-want-C-u-scroll t)
;; Add support for vim 'gn' motions when editing
(setq evil-search-module (quote evil-search))
;; Set scrolling past top or bottom of page to move only
;; one line instead of half a page
(setq scroll-conservatively 100)

;; ======================
;; = Dashboard settings =
;; ======================
(dashboard-setup-startup-hook)
(setq dashboard-items '((recents . 10)))
(setq dashboard-banner-logo-title "Welcome back, loser.")

;; ======================
;; =    Ido settings    =
;; ======================
;; Better searching. C-n and C-p for cycling through possible completions
(require 'ido)
(setq ido-enable-flex-matching nil)
(setq ido-create-new-buffer 'always)
(setq ido-everywhere t)
(ido-mode 1)
;;(use-package ido-vertical-mode
;;	:ensure t
;;	:init
;;	(ido-vertical-mode 1))
(ido-vertical-mode 1)
(setq ido-vertical-define-keys 'C-n-and-C-p-only)
;;(defun ido-my-keys ()
;;	"Zsh-like tab complete for ido."
;;	(define-key ido-completion-map " " 'ido-next-match))
;; ido buffer switching. *Much* better
(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)
;; Fix identation issue of mixing spaces and tabs, at least in C
(setq-default c-basic-offset 4
	tab-width 4
	indent-tabs-mode t)
;; Make flycheck look for include files in the current folder. Very useful
(defun my-c-mode-common-hook ()
	(setq flycheck-clang-include-path (list "..")))
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;; ===========================
;; = Better Window Splitting =
;; ===========================
;; Now splitting windows brings focus to the newly created window
(defun split-and-follow-horizontal ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x C-l") 'split-and-follow-horizontal)
(defun split-and-follow-vertical ()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x C-j") 'split-and-follow-vertical)
;; ==========================
;; = switch-window Settings =
;; ==========================
(require 'switch-window)
;; Remove surrounding square on chars
(setq switch-window-input-style 'minibuffer)
(setq switch-window-increase 2)
(setq switch-window-threshold 2)
(setq switch-window-shortcut-style 'qwerty)
(setq switch-window-qwerty-shortcuts
	  '("h" "j" "k" "l" "u" "i" "o" "p"))
(global-set-key (kbd "C-x o") 'switch-window)
(setq explicit-shell-file-name "/bin/bash")


;; ======================
;; = Mode Line settings =
;; ======================
(require 'spaceline-config)
(spaceline-spacemacs-theme)
;; (require 'telephone-line)
;; (telephone-line-mode 1)

(ac-config-default)                         ;; Setup auto-complete
(global-flycheck-mode)                      ;; Enable flycheck syntax checking
(global-linum-mode t)                       ;; Get line numbers
(global-evil-surround-mode 1)               ;; Enable evil-surround


;; Enable line numbers, add spacing
(setq linum-format " %d ")                  ;; Set line number format
(setq-default left-fringe-width 10)         ;; Set line number format spacing
(setq-default right-fringe-width 10)        ;; Set line number format spacing
(set-face-attribute 'fringe nil :background nil)

(setq-default indent-tabs-mode t)           ;; Default to use tabs
;;(local-set-key (kbd "TAB") (insert-char 9))
(global-set-key (kbd "TAB") (lambda () (interactive) (insert-char 9 1)))

;; Highlights tabs and trailing whitespace
;; face: necessary for any of the following ones to work
;; tabs: because I want to see where my tabs are
;; lines: for highlighting lines that are too long
;; trailing: for trailing whitespace
;; trailing-whitespace: for obvious reasons
;; tab-mark: for tabs I think
(setq-default whitespace-style (quote
	(face tabs tab-mark lines trailing trailing-whitespace)) )
(setq whitespace-display-mappings
	'(
		(space-mark 32 [183] [46])
		(newline-mark 10 [182 10])
		(tab-mark 9 [124 9] [92 9])
	))
(global-whitespace-mode t)

;; For setting colour of the matching paren. Currently unchanged
(require 'paren)
;; (set-face-background 'show-paren-match (face-background 'default))
;; (set-face-foreground 'show-paren-match "#def")
(set-face-background 'show-paren-match (face-foreground 'default))
(set-face-foreground 'show-paren-match (face-background 'default))
(set-face-attribute 'show-paren-match nil :weight 'extra-bold)
(show-paren-mode 1)                         ;; Show matching parens

(setq-default tab-width 4)                  ;; Better tabsize
(setq-default whitespace-line-column 80)    ;; Add warning for if a line goes
                                            ;; over 80 characters

;; ======================
;; = Evil mode settings =
;; ======================
(require 'evil)
;; Enable evil mode
(evil-mode 1)

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
	(markdown-mode switch-window ido-vertical-mode evil-surround spaceline auto-complete flycheck spacemacs-theme evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(provide 'emacs)
;;; .emacs ends here
