;;; packages.el --- erlang_ts layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2021 Sylvain Benner & Contributors
;;
;; Author: datttn <datttn.work@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(defconst erlang_ts-packages
  '(
    company
    erlang
    ;; my edts
    (edts :location (recipe
                     :fetcher github
                     :repo "datttnwork7247/edts"
                     :files ("*")
                     ))
    flycheck
    ;; my erl-trace
    (erl-trace :location (recipe
                        :fetcherer github
                        :repo "datttnwork7247/erl-trace"
                        :file ("*")
                        ))
    )
  )

(defun erlang_ts/post-init-company ()
  ;; backend specific
  (add-hook 'erlang-mode-local-vars-hook #'spacemacs//erlang-setup-company))

(defun erlang_ts/init-erlang ()
  (use-package erlang
    :defer t
    ;; explicitly run prog-mode hooks since erlang mode does is not
    ;; derived from prog-mode major-mode
    :hook (erlang-mode . spacemacs/run-prog-mode-hooks)
    (erlang-mode . spacemacs//erlang-default)
    (erlang-mode-local-vars . spacemacs//erlang-setup-backend)
    :init
    (progn
      (setq erlang-compile-extra-opts '(debug_info)))
    :config (require 'erlang-start)))

(defun erlang_ts/init-edts ()
  (use-package edts
    :defer t
    :init
    (add-hook 'after-init-hook (lambda () (require 'edts-mode)))
    :config
    (spacemacs/declare-prefix-for-mode 'erlang-mode "mn" "navigate")
    (spacemacs/set-leader-keys-for-major-mode 'erlang-mode
      "M-." 'edts-find-source-under-point
      "M-," 'edts-find-source-unwind
      )
    (evil-define-key 'normal erlang-mode-map
      (kbd "s-.") 'edts-find-source-under-point
      (kbd "s-,") 'edts-find-source-unwind)
    ))

(defun erlang_ts/init-erl-trace ()
  (use-package erl-trace
    :defer t
    :init
    (add-hook 'after-init-hook (lambda () (require 'erl-trace)))
    :config
    (spacemacs/set-leader-keys-for-major-mode 'erlang-mode
      "C-c C-t" 'erl-trace-insert
      "C-c C-e" 'erl-trace-run-cmd
      "C-c C-r" 'erl-trace-store
      ))
  )

(defun erlang_ts/post-init-flycheck ()
  (spacemacs/enable-flycheck 'erlang-mode))


(defun erlang_ts/post-init-edts ()
  (unless (ignore-errors (require 'edts-start))
    (warn "EDTS is not installed in this environment!")))
