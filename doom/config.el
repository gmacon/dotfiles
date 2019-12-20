;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq doom-font (font-spec :family "Fira Code" :size 13))
(setq tramp-terminal-type "tramp")

(after! smartparens (smartparens-global-mode -1))

(setq-hook! python-mode fill-column 72)
(setq-hook! js2-mode js2-basic-offset 2)

(map! :leader
      (:prefix-map ("l" . "jump")
        :desc "Next error" "n" #'flycheck-next-error
        :desc "Prev error" "p" #'flycheck-previous-error)
      (:prefix-map ("p" . "project")
        :desc "ripgrep" "g" #'+ivy/project-search))
