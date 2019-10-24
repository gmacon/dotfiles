;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(after! smartparens (smartparens-global-mode -1))
(add-hook! 'before-save-hook 'doom/delete-trailing-newlines 'delete-trailing-whitespace)
