;;; packages.el --- ztlevi-misc layer packages file for Spacemacs. -*- lexical-binding: t -*-
;;
;; Copyright (c) 2016-2018 ztlevi
;;
;; Author: ztlevi <zhouting@umich.edu>
;; URL: https://github.com/ztlevi/spacemacs-config
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst ztlevi-misc-packages
  '(
    ;; sx
    ;; sos
    helm-github-stars
    atomic-chrome
    treemacs
    projectile
    prodigy
    multiple-cursors
    visual-regexp
    visual-regexp-steroids
    command-log
    origami
    evil
    evil-surround
    evil-multiedit
    evil-string-inflection
    evil-search-highlight-persist
    discover-my-major
    ;; 4clojure
    persp-mode
    focus
    flyspell-correct
    markdown-mode
    flymd
    (live-server :location local)
    edit-indirect
    wucuo
    ivy
    counsel
    wgrep-ag
    rg
    ibuffer
    p4
    magit
    magit-todos
    magithub
    github-browse-file
    git-messenger
    git-link
    hydra
    wrap-region
    golden-ratio
    )
  )

(defun ztlevi-misc/init-wucuo ()
  (use-package wucuo
    :defer t
    :init (remove-hook 'prog-mode-hook 'flyspell-prog-mode)
    :hook
    (prog-mode . wucuo-start)
    (js2-mode . wucuo-start)))

