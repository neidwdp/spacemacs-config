;;; packages.el --- ztlevi layer packages file for Spacemacs.
;;
;; Copyright (c) 2016-2017 ztlevi
;;
;; Author: ztlevi <zhouting@umich.edu>
;; URL: https://github.com/ztlevi/spacemacs-config
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst ztlevi-programming-packages
  '(
    (stylus-mode :location (recipe :fetcher github :repo "vladh/stylus-mode"))
    ;; rjsx-mode
    xref-js2
    css-mode
    java-mode
    paredit
    lispy
    cmake-font-lock
    cmake-mode
    flycheck
    nodejs-repl
    (nodejs-repl-eval :location local)
    js2-mode
    js2-refactor
    json-mode
    racket-mode
    yasnippet
    web-mode
    web-beautify
    js-doc
    lua-mode
    (cc-mode :location built-in)
    ;; flycheck-clojure
    etags-select
    (python :location built-in)
    (emacs-lisp :location built-in)
    ;; clojure-mode
    company
    (eldoc :location built-in)
    dumb-jump
    graphviz-dot-mode
    cider
    robe
    )
  )

(defun ztlevi-programming/init-stylus-mode ()
  (use-package stylus-mode
    :defer t))

(defun ztlevi-programming/post-init-react-mode ()
  (with-eval-after-load 'web-mode
    (add-to-list 'web-mode-indentation-params '("lineup-args" . nil))
    (add-to-list 'web-mode-indentation-params '("lineup-concats" . nil))
    (add-to-list 'web-mode-indentation-params '("lineup-calls" . nil)))

  (setq js2-basic-offset 2)
  (setq css-indent-offset 2)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-attr-indent-offset 2)
  (setq react-indent-level 2))

(defun ztlevi-programming/init-rjsx-mode ()
  (use-package rjsx-mode
    :defer t
    :config
    (setq js2-basic-offset 2)
    (setq css-indent-offset 2)
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-css-indent-offset 2)
    (setq web-mode-code-indent-offset 2)
    (setq web-mode-attr-indent-offset 2)

    (with-eval-after-load 'rjsx-mode
      (define-key rjsx-mode-map (kbd "C-d") nil))
    ))
;; (add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode))

(defun ztlevi-programming/post-init-java-mode ()
  ;; ctags add hook
  (add-hook 'java-mode-hook 'my-setup-develop-environment))

