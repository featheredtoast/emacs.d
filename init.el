;;; I'm a dog using emacs. HALP! I don't know what I'm doing.

;; Yay packages!
(require 'package)
;; Do I need these other repos? Who knows!
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ;;("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(setq use-package-always-ensure t
      use-package-verbose t)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(use-package zenburn-theme
  :config (load-theme 'zenburn t))

(use-package nyan-mode
  :config (nyan-mode t))

(use-package super-save
  :diminish ""
  :config (super-save-mode +1))

;; Thanks, technomancy! (https://github.com/technomancy/emacs-starter-kit/)
(use-package better-defaults)
;; And, as per suggestion 1
;;(use-package ido-hacks)
;; And, as per suggestion 2
;;(setq ido-use-virtual-buffers t)
;; And, as per suggestion 3
;;(use-package smex)
;;(smex-initialize)
;;(global-set-key (kbd "M-x") 'smex)
;;(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
;;(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(use-package helm
  :diminish ""
  :bind (("M-x" . helm-M-x)
         ("M-y" . helm-show-kill-ring)
         ("C-x b" . helm-mini)
         ("C-x C-f" . helm-find-files)
         ("C-c h" . helm-command-prefix)
         ("C-h SPC" . helm-all-mark-rings))
  :config
  ;; Thanks, https://tuhdo.github.io/helm-intro.html
  (require 'helm-config)
  (global-unset-key (kbd "C-x c"))
  (global-set-key (kbd "C-c h o") 'helm-occur)
  (helm-mode t))

(use-package helm-projectile
  :config
  (setq projectile-completion-system 'helm)
  (helm-projectile-on))

(use-package helm-descbinds
  :config (helm-descbinds-mode))

;; As per suggestion 4
;;(use-package ido-ubiquitous)
;;(ido-ubiquitous)

;; As per suggestion 5
(use-package paredit
  :init (add-hook 'emacs-lisp-mode-hook 'paredit-mode)
  :commands paredit-mode
  :diminish "()"
  :config
  (define-key paredit-mode-map (kbd "M-{") 'paredit-wrap-curly)
  (define-key paredit-mode-map (kbd "M-[") 'paredit-wrap-square))

;; As per suggestion 6
(use-package idle-highlight-mode
  :config
  (defun my-coding-hook ()
    (make-local-variable 'column-number-mode)
    (column-number-mode t)
    (if window-system (hl-line-mode t))
    (idle-highlight-mode t))

  (add-hook 'prog-mode-hook 'my-coding-hook))

(use-package cider
  :commands (cider-jack-in cider-connect)
  :config
  (add-hook 'cider-connected-hook
            (lambda ()
              (alert "Clojure REPL connected"
                     :title "CIDER")))
  (add-hook 'cider-test-report-mode-hook
            (lambda ()
              (alert "Finished running test(s)"
                     :title "CIDER")))
  (setq cider-repl-pop-to-buffer-on-connect nil)
  (setq cider-test-show-report-on-success t)
  (use-package clj-refactor))
(use-package clojure-mode
  :config
  (add-hook 'clojure-mode-hook 'paredit-mode)
  (add-hook 'cider-repl-mode-hook #'paredit-mode)
  (add-hook 'cider-repl-mode-hook #'rainbow-delimiters-mode)
  (add-to-list 'compilation-error-regexp-alist-alist
               '(lein-test
                 "^FAIL in (.+) (\\(.+\\):\\([0-9]+\\))$"
                 1
                 2
                 nil))
  (add-to-list 'compilation-error-regexp-alist 'lein-test))

(use-package anzu
  :diminish ""
  :config (global-anzu-mode t))

;; colorcolumn/row?
;; relativenumber?
;; tabbar
(setq scroll-margin 1)
;; pre-save delete-trailing-whitespace
;; auto-resize splits

(use-package projectile
  :config
  (projectile-global-mode t)
  (setq projectile-use-git-grep t)
  (setq projectile-switch-project-action 'projectile-vc))
;; Welcome screen begone!
(setq inhibit-startup-message t)

;; sudo-write
(add-to-list 'tramp-default-proxies-alist
             '(nil "root" "/ssh:%h:"))
(add-to-list 'tramp-remote-path 'tramp-own-remote-path)
(use-package markdown-mode)
;; erlang-mode?
(use-package magit
  :bind ("C-c g" . magit-status)
  :config (setq magit-branch-prefer-remote-upstream '("master" "develop")))

(use-package magithub
  :after magit)

(use-package tex-site
  :ensure auctex)

(use-package exec-path-from-shell
  :config (when (memq window-system '(mac ns))
            (exec-path-from-shell-initialize)))

;; tagbar
;; surround -- change balanced pairs
;; unimpaired?
;; nerdtree
;; speeddating

(use-package rainbow-delimiters
  :config (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

;; look at evil-jumper
(use-package evil
  :disabled t)

(use-package smartparens-config
  :ensure smartparens
  :commands turn-on-smartparens-strict-mode
  :init (sp-use-paredit-bindings)
  :bind (:map smartparens-strict-mode-map
              ("M-J" . sp-join-sexp)
              ("]" . sp-up-sexp)))

(use-package js2-mode
  :mode "\\.js$"
  :config (setq js2-basic-offset 4)

  (add-hook 'js2-mode-hook
            'turn-on-smartparens-strict-mode)

  (use-package js2-refactor
    :config
    (require 'js2-refactor)
    (add-hook 'js2-mode-hook #'js2-refactor-mode)
    (js2r-add-keybindings-with-prefix "C-c C-m")))

(use-package handlebars-mode)

(use-package web-mode
  :mode "\\.php$"
  :config (setq default-tab-width 4)

  (add-hook 'web-mode-hook
            'turn-on-smartparens-strict-mode))

(use-package expand-region
  :bind ("C-=" . er/expand-region)
  :config (pending-delete-mode t))

(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)
         ("M-S-<mouse-1>" . mc/add-cursor-on-click)))

(use-package company
  :diminish ""
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (global-set-key (kbd "TAB") #'company-indent-or-complete-common))

(use-package graphviz-dot-mode
  :mode ("\\.dot$" "\\.gv$"))

(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
(add-hook 'cider-mode-hook 'eldoc-mode)
(setq eldoc-idle-delay 0.1)

(setq-default indent-tabs-mode nil)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(use-package gist)

(use-package rainbow-identifiers
  :config (add-hook 'prog-mode-hook 'rainbow-identifiers-mode))

(use-package docker-tramp
  :config (setq docker-tramp-use-names t))

(use-package undo-tree
  :diminish ""
  :config (global-undo-tree-mode t))

(use-package yasnippet
  :diminish (yas-minor-mode "")
  :config (yas-global-mode t))

(setq visible-bell nil)

(setq save-interprogram-paste-before-kill t)

(use-package yaml-mode
  :mode "\\.yml$")

(use-package maxframe
  :if (string-equal (window-system) "ns")
  :config
  (add-hook 'window-setup-hook 'toggle-frame-fullscreen t)
  (set-face-attribute 'default nil :height 140))


(use-package scala-mode
  :mode "\\.scala$")

(use-package n4js
  :commands n4js-start
  :config (setq n4js-cli-arguments '("-port" "5555")))

(use-package whitespace
  :init
  (dolist (hook '(prog-mode-hook text-mode-hook))
    (add-hook hook #'whitespace-mode))
  ;;(add-hook 'before-save-hook #'whitespace-cleanup)
  :config
  (setq whitespace-line-column 80) ;; limit line length
  (setq whitespace-style '(face tabs empty trailing lines-tail)))

(use-package alert
  :commands alert
  :config
  (setq alert-default-style 'notifier))

(use-package compile
  :defer t
  :config
  (use-package ansi-color)
  (add-hook 'compilation-filter-hook
            (lambda ()
              (when (eq major-mode 'compilation-mode)
                (interactive)
                (ansi-color-apply-on-region compilation-filter-start (point-max)))))
  (eval-when-compile
    (defvar exit-status))
  (add-hook 'compilation-finish-functions
            (lambda (buf why)
              (display-buffer buf)
              (if (> exit-status 0)
                  (alert "Compilation finished with errors"
                         :severity 'high)
                (alert "Compilation finished" :buffer buf))))
  (add-to-list 'compilation-error-regexp-alist-alist
               '(mocha-test
                 "^at .* (\\(.+\\):\\([0-9]+\\):\\([0-9]+\\))$"
                 1
                 2
                 3))
  (add-to-list 'compilation-error-regexp-alist 'mocha-test))

(setq web-mode-enable-auto-indentation nil)
