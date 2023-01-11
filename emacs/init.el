;;; package --- Summary
;;; Commentary:
;;; Code:
;; -*- lexical-binding: t -*-

(defvar gam-default-leader-key "<SPC>")

(set-face-attribute 'default nil :family "Fira Code")
(set-face-attribute 'line-number-current-line nil :family "Fira Code")

(setq default-frame-alist
      '((menu-bar-lines . 0)
        (tool-bar-lines . 0) 
        (vertical-scroll-bars . nil)))

(use-package general)

(use-package emacs
  :custom
  (custom-file null-device "disable customizations")
  (initial-scratch-message "" "disable the scratch message")
  (inhibit-startup-message t "disable the startup screen")
  (scroll-conservatively 101 "move window one line at a time when point approaches edge")
  (scroll-margin 5 "start scrolling 5 lines from edge")
  (visible-bell t "Audible bell is cancer, but visible bell works okay")
  (ad-redefinition-action 'accept "Tell emacs we're okay with functions being given advice")
  (select-enable-clipboard t "copy actions copy to clipboard")
  (select-enable-primary t "copy actions also copy to primary")
  (mouse-drag-copy-region t "highlighting a section causes it to get copied (linux default behavior)")
  (backup-directory-alist `((".*" . ,temporary-file-directory)) "Move backups to a temporary dir")
  (auto-save-file-name-transforms `((".*" ,temporary-file-directory t)) "Move auto saves to a temporary dir")
  (read-process-output-max (* 1024 1024) "Up amount of output we can read from a subprocess buffer; should improve LSP")
  (gc-cons-threshold 100000000 "Increase garbage collection-threshold")
  (frame-inhibit-implied-resize t)
  (frame-resize-pixelwise t)

  :init
  (global-hl-line-mode 1)
  (global-display-line-numbers-mode 1)

  (defun gam-prog-mode-setup ()
    (show-paren-mode 1)            ; highlight matching brackets
    (hs-minor-mode))               ; Add hide-show

  (defun gam-after-init-hook ()
    (defalias 'yes-or-no-p 'y-or-n-p)  ; I don't ever want to type out "yes" or "no" - even if it is important
    (global-unset-key (kbd "C-h h"))   ; I have *never* wanted to see the hello file.

    (setq-default
     fill-column 80                            ; in fill-mode, what column do we wrap at?
     truncate-lines t                          ; disable line wrapping
     indent-tabs-mode nil                      ; use spaces over tabs everywhere
     tab-width 4                               ; but when encountering a tab, how large is it?
     ))

  :general
  (:states 'normal
           :prefix gam-default-leader-key
           "." #'find-file
           "p" #'project-switch-project
           "b" #'project-switch-to-buffer
           gam-default-leader-key #'project-find-file)

  :hook
  (prog-mode . gam-prog-mode-setup)
  (after-init . gam-after-init-hook)
  (before-save . 'whitespace-cleanup))

(use-package textsize
  :defer nil
  :config (textsize-mode)
  :general
  ("s-=" 'textsize-increment)
  ("s-+" 'textsize-increment)
  ("s--" 'textsize-decrement)
  ("s-0" 'textsize-reset)
  )

(use-package doom-themes
  :defer nil
  :config
  (load-theme 'doom-solarized-light t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

(use-package auto-dark
  :after doom-themes
  :custom
  (auto-dark-dark-theme 'doom-solarized-dark)
  (auto-dark-light-theme 'doom-solarized-light)
  :init (auto-dark-mode))

(use-package doom-modeline
  :after evil
  :config (doom-modeline-mode))

(use-package evil
  :defer nil
  :custom
  (evil-undo-system 'undo-redo)
  (evil-want-keybinding nil)
  (evil-echo-state nil)
  (evil-want-integration t)
  :config (evil-mode 1)
  :general (:states 'normal "g r" 'xref-find-references))

(use-package evil-collection
  :after evil
  :config (evil-collection-init '(magit magit-todos consult)))

(use-package evil-surround
  :after evil
  :config (global-evil-surround-mode 1))

(use-package eldoc-box
  :hook (prog-mode . eldoc-box-hover-mode))

(use-package corfu
  :custom (corfu-auto t)
  :init (global-corfu-mode))

(use-package magit
  :defer nil
  :hook (after-save . magit-after-save-refresh-status)
  :general
  (:states 'normal
           :prefix gam-default-leader-key
           "g" 'magit)
  :custom
  (magit-popup-show-common-commands nil)
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  (git-commit-fill-column 72)
  (git-commit-summary-max-length 50))

(use-package git-gutter
  :hook (prog-mode . git-gutter-mode)
  :custom (git-gutter:update-interval 2))

(use-package git-gutter-fringe
  :config
  (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom))

(use-package direnv
  :config (direnv-mode))

(use-package fic-mode
  :custom (fic-highlighted-words '("FIXME" "TODO" "BUG" "NOTE" "XXX"))
  :hook (prog-mode . fic-mode))

(use-package which-key
  :config (which-key-mode 1))

(use-package yasnippet
  :hook (prog-mode . yas-minor-mode))

(use-package eglot
  :defer nil
  :custom (eglot-extend-to-xref t)
  :general
  (:states 'normal
           :prefix gam-default-leader-key
           "l a" 'eglot-code-actions
           "l h" 'eldoc
           "l l" 'eglot
           "l q" 'eglot-shutdown
           "l Q" 'eglot-reconnect
           "l r" 'eglot-rename
           "l =" 'eglot-format)
  :hook
  (python-mode . eglot-ensure)
  (rust-mode . eglot-ensure)
  (nix-mode . eglot-ensure))

(use-package sideline
  :hook (flymake-mode . sideline-mode))

(use-package sideline-flymake
  :custom
  (sideline-flymake-display-errors-whole-line 'line)
  (sideline-backends-right '((sideline-flymake . up))))

(use-package consult
  :general
  (:states 'normal
           :prefix gam-default-leader-key
           "/" 'consult-ripgrep)
  :custom
  (register-preview-delay 0)
  (register-preview-function #'consult-register-format)
  (xref-show-xrefs-function #'consult-xref)
  (xref-show-definitions-function #'consult-xref)
  :init
  (advice-add #'register-preview :override #'consult-register-preview)
  :config
  (consult-customize
   consult-theme
   :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-recent-file consult--source-project-recent-file consult--source-bookmark
   :preview-key (kbd "M-.")))

(use-package consult-project-extra)

(use-package project
  :defer nil
  :custom (project-switch-commands 'project-find-file)
  :config
    (cl-defmethod project-root ((project (head local))) (cdr project))
    (defun gam-project-find (dir)
    ;; https://michael.stapelberg.ch/posts/2021-04-02-emacs-project-override/
      (let ((local (locate-dominating-file dir ".project-root")))
        (if local
            (cons 'local local)
          nil)))
    ;; Can't use :hook as 'project-find-functions doesn't end in "-hook"
    (add-hook 'project-find-functions #'gam-project-find -90))

(use-package vertico
  :init (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :defer nil
  :general (:map minibuffer-local-map "M-A" 'marginalia-cycle)
  :init (marginalia-mode))

;; languages
(defun gam-before-save-format-buffer () (add-hook 'before-save-hook 'eglot-format-buffer nil t))

(use-package caddyfile-mode
  :mode ("Caddyfile'"))

(use-package cython-mode)

(use-package dockerfile-mode
  :mode ("Dockerfile"))

(use-package graphviz-dot-mode
  :mode ("\\.dot$"))

(use-package hcl-mode
  :mode ("\\.hcl$"))

(use-package markdown-mode
  :custom (markdown-command "pandoc")
  :mode (("\\.md'" . gfm-mode)))

(use-package nix-mode
  :hook (nix-mode . gam-before-save-format-buffer))

(use-package python
  ;; set ensure nil to use packaged version of python.el
  ;; rather than grabbing from elpa
  :ensure nil
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode)
  :hook (python-mode . gam-before-save-format-buffer))

(use-package rust-mode
  :mode ("\\.rs'")
  :hook (rust-mode . gam-before-save-format-buffer))

(use-package salt-mode
  :mode ("\\.sls'"))

(use-package yaml-mode
  :mode ("\\.yaml'" "\\.yml'"))

(use-package web-mode
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-code-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-attr-indent-offset 2)
  (web-mode-enable-css-colorization t)
  (web-mode-enable-current-column-highlight t)
  (web-mode-enable-auto-quoting nil))
;;; emacs.el ends here
