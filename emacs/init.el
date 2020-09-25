                                        ; Don't resize frame when font size changes
(setq frame-inhibit-implied-resize t
      frame-resize-pixelwise t)
                                        ; Hide unneeded UI elements
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

                                        ; Make custom-file a separate file not tracked by version control.
(setq custom-file "~/.config/emacs/custom.el")
(load custom-file 'noerror)

                                        ; Fonts
(defvar gam-font-family "Fira Code")
(defvar gam-font-size 120)
(set-face-attribute 'default nil
  :family gam-font-family
  :height gam-font-size
  :width 'normal
  :weight 'normal)

(set-face-attribute 'line-number-current-line nil
  :family gam-font-family
  :height gam-font-size
  :width 'expanded
  :weight 'normal
  :inverse-video nil)

                                        ; Save backups in temp file
(setq backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

                                        ; Bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

                                        ; Grab $PATH from shell configuration
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :init (setq exec-path-from-shell-check-startup-files nil
              exec-path-from-shell-shell-name "/usr/local/bin/zsh")
  :config
  (add-to-list 'exec-path-from-shell-variables "LC_COLORSCHEME_VARIANT")
  (exec-path-from-shell-initialize))

                                        ; Evil mode
(use-package evil-leader
    :config
    (evil-leader/set-leader "<SPC>")
    (global-evil-leader-mode)
    (evil-leader/set-key
      "." 'find-file))
(use-package evil
    :demand t
    :after evil-leader
    :defer 0.1
    :init
    (setq evil-search-module 'evil-search
          evil-ex-substitute-global t)
    :config
    (evil-mode 1))

(use-package evil-surround
    :after evil
    :config (global-evil-surround-mode 1))

                                        ; Sorting and Filtering
(use-package selectrum
  :config (selectrum-mode 1))
(use-package prescient)

(use-package selectrum-prescient
  :config
  (selectrum-prescient-mode)
  (prescient-persist-mode))

                                        ; Completion
(use-package company
  :delight company-mode
  :config
    (setq company-tooltip-limit 20
          company-tooltip-align-annotations t)
    )

                                        ; Theme
(use-package doom-themes
  :config
    (load-theme (intern (concat "doom-solarized-" (getenv "LC_COLORSCHEME_VARIANT"))))
    (doom-themes-visual-bell-config)
    (doom-themes-org-config))
(use-package doom-modeline
  :config (doom-modeline-mode))

                                        ; Folding
(use-package origami
  :hook (prog-mode . origami-mode))

                                        ; Display available binds
(use-package which-key
  :init (which-key-mode))

                                        ; Projects
(use-package perspective
  :config
    (evil-leader/set-key "B" 'persp-switch-to-buffer)
    (persp-mode))

(use-package persp-projectile
    :straight (persp-projectile
               :host github
               :repo "bbatsov/persp-projectile")
    :commands (projectile-persp-switch-project)
    :init (evil-leader/set-key "p" 'projectile-persp-switch-project))

(use-package projectile
  :delight projectile-mode
  :commands (projectile-switch-project projectile-find-file projectile-mode)
  :after evil-leader
  :init
    (setq projectile-completion-system 'default
          projectile-require-project-root nil
          projectile-git-command "fd . --print0 --color never"
          projectile-indexing-method 'alien
          projectile-project-search-path '("~/code"))
    (evil-leader/set-key
      evil-leader/leader 'projectile-find-file
      "," 'projectile-switch-to-buffer)
  :config
  (projectile-mode))

                                        ; Programming Mode Basics
(add-hook 'prog-mode-hook (function(lambda ()
  (show-paren-mode 1)
  (global-hl-line-mode 1)
  (display-line-numbers-mode)
  (column-number-mode)
  (company-mode)
  (add-hook 'before-save-hook 'delete-trailing-whitespace nil t)))
)
(setq initial-scratch-message ""                     ; disable the scratch message
      inhibit-startup-message t                      ; disable the startup screen
      scroll-conservatively 101                      ; move window one line at a time when point approaches edge
      scroll-margin 5                                ; start scrolling 5 lines from edge
      visible-bell t                                 ; Audible bell is cancer, but visible bell works okay
      ad-redefinition-action 'accept                 ; Tell emacs we're okay with functions being given advice
      vc-follow-symlinks t                           ; Follow symlinks to vcs controlled files
      mouse-drag-copy-region t                       ; highlighting a section causes it to get copied (linux default behavior)
)
(setq-default fill-column 80                         ; in fill-mode, what column do we wrap at?
              truncate-lines t                       ; disable line wrapping
              indent-tabs-mode nil                   ; use spaces over tabs everywhere
              tab-width 4                            ; but when encountering a tab, how large is it?
              tab-stop-list (number-sequence 3 120 2); and what are the tabstop points when shifting?
)

                                        ; Git
(use-package git-gutter
  :hook (prog-mode . git-gutter-mode)
  :init (setq git-gutter:update-interval 2))
(use-package magit
  :commands (magit-status)
  :hook (after-save . magit-after-save-refresh-status)
  :defer 5
  :init
    (evil-leader/set-key "g" 'magit)
    (setq magit-popup-show-common-commands nil
          magit-display-buffer-function 'magit-display-buffer-same-window-except-diff-v1))
(use-package evil-magit
  :after magit
  :init
  (setq evil-magit-want-horizontal-movement nil))

                                        ; Direnv
(use-package direnv
  :config (direnv-mode))

                                        ; Editorconfig
(use-package editorconfig
  :config (editorconfig-mode 1))

                                        ; Flycheck
(use-package flycheck
  :init
  (global-flycheck-mode)
  (evil-leader/set-key
    "l l" 'flycheck-list-errors
    "l n" 'flycheck-next-error
    "l p" 'flycheck-previous-error))

                                        ; Highlight TODO notes
(use-package fic-mode
  :commands (fic-mode)
  :init (setq fic-highlighted-words '("FIXME" "TODO" "BUG" "NOTE" "XXX"))
  :hook (prog-mode . fic-mode))

                                        ; Whitespace cleanup
(use-package ws-butler
  :hook (prog-mode . ws-butler-mode))

                                        ; Language Servers
(use-package lsp-mode
  :hook ((python-mode . lsp))
  :config (setq lsp-enable-snippet nil)
  :commands lsp
)
(use-package lsp-ui
  :init
    (setq lsp-ui-doc-enable t
          lsp-ui-doc-position "top"
          lsp-ui-sideline-show-hover t
          lsp-ui-sideline-show-diagnostics t)
  :commands lsp-ui-mode
  )

                                        ; Autoformatter
(use-package apheleia
  :straight (apheleia
             :host github
             :repo "raxod502/apheleia")
  :config (apheleia-global-mode 1))

                                        ; Python
(add-hook 'python-mode-hook
          (lambda ()
            (setq lsp-diagnostics-provider :none
                  flycheck-checker 'python-flake8)))

                                        ; YAML
(use-package yaml-mode
  :mode ("\\.yaml'" "\\.yml'"))

                                        ; Org Mode
(setq org-agenda-files '("~/org/"))

                                        ; Salt
(use-package salt-mode
  :mode ("\\.sls'"))