(defun ztlevi-programming/post-init-robe ()
  (progn
    (add-hook 'inf-ruby-mode-hook 'spacemacs/toggle-auto-completion-on)
    (defun ztlevi/ruby-send-current-line (&optional print)
      "Send the current line to the inferior Ruby process."
      (interactive "P")
      (ruby-send-region
       (line-beginning-position)
       (line-end-position))
      (when print (ruby-print-result)))

    (defun ztlevi/ruby-send-current-line-and-go ()
      (interactive)
      (ztlevi/ruby-send-current-line)
      (ruby-switch-to-inf t))

    (defun ztlevi/start-inf-ruby-and-robe ()
      (interactive)
      (when (not (get-buffer "*ruby*"))
        (inf-ruby))
      (robe-start))

    (dolist (mode '(ruby-mode enh-ruby-mode))
      (spacemacs/set-leader-keys-for-major-mode mode
        "sb" 'ruby-send-block
        "sB" 'ruby-send-buffer
        "sl" 'ztlevi/ruby-send-current-line
        "sL" 'ztlevi/ruby-send-current-line-and-go
        "sI" 'ztlevi/start-inf-ruby-and-robe))))

(defun ztlevi-programming/post-init-cider ()
  (setq cider-cljs-lein-repl
        "(do (require 'figwheel-sidecar.repl-api)
           (figwheel-sidecar.repl-api/start-figwheel!)
           (figwheel-sidecar.repl-api/cljs-repl))")

  (defun ztlevi/cider-figwheel-repl ()
    (interactive)
    (save-some-buffers)
    (with-current-buffer (cider-current-repl-buffer)
      (goto-char (point-max))
      (insert "(require 'figwheel-sidecar.repl-api)
             (figwheel-sidecar.repl-api/start-figwheel!) ; idempotent
             (figwheel-sidecar.repl-api/cljs-repl)")
      (cider-repl-return)))

  (global-set-key (kbd "C-c C-f") #'ztlevi/cider-figwheel-repl))

(defun ztlevi-programming/post-init-graphviz-dot-mode ()
  (with-eval-after-load 'graphviz-dot-mode
    (require 'company-keywords)
    (push '(graphviz-dot-mode  "digraph" "node" "shape" "subgraph" "label" "edge" "bgcolor" "style" "record") company-keywords-alist)))

(defun ztlevi-programming/post-init-dumb-jump ()
  (setq dumb-jump-selector 'ivy)
  (defun my-dumb-jump ()
    (interactive)
    (evil-set-jump)
    (dumb-jump-go))
  (global-set-key (kbd "C-s-g") 'my-dumb-jump))

(defun ztlevi-programming/post-init-clojure-mode ()
  )

(defun ztlevi-programming/post-init-emacs-lisp ()
  (remove-hook 'emacs-lisp-mode-hook 'auto-compile-mode))

(defun ztlevi-programming/post-init-python ()
  (add-hook 'python-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
  ;; if you use pyton2, then you could comment the following 3 lines
  ;; (setq python-shell-interpreter "python2")
  ;; (setq python-shell-interpreter-args "-i")
  ;; (setq flycheck-python-pylint-executable "/usr/local/bin/pylint")
  )

(defun ztlevi-programming/post-init-js-doc ()
  (setq js-doc-mail-address "zhouting@umich.edu"
        js-doc-author (format "ztlevi Qu <%s>" js-doc-mail-address)
        js-doc-url "http://www.ztlevi.com"
        js-doc-license "MIT"))

(defun ztlevi-programming/init-ctags-update ()
  (use-package ctags-update
    :init
    :defer t
    :config
    (spacemacs|hide-lighter ctags-auto-update-mode)))

;; nodejs-repl is much better now.
;; (defun ztlevi-programming/init-js-comint ()
;;   (use-package js-comint
;;     :init
;;     (progn
;;       ;; http://stackoverflow.com/questions/13862471/using-node-js-with-js-comint-in-emacs
;;       (setq inferior-js-mode-hook
;;             (lambda ()
;;               ;; We like nice colors
;;               (ansi-color-for-comint-mode-on)
;;               ;; Deal with some prompt nonsense
;;               (add-to-list
;;                'comint-preoutput-filter-functions
;;                (lambda (output)
;;                  (replace-regexp-in-string "\033\\[[0-9]+[GKJ]" "" output)))))
;;       (setq inferior-js-program-command "node"))))

(defun ztlevi-programming/post-init-web-mode ()
  (with-eval-after-load "web-mode"
    (web-mode-toggle-current-element-highlight)
    (web-mode-dom-errors-show))
  (setq company-backends-web-mode '((company-dabbrev-code
                                     company-keywords
                                     company-etags)
                                    company-files company-dabbrev)))

(defun ztlevi-programming/post-init-yasnippet ()
  (progn
    ;; remove yas-installed-snippets-dir from yas-snippet-dirs
    (with-eval-after-load 'yasnippet
      (setq yas-snippet-dirs (remq 'yas-installed-snippets-dir yas-snippet-dirs)))

    (set-face-background 'secondary-selection "gray")
    (setq-default yas-prompt-functions '(yas-ido-prompt yas-dropdown-prompt))
    (mapc #'(lambda (hook) (remove-hook hook 'spacemacs/load-yasnippet)) '(prog-mode-hook
                                                                           org-mode-hook
                                                                           markdown-mode-hook))

    (spacemacs/add-to-hooks 'ztlevi/load-yasnippet '(prog-mode-hook
                                                     markdown-mode-hook
                                                     org-mode-hook))
    ))

(defun ztlevi-programming/post-init-racket-mode ()
  (progn
    (eval-after-load 'racket-repl-mode
      '(progn
         (define-key racket-repl-mode-map (kbd "]") nil)
         (define-key racket-repl-mode-map (kbd "[") nil)))

    (add-hook 'racket-mode-hook #'(lambda () (lispy-mode 1)))
    (add-hook 'racket-repl-mode-hook #'(lambda () (lispy-mode t)))
    ;; (add-hook 'racket-repl-mode-hook #'(lambda () (smartparens-mode t)))
    ))

(defun ztlevi-programming/post-init-json-mode ()
  ;; set indent for json mode
  (setq js-indent-level 2)
  ;; set indent for json-reformat-region
  (setq json-reformat:indent-width 2)
  (add-to-list 'auto-mode-alist '("\\.tern-project\\'" . json-mode))
  (add-to-list 'auto-mode-alist '("\\.fire\\'" . json-mode))
  (add-to-list 'auto-mode-alist '("\\.fire.meta\\'" . json-mode))

  (spacemacs/set-leader-keys-for-major-mode 'json-mode
    "ti" 'my-toggle-web-indent))

(defun ztlevi-programming/post-init-web-beautify ()
  (spacemacs/set-leader-keys-for-major-mode 'json-mode
    "=" 'json-reformat-region-or-buffer))


(defun ztlevi-programming/init-nodejs-repl ()
  (use-package nodejs-repl
    :init
    :defer t))

(defun ztlevi-programming/init-flycheck-package ()
  (use-package flycheck-package))

(defun ztlevi-programming/init-lispy ()
  (use-package lispy
    :defer t
    :init
    (progn
      (add-hook 'emacs-lisp-mode-hook (lambda () (lispy-mode 1)))
      (add-hook 'ielm-mode-hook (lambda () (lispy-mode 1)))
      (add-hook 'inferior-emacs-lisp-mode-hook (lambda () (lispy-mode 1)))
      ;; (add-hook 'spacemacs-mode-hook (lambda () (lispy-mode 1)))
      (add-hook 'clojure-mode-hook (lambda () (lispy-mode 1)))
      (add-hook 'scheme-mode-hook (lambda () (lispy-mode 1)))
      (add-hook 'cider-repl-mode-hook (lambda () (lispy-mode 1)))
      )
    :config
    (progn
      (push '(cider-repl-mode . ("[`'~@]+" "#" "#\\?@?")) lispy-parens-preceding-syntax-alist)

      (spacemacs|hide-lighter lispy-mode)
      (define-key lispy-mode-map (kbd "s-j") 'lispy-splice)
      (define-key lispy-mode-map (kbd "s-k") 'paredit-splice-sexp-killing-backward)

      (with-eval-after-load 'cider-repl
        (define-key cider-repl-mode-map (kbd "C-s-j") 'cider-repl-newline-and-indent))

      (add-hook
       'minibuffer-setup-hook
       'conditionally-enable-lispy)
      (define-key lispy-mode-map (kbd "s-m") 'lispy-mark-symbol)
      (define-key lispy-mode-map (kbd "s-1") 'lispy-describe-inline)
      (define-key lispy-mode-map (kbd "s-2") 'lispy-arglist-inline))))


(defun ztlevi-programming/init-cmake-font-lock ()
  (use-package cmake-font-lock
    :defer t))

(defun ztlevi-programming/init-google-c-style ()
  (use-package google-c-style
    :init (add-hook 'c-mode-common-hook 'google-set-c-style)))

(defun ztlevi-programming/post-init-cmake-mode ()
  (progn
    (spacemacs/declare-prefix-for-mode 'cmake-mode
      "mh" "docs")
    (spacemacs/set-leader-keys-for-major-mode 'cmake-mode
      "hd" 'cmake-help)
    (add-hook 'cmake-mode-hook (function cmake-rename-buffer))))


(defun ztlevi-programming/post-init-flycheck ()
  (progn
    ;; disable jshint since we prefer eslint checking
    (setq-default flycheck-disabled-checkers
                  (append flycheck-disabled-checkers
                          '(javascript-jshint)))

    ;; customize flycheck temp file prefix
    (setq-default flycheck-temp-prefix ".flycheck")

    ;; disable json-jsonlist checking for json files
    (setq-default flycheck-disabled-checkers
                  (append flycheck-disabled-checkers
                          '(json-jsonlist)))

    ;; add c++ flycheck standard
    (add-hook 'c++-mode-hook (lambda () (setq flycheck-gcc-language-standard "c++11"))))

  (with-eval-after-load 'flycheck
    (progn
      (setq flycheck-display-errors-delay 0.9)
      (setq flycheck-idle-change-delay 2.0))))

(defun ztlevi-programming/post-init-eldoc ()
  (setq eldoc-idle-delay 0.4))

(defun ztlevi-programming/post-init-js2-refactor ()
  (progn
    (spacemacs/set-leader-keys-for-major-mode 'js2-mode
      "r>" 'js2r-forward-slurp
      "r<" 'js2r-forward-barf)))

(defun ztlevi-programming/post-init-js2-mode ()
  (progn
    ;; Better imenu
    (add-hook 'js2-mode-hook #'js2-imenu-extras-mode)
    (add-hook 'js2-mode-hook
              (lambda ()
                (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))
    (add-hook 'js2-mode-hook 'my-setup-develop-environment)
    (add-hook 'web-mode-hook 'my-setup-develop-environment)

    (spacemacs|define-jump-handlers js2-mode)
    (add-hook 'spacemacs-jump-handlers-js2-mode 'etags-select-find-tag-at-point)

    (setq company-backends-js2-mode '((company-dabbrev-code :with company-keywords company-etags)
                                      company-files company-dabbrev))

    (ztlevi|toggle-company-backends company-tern)

    (spacemacs/set-leader-keys-for-major-mode 'js2-mode
      "tb" 'ztlevi/company-toggle-company-tern)

    (add-hook 'js2-mode-hook 'my-js2-mode-hook)

    ;; add your own keywords highlight here
    (font-lock-add-keywords 'js2-mode
                            '(("\\<\\(cc\\)\\>" 1 font-lock-type-face)))

    (spacemacs/declare-prefix-for-mode 'js2-mode "ms" "repl")

    (with-eval-after-load 'js2-mode
      (progn
        ;; these mode related variables must be in eval-after-load
        ;; https://github.com/magnars/.emacs.d/blob/master/settings/setup-js2-mode.el
        (setq js2-allow-rhino-new-expr-initializer nil)
        (setq js2-auto-indent-p nil)
        (setq js2-enter-indents-newline nil)
        (setq js2-global-externs '("module" "ccui" "require" "buster" "sinon" "assert" "refute" "setTimeout" "clearTimeout" "setInterval" "clearInterval" "location" "__dirname" "console" "JSON"))
        (setq js2-idle-timer-delay 0.2)
        (setq js2-mirror-mode nil)
        (setq js2-strict-inconsistent-return-warning nil)
        (setq js2-include-rhino-externs nil)
        (setq js2-include-gears-externs nil)
        (setq js2-concat-multiline-strings 'eol)
        (setq js2-rebind-eol-bol-keys nil)
        (setq js2-auto-indent-p t)

        (setq js2-bounce-indent nil)
        (setq js-indent-level 4)
        (setq js2-basic-offset 4)
        (setq js-switch-indent-offset 4)
        ;; Let flycheck handle parse errors
        (setq js2-mode-show-parse-errors nil)
        (setq js2-mode-show-strict-warnings nil)
        (setq js2-highlight-external-variables t)
        (setq js2-strict-trailing-comma-warning nil)

        (add-hook 'web-mode-hook 'my-web-mode-indent-setup)
        (spacemacs/set-leader-keys-for-major-mode 'js2-mode
          "ti" 'my-toggle-web-indent)
        (spacemacs/set-leader-keys-for-major-mode 'js-mode
          "ti" 'my-toggle-web-indent)
        (spacemacs/set-leader-keys-for-major-mode 'web-mode
          "ti" 'my-toggle-web-indent)
        (spacemacs/set-leader-keys-for-major-mode 'css-mode
          "ti" 'my-toggle-web-indent)

        (spacemacs/declare-prefix-for-mode 'js2-mode "mt" "toggle")
        (spacemacs/declare-prefix-for-mode 'js-mode "mt" "toggle")
        (spacemacs/declare-prefix-for-mode 'web-mode "mt" "toggle")
        (spacemacs/declare-prefix-for-mode 'css-mode "mt" "toggle")


        (eval-after-load 'tern-mode
          '(spacemacs|hide-lighter tern-mode))
        ))

    (evilified-state-evilify js2-error-buffer-mode js2-error-buffer-mode-map)

    ))

(defun ztlevi-programming/post-init-css-mode ()
  (progn
    (dolist (hook '(css-mode-hook sass-mode-hook less-mode-hook))
      (add-hook hook 'rainbow-mode))

    (defun css-imenu-make-index ()
      (save-excursion
        (imenu--generic-function '((nil "^ *\\([^ ]+\\) *{ *$" 1)))))

    (add-hook 'css-mode-hook
              (lambda ()
                (setq imenu-create-index-function 'css-imenu-make-index)))))

(defun ztlevi-programming/post-init-tagedit ()
  (add-hook 'web-mode-hook (lambda () (tagedit-mode 1))))

;; For each extension, define a function ztlevi/init-<extension-name>
;;
(defun ztlevi-programming/init-doxymacs ()
  "Initialize doxymacs"
  (use-package doxymacs
    :init
    (add-hook 'c-mode-common-hook 'doxymacs-mode)
    :config
    (progn
      (add-hook 'font-lock-mode-hook 'my-doxymacs-font-lock-hook)
      (spacemacs|hide-lighter doxymacs-mode))))

;; https://atlanis.net/blog/posts/nodejs-repl-eval.html
(defun ztlevi-programming/init-nodejs-repl-eval ()
  (use-package nodejs-repl-eval
    :commands (nodejs-repl-eval-buffer nodejs-repl-eval-dwim nodejs-repl-eval-function)
    :init
    (progn
      (spacemacs/declare-prefix-for-mode 'js2-mode
        "ms" "REPL")
      (spacemacs/set-leader-keys-for-major-mode 'js2-mode
        "sb" 'nodejs-repl-eval-buffer
        "sf" 'nodejs-repl-eval-function
        "sd" 'nodejs-repl-eval-dwim))
    :defer t
    ))

(defun ztlevi-programming/post-init-lua-mode ()
  (progn
    (add-hook 'lua-mode-hook 'evil-matchit-mode)
    ;; (add-hook 'lua-mode-hook 'smartparens-mode)
    (setq lua-indent-level 2)

    ;; add lua language, basic, string and table keywords.
    ;; (with-eval-after-load 'lua-mode
    ;;   (require 'company-keywords)
    ;;   (push '(lua-mode  "setmetatable" "local" "function" "and" "break" "do" "else" "elseif" "self" "resume" "yield"
    ;;                     "end" "false" "for" "function" "goto" "if" "nil" "not" "or" "repeat" "return" "then" "true"
    ;;                     "until" "while" "__index" "dofile" "getmetatable" "ipairs" "pairs" "print" "rawget" "status"
    ;;                     "rawset" "select" "_G" "assert" "collectgarbage" "error" "pcall" "coroutine"
    ;;                     "rawequal" "require" "load" "tostring" "tonumber" "xpcall" "gmatch" "gsub"
    ;;                     "rep" "reverse" "sub" "upper" "concat" "pack" "insert" "remove" "unpack" "sort"
    ;;                     "lower") company-keywords-alist))

    ))

(defun ztlevi-programming/post-init-cc-mode ()
  (progn
    (setq company-backends-c-mode-common '((company-dabbrev-code :with company-keywords company-gtags company-etags)
                                           company-files company-dabbrev))
    (spacemacs/set-leader-keys-for-major-mode 'c++-mode
      "gd" 'etags-select-find-tag-at-point)


    (add-hook 'c++-mode-hook 'my-setup-develop-environment)
    (add-hook 'c-mode-hook 'my-setup-develop-environment)


    ;; http://stackoverflow.com/questions/23553881/emacs-indenting-of-c11-lambda-functions-cc-mode
    (defadvice c-lineup-arglist (around my activate)
      "Improve indentation of continued C++11 lambda function opened as argument."
      (setq ad-return-value
            (if (and (equal major-mode 'c++-mode)
                     (ignore-errors
                       (save-excursion
                         (goto-char (c-langelem-pos langelem))
                         ;; Detect "[...](" or "[...]{". preceded by "," or "(",
                         ;;   and with unclosed brace.
                         (looking-at ".*[(,][ \t]*\\[[^]]*\\][ \t]*[({][^}]*$"))))
                0                       ; no additional indent
              ad-do-it)))               ; default behavior


    (setq c-default-style "linux") ;; set style to "linux"
    (setq c-basic-offset 4)
    (c-set-offset 'substatement-open 0)
    (with-eval-after-load 'c++-mode
      (define-key c++-mode-map (kbd "s-.") 'company-ycmd)))

  )

(defun ztlevi-programming/init-flycheck-clojure ()
  (use-package flycheck-clojure
    :defer t
    :init
    (eval-after-load 'flycheck '(flycheck-clojure-setup))))

(defun ztlevi-programming/post-init-ycmd ()
  (progn
    (setq ycmd-tag-files 'auto)
    (setq ycmd-request-message-level -1)
    (set-variable 'ycmd-server-command `("python" ,(expand-file-name "~/Github/ycmd/ycmd/__main__.py")))
    (setq company-backends-c-mode-common '((company-c-headers
                                            company-dabbrev-code
                                            company-keywords
                                            company-gtags :with company-yasnippet)
                                           company-files company-dabbrev ))

    (ztlevi|toggle-company-backends company-ycmd)
    (eval-after-load 'ycmd
      '(spacemacs|hide-lighter ycmd-mode))

    (spacemacs/set-leader-keys-for-major-mode 'c-mode
      "tb" 'ztlevi/company-toggle-company-ycmd)
    (spacemacs/set-leader-keys-for-major-mode 'c++-mode
      "tb" 'ztlevi/company-toggle-company-ycmd)))

;; when many project has the need to use tags, I will give etags-table and etags-update a try
(defun ztlevi-programming/init-etags-select ()
  (use-package etags-select
    :init
    (progn
      (define-key evil-normal-state-map (kbd "gf")
        (lambda () (interactive) (find-tag (find-tag-default-as-regexp))))

      (define-key evil-normal-state-map (kbd "gb") 'pop-tag-mark)

      (define-key evil-normal-state-map (kbd "gn")
        (lambda () (interactive) (find-tag last-tag t)))

      (evilified-state-evilify etags-select-mode etags-select-mode-map)
      (spacemacs/set-leader-keys-for-major-mode 'js2-mode
        "gd" 'etags-select-find-tag-at-point))))

(defun ztlevi-programming/init-paredit ()
  (use-package paredit
    :commands (paredit-wrap-round
               paredit-wrap-square
               paredit-wrap-curly
               paredit-splice-sexp-killing-backward)
    :init
    (progn

      (bind-key* "s-(" #'paredit-wrap-round)
      (bind-key* "s-[" #'paredit-wrap-square)
      (bind-key* "s-{" #'paredit-wrap-curly)
      )))

(defun ztlevi-programming/post-init-company ()
  (progn
    (setq company-minimum-prefix-length 1
          company-idle-delay 0.08)

    (when (configuration-layer/package-usedp 'company)
      (spacemacs|add-company-backends :modes shell-script-mode makefile-bsdmake-mode sh-mode lua-mode nxml-mode conf-unix-mode json-mode graphviz-dot-mode))

    ;; define company-mode keybindings
    (with-eval-after-load 'company
      (progn
        (define-key company-active-map (kbd "C-f") nil)
        (bb/define-key company-active-map
          (kbd "C-w") 'evil-delete-backward-word)

        (bb/define-key company-active-map
          (kbd "<C-i>") 'company-show-location)))
    ))

(defun ztlevi-programming/post-init-company-c-headers ()
  (progn
    (setq company-c-headers-path-system
          (quote
           ("/usr/include/" "/usr/local/include/" "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1")))
    (setq company-c-headers-path-user
          (quote
           ("/Users/guanghui/cocos2d-x/cocos/platform" "/Users/guanghui/cocos2d-x/cocos" "." "/Users/guanghui/cocos2d-x/cocos/audio/include/")))))

(defun ztlevi-programming/init-xref-js2 ()
  (use-package xref-js2
    :defer t
    ))
