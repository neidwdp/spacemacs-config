;;; funcs.el --- ztlevi layer packages file for Spacemacs.
;;
;; Copyright (c) 2016-2017 ztlevi
;;
;; Author: ztlevi <zhouting@umich.edu>
;; URL: https://github.com/ztlevi/spacemacs-config
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; Utility functions
(defun bb/define-key (keymap &rest bindings)
  (declare (indent 1))
  (while bindings
    (define-key keymap (pop bindings) (pop bindings))))

(defun insert-4-spaces ()
  (interactive)
  (insert "    "))

(defun ztlevi/toggle-major-mode ()
  (interactive)
  (if (eq major-mode 'fundamental-mode)
      (set-auto-mode)
    (fundamental-mode)))
(spacemacs/set-leader-keys "otm" 'ztlevi/toggle-major-mode)

;; (defadvice quit-window (before quit-window-always-kill)
;;   "When running `quit-window', always kill the buffer."
;;   (ad-set-arg 0 t))
;; (ad-activate 'quit-window)

;; Delete frame if solo window
(defun delete-window-or-frame (&optional window frame force)
  (interactive)
  (if (= 1 (length (window-list frame)))
      (delete-frame frame force)
    (delete-window window)))
