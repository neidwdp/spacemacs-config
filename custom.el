;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ahs-case-fold-search nil t)
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(command-log-mode-window-size 50)
 '(company-dabbrev-minimum-length 3)
 '(company-dabbrev-other-buffers nil)
 '(company-show-numbers t)
 '(company-statistics-auto-restore nil)
 '(compilation-message-face (quote default))
 '(counsel-grep-base-command
   "rg -i -M 120 --no-heading --line-number --color never '%s' %s")
 '(ctags-update-delay-seconds 1024)
 '(erc-nick "ztlevi")
 '(erc-port 6666)
 '(evil-cross-lines t)
 '(evil-want-Y-yank-to-eol nil)
 '(expand-region-contract-fast-key "V")
 '(expand-region-exclude-text-mode-expansions (quote (html-mode nxml-mode web-mode)))
 '(expand-region-reset-fast-key "r")
 '(flymd-close-buffer-delete-temp-files t)
 '(global-command-log-mode nil)
 '(helm-buffer-max-length 56)
 '(helm-move-to-line-cycle-in-source t)
 '(httpd-port 48080)
 '(hybrid-mode-use-evil-search-module t)
 '(ibuffer-filter-group-name-face (quote link))
 '(linum-relative-plusp-offset 1)
 '(lua-documentation-url "http://www.lua.org/manual/5.3/manual.html")
 '(magit-diff-use-overlays nil)
 '(magit-use-overlays nil)
 '(markdown-gfm-use-electric-backquote nil)
 '(only-global-abbrevs t)
 '(org-agenda-custom-commands nil)
 '(org-agenda-ndays 1)
 '(org-agenda-show-all-dates t)
 '(org-agenda-skip-deadline-if-done t)
 '(org-agenda-skip-deadline-prewarning-if-scheduled t)
 '(org-agenda-skip-scheduled-if-done t)
 '(org-agenda-start-on-weekday nil)
 '(org-agenda-text-search-extra-files (quote (agenda-archives)))
 '(org-deadline-warning-days 14)
 '(org-ellipsis "  ")
 '(org-fast-tag-selection-single-key (quote expert))
 '(org-fontify-done-headline t)
 '(org-fontify-quote-and-verse-blocks t)
 '(org-fontify-whole-heading-line t)
 '(org-html-html5-fancy t)
 '(org-log-into-drawer t)
 '(org-pomodoro-play-sounds nil)
 '(org-reverse-note-order t)
 '(package-selected-packages
   (quote
    (sx sos unicode-fonts ucs-utils font-utils persistent-soft list-utils window-purpose imenu-list treemacs-projectile treemacs-evil treemacs pfuture cmake-ide levenshtein kite fcitx restclient-helm helm-pydoc helm-gitignore helm-css-scss helm-company org-brain vmd-mode evil-org doom-themes stylus-mode sws-mode jade-mode company-php ac-php-core xcscope material-theme pandoc-mode ox-pandoc sayid password-generator evil-lion editorconfig company-lua flycheck-coverity websocket atomic-chrome gmail-message-mode ham-mode html-to-markdown flymd edit-server realgud blog-admin dash-at-point browse-at-remote git-gutter-fringe git-gutter memoize seq xref-js2 string-inflection github-browse-file opencl-mode cuda-mode ctable orglue epic names chinese-word-at-point visual-regexp typescript-mode faceup rake pcre2el metaweblog xml-rpc alert log4e gntp org-plus-contrib org-mac-link markdown-mode zoutline simple-httpd projectile htmlize parent-mode helm helm-core haml-mode fringe-helper git-gutter+ gh marshal logito pcache ht flyspell-correct pos-tip flycheck magit git-commit with-editor iedit anzu evil goto-chg undo-tree popup php-mode json-mode tablist magit-popup docker-tramp json-snatcher json-reformat makey diminish swiper ivy web-completion-data dash-functional tern restclient know-your-http-well cmake-mode hydra inflections edn cider multiple-cursors paredit spinner peg eval-sexp-fu highlight queue pkg-info clojure-mode epl inf-ruby bind-key yasnippet packed async anaconda-mode pythonic f dash s all-the-icons font-lock+ ace-window avy request js2-mode company zeal-at-point youdao-dictionary yapfify yaml-mode xterm-color ws-butler wrap-region winum which-key wgrep web-mode web-beautify visual-regexp-steroids uuidgen use-package unfill toc-org tiny tide tagedit solarized-theme smex slim-mode sicp shell-pop scss-mode sass-mode rvm ruby-tools ruby-test-mode rubocop rspec-mode robe reveal-in-osx-finder restart-emacs rbenv ranger rainbow-mode rainbow-identifiers racket-mode pyvenv pytest pyenv-mode py-isort pug-mode projectile-rails prodigy popwin pip-requirements phpunit phpcbf php-extras php-auto-yasnippets persp-mode peep-dired pbcopy paradox osx-trash osx-dictionary origami org2blog org-preview-html org-pomodoro org-octopress open-junk-file ob-restclient ob-http nodejs-repl neotree mwim multi-term move-text mmm-mode minitest markdown-toc macrostep lua-mode live-py-mode lispy linum-relative link-hint less-css-mode launchctl js2-refactor js-doc ivy-hydra info+ indent-guide impatient-mode ibuffer-projectile hy-mode hungry-delete hl-todo highlight-parentheses highlight-numbers highlight-global hide-comnt help-fns+ helm-github-stars helm-ag graphviz-dot-mode golden-ratio gnuplot glsl-mode gitignore-mode github-search github-clone gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe+ gist ggtags fuzzy flyspell-correct-ivy flycheck-pos-tip flx find-file-in-project fill-column-indicator feature-mode expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-matchit evil-magit evil-iedit-state evil-escape evil-anzu etags-select eshell-z eshell-prompt-extras esh-help engine-mode emmet-mode elisp-slime-nav dumb-jump drupal-mode dockerfile-mode docker discover-my-major diff-hl deft cython-mode counsel company-web company-tern company-statistics company-restclient company-c-headers company-anaconda column-enforce-mode color-identifiers-mode coffee-mode cmake-font-lock clojure-snippets clj-refactor cider-eval-sexp-fu chruby bundler bracketed-paste bind-map auto-yasnippet auto-highlight-symbol auto-compile all-the-icons-dired aggressive-indent adaptive-wrap ace-link 4clojure)))
 '(paradox-github-token t)
 '(ring-bell-function (quote ignore))
 '(sp-show-pair-from-inside t)
 '(swiper-goto-start-of-match t)
 '(tags-revert-without-query t)
 '(use-package-verbose t)
 '(vc-annotate-background-mode nil)
 '(vc-follow-symlinks t)
 '(visual-line-fringe-indicators (quote (left-curly-arrow right-curly-arrow)))
 '(web-mode-markup-indent-offset 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(header-line ((t (:inherit font-lock-preprocessor-face))))
 '(helm-candidate-number ((t (:background "dodger blue" :foreground "#fafafa"))))
 '(markdown-code-face ((t (:background "#f0f0f0"))))
 '(mmm-default-submode-face ((t (:background "#f0f0f0"))))
 '(org-block ((t (:background "#f0f0f0"))))
 '(show-paren-match ((t (:background "#ff69b4" :foreground "#fafafa"))))
 '(web-mode-current-element-highlight-face ((t (:background "dodger blue" :foreground "#ffffff"))))
 '(wgrep-face ((t (:background "#f0f0f0")))))
;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