(defun ztlevi-misc/init-sx ()
  (use-package sx
    :defer t
    :config
    (with-eval-after-load 'sx-question-list
      (progn
        (define-key sx-question-list-mode-map "j" 'sx-question-list-next)
        (define-key sx-question-list-mode-map "k" 'sx-question-list-previous)
        (define-key sx-question-list-mode-map "n" 'sx-question-list-view-next)
        (define-key sx-question-list-mode-map "p" 'sx-question-list-view-previous)))))

(defun ztlevi-misc/init-sos ()
  (use-package sos
    :defer t))

(defun ztlevi-misc/init-atomic-chrome ()
  (use-package atomic-chrome
    :defer 3
    :preface
    (defun ztlevi-atomic-chrome-server-running-p ()
      (cond ((executable-find "lsof")
             (zerop (call-process "lsof" nil nil nil "-i" ":64292")))
            ((executable-find "netstat") ; Windows
             (zerop (call-process-shell-command "netstat -aon | grep 64292")))))
    :hook
    (atomic-chrome-edit-mode . ztlevi-atomic-chrome-mode-setup)
    (atomic-chrome-edit-done . (lambda () (shell-command "open -a \"/Applications/Google Chrome.app\"")))
    :config
    (progn
      (spacemacs|diminish atomic-chrome-edit-mode " Ⓐ" " A")

      (setq atomic-chrome-buffer-open-style 'full) ;; or frame, split
      (setq atomic-chrome-url-major-mode-alist
            '(("github\\.com"        . gfm-mode)
              ("emacs-china\\.org"   . gfm-mode)
              ("stackexchange\\.com" . gfm-mode)
              ("stackoverflow\\.com" . gfm-mode)
              ;; jupyter notebook
              ("localhost\\:8888"    . python-mode)
              ("lintcode\\.com"      . python-mode)
              ("leetcode\\.com"      . python-mode)))

      (defun ztlevi-atomic-chrome-mode-setup ()
        (setq header-line-format
              (substitute-command-keys
               "Edit Chrome text area.  Finish \
`\\[atomic-chrome-close-current-buffer]'.")))

      (if (ztlevi-atomic-chrome-server-running-p)
          (message "Can't start atomic-chrome server, because port 64292 is already used")
        (atomic-chrome-start-server)))))

(defun ztlevi-misc/post-init-treemacs ()
  (with-eval-after-load 'treemacs
    (define-key treemacs-mode-map (kbd "ov") 'treemacs-visit-node-horizontal-split)
    (define-key treemacs-mode-map (kbd "os") 'treemacs-visit-node-vertical-split)
    (define-key evil-treemacs-state-map (kbd "f") 'counsel-find-file)
    (define-key evil-treemacs-state-map (kbd "+") 'make-directory))

  ;; improve treemacs theme
  (doom-themes-treemacs-config)
  (setq doom-treemacs-enable-variable-pitch t))

(defun ztlevi-misc/post-init-neotreemacs ()
  (with-eval-after-load 'neotree
    (define-key neotree-mode-map (kbd "f") 'counsel-find-file)
    (define-key neotree-mode-map (kbd "+") 'make-directory))

  (doom-themes-neotree-config)
  (setq doom-neotree-enable-variable-pitch t
        doom-neotree-file-icons 'simple
        doom-neotree-line-spacing 2))

(defun ztlevi-misc/post-init-golden-ratio ()
  (with-eval-after-load 'golden-ratio
    (dolist (mode '("occur-mode"))
      (add-to-list 'golden-ratio-exclude-modes mode))
    (dolist (n '("COMMIT_EDITMSG"))
      (add-to-list 'golden-ratio-exclude-buffer-names n))))

(defun ztlevi-misc/post-init-hydra ()
  (progn
    (defhydra hydra-hotspots (:color blue)
      "Hotspots"
      ("b" blog-admin-start "blog")
      ("g" helm-github-stars "helm github stars")
      ("r" ztlevi/run-current-file "run current file"))

    (defhydra multiple-cursors-hydra (:hint nil)
      "
       ^Up^            ^Down^        ^Other^
             ----------------------------------------------
         [_p_]   Next    [_n_]   Next    [_l_] Edit lines
         [_P_]   Skip    [_N_]   Skip    [_a_] Mark all
         [_M-p_] Unmark  [_M-n_] Unmark [_r_] Mark by regexp
         ^ ^             ^ ^ [_q_] Quit
       "
      ("l" mc/edit-lines :exit t)
      ("a" mc/mark-all-like-this :exit t)
      ("n" mc/mark-next-like-this)
      ("N" mc/skip-to-next-like-this)
      ("M-n" mc/unmark-next-like-this)
      ("p" mc/mark-previous-like-this)
      ("P" mc/skip-to-previous-like-this)
      ("M-p" mc/unmark-previous-like-this)
      ("r" mc/mark-all-in-region-regexp :exit t)
      ("q"
       nil))

    (defhydra
      hydra-apropos (:color blue)
      "Apropos"
      ("a" apropos "apropos")
      ("c" apropos-command "cmd")
      ("d" apropos-documentation "doc")
      ("e" apropos-value "val")
      ("l" apropos-library "lib")
      ("o" apropos-user-option "option")
      ("u" apropos-user-option "option")
      ("v" apropos-variable "var")
      ("i" info-apropos "info")
      ("t" tags-apropos "tags")
      ("z" hydra-customize-apropos/body "customize"))

    (defhydra
      hydra-customize-apropos (:color blue)
      "Apropos (customize)"
      ("a" customize-apropos "apropos")
      ("f" customize-apropos-faces "faces")
      ("g" customize-apropos-groups "groups")
      ("o" customize-apropos-options "options"))

    (global-set-key (kbd "<f1>") 'hydra-hotspots/body)
    (spacemacs/set-leader-keys "oo" 'hydra-hotspots/body)
    (spacemacs/set-leader-keys "oh" 'hydra-apropos/body)
    ))

(defun ztlevi-misc/post-init-origami ()
  (add-to-list 'origami-parser-alist `(js2-mode . ,(origami-markers-parser "//region" "//endregion")))
  (add-to-list 'origami-parser-alist `(java-mode . ,(origami-markers-parser "//region" "//endregion")))
  (add-to-list 'origami-parser-alist `(python-mode . ,(origami-markers-parser "# region" "# endregion")))
  (add-to-list 'origami-parser-alist `(ruby-mode . ,(origami-markers-parser "#region" "#endregion")))
  )

(defun ztlevi-misc/post-init-flyspell-correct ()
  (progn
    (with-eval-after-load 'flyspell
      (define-key flyspell-mode-map (kbd "C-;") 'flyspell-correct-previous-word-generic))
    (setq flyspell-correct-interface 'flyspell-correct-ivy)))

(defun ztlevi-misc/init-focus ()
  (use-package focus
    :defer t))

(defun ztlevi-misc/init-helm-github-stars ()
  (use-package helm-github-stars
    :defer t
    :commands (helm-github-stars)
    :init
    (setq helm-github-stars-username "ztlevi")))

(defun ztlevi-misc/post-init-command-log ()
  (with-eval-after-load 'global-command-log-mode
    (setq clm/log-command-exceptions* (append clm/log-command-exceptions*
                                              '(evil-next-visual-line
                                                evil-previous-visual-line)))))

(defun ztlevi-misc/init-4clojure ()
  (use-package 4clojure
    :defer t
    :init
    (progn
      (spacemacs/declare-prefix "o4" "4clojure")
      (spacemacs/set-leader-keys "o4q" '4clojure-open-question)
      (spacemacs/set-leader-keys "o4n" '4clojure-next-question)
      (spacemacs/set-leader-keys "o4p" '4clojure-previous-question)
      (spacemacs/set-leader-keys "o4c" '4clojure-check-answers))))

(defun ztlevi-misc/init-discover-my-major ()
  (use-package discover-my-major
    :defer t
    :init
    (progn
      (spacemacs/set-leader-keys (kbd "mhm") 'discover-my-major)
      (evilified-state-evilify makey-key-mode makey-key-mode-get-key-map))))

(defun ztlevi-misc/post-init-elfeed ()
  (use-package elfeed
    :init
    (global-set-key (kbd "C-x w") 'elfeed)
    :defer t
    :config
    (progn

      (setq elfeed-feeds
            '("http://nullprogram.com/feed/"
              "http://z.caudate.me/rss/"
              "http://irreal.org/blog/?feed=rss2"
              "http://feeds.feedburner.com/LostInTheTriangles"
              "http://tonybai.com/feed/"
              "http://planet.emacsen.org/atom.xml"
              "http://feeds.feedburner.com/emacsblog"
              "http://blog.binchen.org/rss.xml"
              "http://oremacs.com/atom.xml"
              "http://blog.gemserk.com/feed/"
              "http://www.masteringemacs.org/feed/"
              "http://t-machine.org/index.php/feed/"
              "http://gameenginebook.blogspot.com/feeds/posts/default"
              "http://feeds.feedburner.com/ruanyifeng"
              "http://coolshell.cn/feed"
              "http://blog.devtang.com/atom.xml"
              "http://emacsist.com/rss"
              "http://puntoblogspot.blogspot.com/feeds/2507074905876002529/comments/default"
              "http://angelic-sedition.github.io/atom.xml"))

      ;; (evilify elfeed-search-mode elfeed-search-mode-map)
      (evilified-state-evilify-map elfeed-search-mode-map
        :mode elfeed-search-mode
        :bindings
        "G" 'elfeed-update
        "g" 'elfeed-search-update--force)

      (defun ztlevi/elfeed-mark-all-as-read ()
        (interactive)
        (mark-whole-buffer)
        (elfeed-search-untag-all-unread))

      (define-key elfeed-search-mode-map (kbd "R") 'ztlevi/elfeed-mark-all-as-read)

      (defadvice elfeed-show-yank (after elfeed-show-yank-to-kill-ring activate compile)
        "Insert the yanked text from x-selection to kill ring"
        (kill-new (x-get-selection)))

      (ad-activate 'elfeed-show-yank))))

(defun ztlevi-misc/init-evil-multiedit ()
  (use-package evil-multiedit
    :defer t
    :commands evil-multiedit-default-keybinds
    :init
    (define-key evil-visual-state-map "R" #'evil-multiedit-match-all)
    (define-key evil-normal-state-map (kbd "s-d") #'evil-multiedit-match-symbol-and-next)
    (define-key evil-visual-state-map (kbd "s-d") #'evil-multiedit-match-and-next)
    (define-key evil-normal-state-map (kbd "s-D") #'evil-multiedit-match-symbol-and-prev)
    (define-key evil-visual-state-map (kbd "s-D") #'evil-multiedit-match-and-prev)
    (define-key evil-insert-state-map (kbd "s-d") #'evil-multiedit-toggle-marker-here)
    (define-key evil-visual-state-map (kbd "C-M-D") #'evil-multiedit-restore)
    (with-eval-after-load 'evil-multiedit
      (define-key evil-multiedit-state-map (kbd "RET") #'evil-multiedit-toggle-or-restrict-region)
      (define-key evil-multiedit-state-map (kbd "C-n") #'evil-multiedit-next)
      (define-key evil-multiedit-state-map (kbd "C-p") #'evil-multiedit-prev)
      (define-key evil-multiedit-insert-state-map (kbd "C-n") #'evil-multiedit-next)
      (define-key evil-multiedit-insert-state-map (kbd "C-p") #'evil-multiedit-prev)
      (define-key evil-multiedit-insert-state-map (kbd "C-d") #'delete-char))
    (evil-ex-define-cmd "ie[dit]" #'evil-multiedit-ex-match)))

(defun ztlevi-misc/init-evil-string-inflection ()
  (use-package evil-string-inflection
    :after evil))

(defun ztlevi-misc/init-evil-search-highlight-persist ()
  (use-package evil-search-highlight-persist
    :init
    (progn

      ;; evil-search-highlight-persist
      (defun spacemacs/evil-persist-search-clear-highlight ()
        "Clear evil-search or evil-ex-search persistent highlights."
        (interactive)
        (evil-search-highlight-persist-remove-all) ; `C-s' highlights
        (evil-ex-nohighlight))                     ; `/' highlights

      (defun spacemacs//adaptive-evil-highlight-persist-face ()
        (set-face-attribute 'evil-search-highlight-persist-highlight-face nil
                            :inherit 'lazy-highlight
                            :background nil
                            :foreground nil))

      (global-evil-search-highlight-persist)
      ;; (set-face-attribute )
      (define-key evil-search-highlight-persist-map
        (kbd "C-x SPC") 'rectangle-mark-mode)
      (spacemacs/set-leader-keys "sc" 'spacemacs/evil-persist-search-clear-highlight)
      (evil-ex-define-cmd "nohlsearch" 'spacemacs/evil-persist-search-clear-highlight)
      (spacemacs//adaptive-evil-highlight-persist-face)
      (add-hook 'spacemacs-post-theme-change-hook
                'spacemacs//adaptive-evil-highlight-persist-face))))

(defun ztlevi-misc/post-init-ibuffer ()
  (with-eval-after-load 'ibuffer
    ;; set ibuffer name column width
    (define-ibuffer-column size-h
      (:name "Size" :inline t)
      (cond
       ((> (buffer-size) 1000000) (format "%7.1fM" (/ (buffer-size) 1000000.0)))
       ((> (buffer-size) 1000) (format "%7.1fk" (/ (buffer-size) 1000.0)))
       (t (format "%8d" (buffer-size)))))

    (setq ibuffer-formats
          '((mark modified read-only " "
                  (name 50 50 :left :nil) " "
                  (size-h 9 -1 :right) " "
                  (mode 16 16 :left :elide) " "
                  filename-and-process)))))

(defun ztlevi-misc/post-init-evil ()
  (progn
    (push "TAGS" spacemacs-useless-buffers-regexp)

    (adjust-major-mode-keymap-with-evil "git-timemachine")
    (adjust-major-mode-keymap-with-evil "tabulated-list")

    (define-key evil-visual-state-map "p" 'evil-paste-after-from-0)

    ;; set search direction
    (setq isearch-forward t)

    ;;mimic "nzz" behaviou in vim
    (defadvice evil-search-next (after advice-for-evil-search-next activate)
      (evil-scroll-line-to-center (line-number-at-pos)))

    (defadvice evil-search-previous (after advice-for-evil-search-previous activate)
      (evil-scroll-line-to-center (line-number-at-pos)))

    ;; bind [, ] functions
    (define-key evil-normal-state-map (kbd "[ SPC") (lambda () (interactive) (evil-insert-newline-above) (forward-line)))
    (define-key evil-normal-state-map (kbd "] SPC") (lambda () (interactive) (evil-insert-newline-below) (forward-line -1)))
    (define-key evil-normal-state-map (kbd "[ b") 'previous-buffer)
    (define-key evil-normal-state-map (kbd "] b") 'next-buffer)

    (define-key evil-normal-state-map (kbd "M-y") 'counsel-yank-pop)

    (define-key evil-motion-state-map "\C-e" 'mwim-end-of-code-or-line)
    (define-key evil-ex-completion-map "\C-a" 'move-beginning-of-line)
    (define-key evil-ex-completion-map "\C-b" 'backward-char)
    (define-key evil-ex-completion-map "\C-k" 'kill-line)

    ;; visual-state-map
    (define-key evil-visual-state-map (kbd "C-r") 'ztlevi/evil-quick-replace)

    ;; set evil state cursor
    ;; (setq evil-normal-state-cursor '("#ff007f" box))
    ;; (setq evil-insert-state-cursor '("#ff007f" (bar . 2)))
    ;; (setq evil-hybrid-state-cursor '("#ff007f" (bar . 2)))
    ))

(defun ztlevi-misc/post-init-evil-surround ()
  (with-eval-after-load 'evil-surround
    (evil-define-key 'visual evil-surround-mode-map "s" 'evil-substitute)
    (evil-define-key 'visual evil-surround-mode-map "S" 'evil-surround-region)
    (evil-define-key 'visual evil-surround-mode-map "Cs" 'evil-surround-change)
    (evil-define-key 'visual evil-surround-mode-map "Ds" 'evil-surround-delete)))

(defun ztlevi-misc/init-visual-regexp ()
  (use-package visual-regexp
    :defer t
    :commands (vr/replace vr/query-replace)))

(defun ztlevi-misc/init-visual-regexp-steroids ()
  (use-package visual-regexp-steroids
    :defer t
    :commands (vr/select-replace vr/select-query-replace)
    :init
    (progn
      (global-set-key (kbd "C-c r") 'vr/replace)
      (global-set-key (kbd "C-c q") 'vr/query-replace))))

(defun ztlevi-misc/init-multiple-cursors ()
  (use-package multiple-cursors
    :defer t
    :init
    (progn
      (global-set-key (kbd "C-s-l") 'mc/edit-lines)
      (global-set-key (kbd "C-s-g") 'mc/mark-all-like-this)
      (global-set-key (kbd "C->")   'mc/mark-next-like-this)
      (global-set-key (kbd "C-<")   'mc/mark-previous-like-this)
      (global-set-key (kbd "s->")   'mc/unmark-next-like-this)
      (global-set-key (kbd "s-<")   'mc/unmark-previous-like-this)

      ;; add mouse click
      (global-unset-key (kbd "M-<down-mouse-1>"))
      (global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click)

      ;; http://endlessparentheses.com/multiple-cursors-keybinds.html?source=rss
      (define-prefix-command 'endless/mc-map)
      ;; C-x m is usually `compose-mail'. Bind it to something
      ;; else if you use this command.
      (define-key ctl-x-map "m" 'endless/mc-map)

;;; Really really nice!
      (define-key endless/mc-map "i" 'mc/insert-numbers)
      (define-key endless/mc-map "h" 'mc-hide-unmatched-lines-mode)
      (define-key endless/mc-map "a" 'mc/mark-all-like-this)

;;; Occasionally useful
      (define-key endless/mc-map "d" 'mc/mark-all-symbols-like-this-in-defun)
      (define-key endless/mc-map "r" 'mc/reverse-regions)
      (define-key endless/mc-map "s" 'mc/sort-regions)
      (define-key endless/mc-map "l" 'mc/edit-lines)
      (define-key endless/mc-map "\C-a" 'mc/edit-beginnings-of-lines)
      (define-key endless/mc-map "\C-e" 'mc/edit-ends-of-lines))
    :config
    (setq mc/always-repeat-command t)
    (setq mc/always-run-for-all t)

    (define-key mc/keymap (kbd "<return>") nil)))

(defun ztlevi-misc/post-init-persp-mode ()
  (setq persp-kill-foreign-buffer-action 'kill)
  (setq persp-lighter nil)
  (when (fboundp 'spacemacs|define-custom-layout)
    (spacemacs|define-custom-layout "@Hexo-Blog"
      :binding "h"
      :body
      (find-file "~/Developer/Github/hexo_blog/_config.yml")
      (split-window-right)
      (find-file "~/Developer/Github/hexo_blog/package.json"))))

(defun ztlevi-misc/post-init-chinese-wbim ()
  (progn
    (global-set-key (kbd ";") 'chinese-wbim-insert-ascii)
    (setq chinese-wbim-punc-translate-p nil)
    (spacemacs/declare-prefix "ot" "Toggle")
    (spacemacs/set-leader-keys
      "otp" 'chinese-wbim-punc-translate-toggle)
    (setq chinese-wbim-wb-use-gbk t)
    (add-hook 'chinese-wbim-wb-load-hook
              (lambda ()
                (let ((map (chinese-wbim-mode-map)))
                  (define-key map "-" 'chinese-wbim-previous-page)
                  (define-key map "=" 'chinese-wbim-next-page))))
    ))

(defun ztlevi-misc/post-init-projectile ()
  (progn
    (with-eval-after-load 'projectile
      (progn
        (setq projectile-completion-system 'ivy)
        (add-to-list 'projectile-other-file-alist '("html" "js"))
        (add-to-list 'projectile-other-file-alist '("js" "html"))))

    (defvar my-simple-todo-regex "\\<\\(FIXME\\|TODO\\|BUG\\):")
    (defun my-simple-todo ()
      "When in a project, create a `multi-occur' buffer matching the
  regex in `my-simple-todo-regex' across all buffers in the
  current project. Otherwise do `occur' in the current file."
      (interactive)
      (if (projectile-project-p)
          (multi-occur (projectile-project-buffers) my-simple-todo-regex)
        (occur my-simple-todo-regex)))
    (spacemacs/set-leader-keys "pt" 'my-simple-todo)))

(defun ztlevi-misc/post-init-prodigy ()
  (progn
    (prodigy-define-tag
      :name 'jekyll
      :env '(("LANG" "en_US.UTF-8")
             ("LC_ALL" "en_US.UTF-8")))
    ;; define service
    (prodigy-define-service
      :name "Leetcode Solution Website"
      :command "python"
      :args '("-m" "SimpleHTTPServer" "6005")
      :cwd "~/Developer/Github/leetcode"
      :tags '(leetcode)
      ;; if don't want to browse instantly, delete the following line
      :init (lambda () (browse-url "http://localhost:6005"))
      :kill-signal 'sigkill
      :kill-process-buffer-on-stop t)

    (prodigy-define-service
      :name "Hexo Blog Server"
      :command "hexo"
      :args '("server" "-p" "4000")
      :cwd blog-admin-dir
      :tags '(hexo server)
      :init (lambda () (browse-url "http://localhost:4000"))
      :kill-signal 'sigkill
      :kill-process-buffer-on-stop t)

    (prodigy-define-service
      :name "Hexo Blog Deploy"
      :command "hexo"
      :args '("deploy" "--generate")
      :cwd blog-admin-dir
      :tags '(hexo deploy)
      :kill-signal 'sigkill
      :kill-process-buffer-on-stop t)

    (prodigy-define-service
      :name "Hackathon backend"
      :env '(("REDISCLOUD_URL" "redis://rediscloud:MeQVSBSNp82uhej2QW42vQxV2TEcd5xq@redis-14678.c44.us-east-1-2.ec2.cloud.redislabs.com:14678"))
      :command "npm"
      :args '("run" "start")
      :cwd "~/Developer/Github/cryptocurrency_exchange_app/backend"
      :tags '(express)
      :init (lambda () (switch-to-buffer "*prodigy-hackathon-backend*"))
      :kill-signal 'sigkill
      :kill-process-buffer-on-stop t)

    (defun refresh-chrome-current-tab (beg end length-before)
      (call-interactively 'ztlevi/browser-refresh--chrome-applescript))
    ;; add watch for prodigy-view-mode buffer change event
    (add-hook 'prodigy-view-mode-hook
              #'(lambda() (set (make-local-variable 'after-change-functions) #'refresh-chrome-current-tab)))
    ))

(defun ztlevi-misc/post-init-erc ()
  (progn
    (add-hook 'erc-text-matched-hook 'my-erc-hook)
    (spaceline-toggle-erc-track-off)))

(defun ztlevi-misc/init-wrap-region ()
  (use-package wrap-region
    :defer t
    :init
    (progn
      (wrap-region-global-mode t)
      (wrap-region-add-wrappers
       '(("$" "$")
         ("{-" "-}" "#")
         ("/" "/" nil ruby-mode)
         ("/* " " */" "#" (java-mode javascript-mode css-mode js2-mode))
         ("`" "`" nil (markdown-mode ruby-mode))))
      (add-to-list 'wrap-region-except-modes 'dired-mode)
      (add-to-list 'wrap-region-except-modes 'web-mode))
    :config
    (spacemacs|hide-lighter wrap-region-mode)))

(defun ztlevi-misc/init-keyfreq ()
  (use-package keyfreq
    :init
    (progn
      (keyfreq-mode t)
      (keyfreq-autosave-mode 1))))

(defun ztlevi-misc/post-init-ivy ()
  (progn
    (setq ivy-wrap t)
    (setq ivy-display-style 'fancy)
    (setq ivy-initial-inputs-alist nil)
    (setq ivy-format-function (quote ivy-format-function-arrow))

    ;; force bind ivy-press-and-switch
    (defun ivy-press-and-switch ()
      (evil-local-set-key 'normal [return] #'ivy-occur-press-and-switch))
    (add-hook 'ivy-occur-grep-mode-hook #'ivy-press-and-switch)

    (define-key ivy-minibuffer-map (kbd "C-j") 'ivy-call-and-recenter)
    (define-key ivy-minibuffer-map (kbd "TAB") 'ivy-partial-or-done)
    (define-key ivy-minibuffer-map (kbd "C-<return>") 'ivy-immediate-done)))

(defun ztlevi-misc/post-init-p4 ()
  (with-eval-after-load 'p4
    (p4-set-p4-config "~/.p4config")))

(defun ztlevi-misc/post-init-magit ()
  (progn
    (with-eval-after-load 'magit
      ;; set magit display buffer way, need to be eval after magit
      (setq magit-display-buffer-function (quote magit-display-buffer-same-window-except-diff-v1))

      (add-to-list 'magit-no-confirm 'stage-all-changes)
      (setq magit-completing-read-function 'magit-builtin-completing-read)

      (magit-define-popup-switch 'magit-push-popup ?u "Set upstream" "--set-upstream"))

    ;; prefer two way ediff
    (setq magit-ediff-dwim-show-on-hunks t)

    (setq magit-push-always-verify nil)

    (setq magit-diff-use-overlays nil)
    (setq magit-use-overlays nil)

    ;; colorize magit log
    (setq magit-log-arguments (quote ("-n256" "--graph" "--decorate" "--color")))

    (setq magit-process-popup-time 10)))

(defun ztlevi-misc/post-init-counsel ()
  (setq counsel-find-file-ignore-regexp "\\(?:^[#.]\\)\\|\\(?:[#~]$\\)\\|\\(?:^Icon?\\)"
        counsel-describe-function-function 'helpful-callable
        counsel-describe-variable-function 'helpful-variable
        counsel-fzf-cmd "fzf -f %s"
        counsel-git-cmd "rg --files"
        ;; Add smart-casing and compressed archive searching (-zS) to default
        ;; command arguments:
        counsel-grep-base-command
        "rg -zS -M 120 --no-heading --line-number --color never '%s' %s"
        counsel-rg-base-command
        "rg -zS -M 120 --no-heading --line-number --color never %s ."))

(defun ztlevi-misc/init-wgrep-ag ()
  (use-package wgrep-ag
    :defer t))

(defun ztlevi-misc/init-rg ()
  (use-package rg
    :defer t
    :hook (rg-mode . wgrep-ag-setup)
    :config
    (setq rg-group-result t
          rg-command-line-flags '("--pcre2"))
    (evil-set-initial-state 'rg-mode 'normal)
    (evil-make-overriding-map rg-mode-map 'normal)))

(defun ztlevi-misc/init-magit-todos ()
  (use-package magit-todos
    :defer t
    :init
    (add-hook 'magit-status-mode-hook (apply-partially #'magit-todos-mode 1))
    :config
    ;; disable magit-todos-section-map, conflict wiht j key
    (setq magit-todos-section-map nil)))

(defun ztlevi-misc/post-init-magithub ()
  (progn
    (setq magithub-clone-default-directory "~/Developer/Github")

    (with-eval-after-load 'magit
      ;; define some popup options
      (magit-define-popup-action 'magithub-dispatch-popup
                                 ?P "Browse pull requests" #'magithub-pull-browse)
      (magit-define-popup-action 'magithub-dispatch-popup
                                 ?I "Browse issues" #'magithub-issue-browse))))

(defun ztlevi-misc/post-init-git-link ()
  (call-function--with-prefix-arg spacemacs/git-link)
  (call-function--with-prefix-arg spacemacs/git-link-copy-url-only)
  (call-function--with-prefix-arg spacemacs/git-link-commit)
  (call-function--with-prefix-arg spacemacs/git-link-commit-copy-url-only)
  (spacemacs/set-leader-keys
    "gll" 'spacemacs/git-link--C-u
    "glL" 'spacemacs/git-link-copy-url-only--C-u
    "glc" 'spacemacs/git-link-commit--C-u
    "glC" 'spacemacs/git-link-commit-copy-url-only--C-u)

  (eval-after-load 'git-link
    '(progn
       (add-to-list 'git-link-remote-alist
                    '("isl-122-ubuntu" git-link-gitlab))
       (add-to-list 'git-link-commit-remote-alist
                    '("isl-122-ubuntu" git-link-commit-gitlab)))))

(defun ztlevi-misc/post-init-flymd ()
  (setq flymd-close-buffer-delete-temp-files t)

  ;; flymd open browser
  (setq flymd-browser-open-function 'my-flymd-browser-function))

(defun ztlevi-misc/post-init-git-messenger ()
  (use-package git-messenger
    :defer t
    :config
    (define-key git-messenger-map (kbd "o") 'my-git-link-commit)
    (setq git-messenger:func-prompt (cons '(my-git-link-commit . "Browse Remote") git-messenger:func-prompt ))))

(defun ztlevi-misc/init-github-browse-file ()
  (use-package github-browse-file
    :defer t
    :commands (github-browse-file--relative-url)))

(defun ztlevi-misc/init-edit-indirect ()
  (use-package edit-indirect
    :defer t))

(defun ztlevi-misc/init-live-server ()
  (use-package live-server
    :defer t
    :commands (live-server-preview)))

(defun ztlevi-misc/pre-init-markdown-mode ()
  (add-to-list 'spacemacs--prettier-modes 'markdown-mode)
  (add-to-list 'spacemacs--prettier-modes 'gfm-mode))

(defun ztlevi-misc/post-init-markdown-mode ()
  (add-to-list 'auto-mode-alist '("\\.md\\'" . gfm-mode))

  (setq markdown-italic-underscore t)

  ;; set markdown inline iamge max size
  (setq markdown-max-image-size '(800 . 800))

  ;; define markdown keys
  (with-eval-after-load 'markdown-mode
    ;; (when (configuration-layer/package-usedp 'company)
    ;;   (spacemacs|add-company-hook markdown-mode))
    (dolist (mode markdown--key-bindings-modes)
      (spacemacs/set-leader-keys-for-major-mode mode
        "o" 'markdown-follow-link-at-point)
      (spacemacs/set-leader-keys-for-major-mode mode
        "D" 'my-flymd-delete-tmp-file)
      (spacemacs/set-leader-keys-for-major-mode mode
        "H" 'markdown-hide-body)
      (spacemacs/set-leader-keys-for-major-mode mode
        "S" 'markdown-show-all)
      (spacemacs/set-leader-keys-for-major-mode mode
        "dd" 'org-deadline)
      (spacemacs/set-leader-keys-for-major-mode mode
        "ds" 'org-schedule)
      (spacemacs/set-leader-keys-for-major-mode mode
        "dt" 'org-time-stamp)
      (spacemacs/set-leader-keys-for-major-mode mode
        "dT" 'org-time-stamp-inactive))

    (evil-define-key 'normal markdown-mode-map (kbd "TAB") 'markdown-cycle)
    (evil-define-key 'normal gfm-mode-map (kbd "TAB") 'markdown-cycle)

    (spacemacs//evil-org-mode)
    (evil-define-key 'normal markdown-mode-map (kbd "o") 'evil-org-open-below)
    (evil-define-key 'normal gfm-mode-map (kbd "o") 'evil-org-open-below)
    (evil-define-key 'normal markdown-mode-map (kbd "O") 'evil-org-open-above)
    (evil-define-key 'normal gfm-mode-map (kbd "O") 'evil-org-open-above)

    ;; bind key for edit code block
    (define-key markdown-mode-map (kbd "C-c '") 'markdown-edit-code-block)))
