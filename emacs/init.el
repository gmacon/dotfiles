                                        ; Don't resize frame when font size changes
(setq frame-inhibit-implied-resize t
      frame-resize-pixelwise t
                                        ; This is inferred as just "Macon", thanks, Microsoft
      user-full-name "George Macon")
                                        ; Hide unneeded UI elements
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

                                        ; Make custom-file a separate file not tracked by version control.
(setq custom-file "~/.config/emacs/custom.el")
(load custom-file 'noerror)

                                        ; Fonts
(defvar gam/font-family "Fira Code")
(defvar gam/font-size 120)
(set-face-attribute 'default nil
  :family gam/font-family
  :height gam/font-size
  :width 'normal
  :weight 'normal)

(set-face-attribute 'line-number-current-line nil
  :family gam/font-family
  :height gam/font-size
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

                                        ; Avoid bad tramp-zsh interaction
                                        ; Note: this depends on the zsh/zshrc handling
(setq tramp-terminal-type "tramp")

                                        ; Grab $PATH from shell configuration
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :init (setq exec-path-from-shell-check-startup-files nil
              exec-path-from-shell-shell-name "/bin/zsh")
  :config
  (add-to-list 'exec-path-from-shell-variables "LC_COLORSCHEME_VARIANT")
  (exec-path-from-shell-initialize))

                                        ; Evil mode
(use-package undo-tree
  :config (global-undo-tree-mode))
(use-package evil-leader
    :config
    (evil-leader/set-leader "<SPC>")
    (global-evil-leader-mode)
    (evil-leader/set-key
      "." 'find-file
      "b" 'switch-to-buffer))
(use-package evil
    :demand t
    :after evil-leader
    :defer 0.1
    :init
    (setq evil-search-module 'evil-search
          evil-ex-substitute-global t)
    :config
    (evil-set-undo-system 'undo-tree)
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
(defun gam/macos-responsive-theme (appearance)
  "Change theme based on system APPEARANCE."
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (load-theme 'doom-solarized-light))
    ('dark (load-theme 'doom-solarized-dark))))
(use-package doom-themes
  :init (setq doom-solarized-dark-brighter-comments t)
  :config
  (if (memq window-system '(mac ns))
      (add-hook 'ns-system-appearance-change-functions #'gam/macos-responsive-theme)
    (load-theme (intern (concat "doom-solarized-" (getenv "LC_COLORSCHEME_VARIANT")))))
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
  :init (setq persp-show-modestring nil)
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
          projectile-git-command "fd . --hidden --exclude=.git --print0 --color never"
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
  :hook
  ((python-mode . lsp)
   (rust-mode . lsp)
   (lsp-before-initialize . gam/lsp-setup))
  :config
  (defun gam/lsp-setup()
    (lsp-register-custom-settings
     '(("pyls.plugins.pyls_black.enabled" t t)
       ("pyls.plugins.pyls_isort.enabled" t t)))
    (setq lsp-enable-snippet nil
          lsp-pyls-plugins-flake8-enabled t
          lsp-pyls-configuration-sources ["flake8"]
          lsp-pyls-plugins-autopep8-enabled nil
          lsp-pyls-plugins-pycodestyle-enabled nil
          lsp-pyls-plugins-mccabe-enabled nil
          lsp-pyls-plugins-pyflakes-enabled nil))
  :commands lsp
)
(use-package lsp-ui
  :config
  (defun gam/lsp-ui-setup()
    (lsp-headerline-breadcrumb-mode -1)
    (setq lsp-ui-doc-enable t
          lsp-ui-doc-position "top"
          lsp-ui-sideline-show-hover t
          lsp-ui-sideline-show-diagnostics t))
  :commands lsp-ui-mode
  :hook (lsp-before-initialize . gam/lsp-ui-setup)
  )

                                        ; Python
(use-package cython-mode)
(add-hook
 'python-mode-hook
 (lambda ()
   (add-hook 'before-save-hook 'lsp-format-buffer nil t)))

                                        ; YAML
(use-package yaml-mode
  :mode ("\\.yaml'" "\\.yml'"))

                                        ; Org Mode
(setq org-agenda-files '("~/org/"))

                                        ; Salt
(use-package salt-mode
  :mode ("\\.sls'"))

                                        ; The World Wide Web
(use-package web-mode
  :mode ("\\.jsx?$" "\\.tsx?$" "\\.html$" "\\.css$")
  :init
    (setq web-mode-markup-indent-offset 2
          web-mode-code-indent-offset 2
          web-mode-css-indent-offset 2
          web-mode-attr-indent-offset 2
          web-mode-enable-css-colorization t
          web-mode-enable-current-column-highlight t
          web-mode-enable-auto-quoting nil
    ))

                                        ; Caddyfile
(use-package caddyfile-mode
  :mode ("Caddyfile'"))

                                        ; Dockerfile
(use-package dockerfile-mode
  :mode ("Dockerfile"))

                                        ; Rust
(use-package rust-mode
  :mode ("\\.rs$"))
