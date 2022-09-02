(setq warning-minimum-level :emergency)

(load "/home/michael/Dropbox/3_Emacs/Common/Lisp_Scripts/1_Snippets.el")
;(load "/home/michael/Dropbox/3_Emacs/Common/mu4econf.el")

(setq default-directory "~/Dropbox/3_Emacs")
(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'load-path "/home/michael/Dropbox/3_Emacs/")

(setq package-check-signature nil)

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

;; Use-package initialisation but this is for non-linux platforms....
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

; Makes sure that it installs the package automatically if it isn't already
(setq use-package-always-ensure t)

(unless (require 'el-get nil t)
  (url-retrieve
   "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
   (lambda (s)
     (end-of-buffer)
     (eval-print-last-sexp))))

(use-package smex
  :bind (("M-x" . smex)))

(use-package elpy
  :ensure t
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable))

(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")

(setq elpy-rpc-virtualenv-path 'current)

(use-package code-cells
  :ensure t)

(defun python/scratch ()
  (interactive)
    (let (
          ;; Creates a new buffer object.
         (buf (get-buffer-create "*python-scratch*"))
         )
      ;; Executes functions that would change the current buffer at
      ;; buffer buf
     (with-current-buffer buf
       ;;; Set the new buffer to scratch mode
       (python-mode)
       ;;; Pop to scratch buffer
       (pop-to-buffer buf)
       )))

(defun text/scratch ()
  (interactive)
  (let ((buf (get-buffer-create "*text-scratch*")))
	(with-current-buffer buf
	  (text-mode)
	  (pop-to-buffer buf))))

(setq org-directory "/home/michael/Dropbox/1_Work/0_1_Vienna Work/0_Notes")

(setq org-startup-folded t)
(setq org-icalendar-timezone "Europe/Vienna")
(setq org-agenda-span 28)

(defun oa ()
  (interactive)
  (delete-other-windows)
  (split-window-right)
  (find-file "/home/michael/Dropbox/3_Emacs/1_Org_Files/1_Appointments.org")
  (other-window 1)
  (find-file "/home/michael/Dropbox/3_Emacs/1_Org_Files/2_Todo_Notes.org")
  (other-window 1))

(add-hook 'org-mode-hook (lambda () (setq electric-indent-mode nil)))
(add-hook 'org-mode-hook 'electric-quote-mode)
(add-hook 'org-mode-hook 'intra)

;(use-package org-tree-slide
;  :custom
;  (org-image-actual-width nil))

;(org-babel-do-load-languages
; 'org-babel-load-languages
; '((python . t)))

(defvar org-electric-pairs '((?\* . ?\*) (?/ . ?/)
                             (?\_ . ?\_)) "Electric pairs for org-mode.")

(defun org-add-electric-pairs ()
  (setq-local electric-pair-pairs (append electric-pair-pairs org-electric-add)))

;(pairs-hook 'org-mode-hook 'org-add-electric-pairs)
(add-hook 'org-mode-hook 'toggle-truncate-lines)

(defun rnf ()
  "Sort and renumber all footnotes in an org buffer."
  (interactive)
  (org-footnote-sort)
  (org-footnote-renumber-fn:N))

(defun dots ()
  (interactive)
  (insert "…"))

;(use-package ox-pandoc)
;(require 'ox-pandoc)

'(indent-tabs-mode nil)
(setq org-confirm-babel-evaluate nil)

(setq org-roam-v2-ack t)
(use-package org-roam)
(setq org-roam-directory (file-truename "/home/michael/Dropbox/1_Work/0_1_Vienna Work/0_Notes/"))

(org-roam-db-autosync-mode)

(setq org-default-notes-file "/home/michael/Dropbox/1_Work/0_1_Vienna Work/1_Sanskrit_Notes.org")
(global-set-key (kbd "C-c C-x l") 'org-roam-node-insert)

(setq reftex-default-bibliography '("/home/michael/Dropbox/1_MAIN_BIB.bib"))

(use-package org-ref
  :ensure t
  :config
  (setq reftex-default-bibliography '("/home/michael/Dropbox/7_Bibliography/1_MASTER.bib")))


(setq bibtex-completion-bibliography '("/home/michael/Dropbox/7_Bibliography/1_MASTER.bib"
					 "/home/michael/Dropbox/1_Work/0_1_Vienna Work/7_Bibliography/1_MASTER.bib"
					 "/home/michael/Dropbox/1_Work/0_1_Vienna Work/7_Bibliography/1_MASTER.bib"
					 "/home/michael/Dropbox/1_Work/0_1_Vienna Work/7_Bibliography/1_MASTER.bib")
	bibtex-completion-library-path '("~/Dropbox/emacs/bibliography/bibtex-pdfs/")
	bibtex-completion-notes-path "~/Dropbox/emacs/bibliography/notes/"
	bibtex-completion-notes-template-multiple-files "* ${author-or-editor}, ${title}, ${journal}, (${year}) :${=type=}: \n\nSee [[cite:&${=key=}]]\n"

	bibtex-completion-additional-search-fields '(keywords)
	bibtex-completion-display-formats
	'((article       . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${journal:40}")
	  (inbook        . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
	  (incollection  . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
	  (inproceedings . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
	  (t             . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*}"))
	bibtex-completion-pdf-open-function
	(lambda (fpath)
	  (call-process "open" nil 0 nil fpath)))
 
;(require 'org-ref-ivy)
(global-set-key (kbd "C-M-=") 'org-ref-insert-link)
(global-set-key (kbd "C-M-#") 'org-footnote-action)
(global-set-key (kbd "C-z") 'undo)

(defun biblify ()
  (interactive)
  (insert "#+csl-style:chicago-author-date-16th-edition.csl
bibliographystyle:unsrt
bibliography:/home/michael/Dropbox/7_Bibliography/1_MASTER.bib"))

(global-set-key (kbd "C-c l") 'org-ref-bibtex-hydra/body)

(use-package hydra
  :ensure t)

(global-set-key (kbd "C-c 9") 'hydra-navigation/body)
(global-set-key (kbd "C-c 7") 'hydra-org-roam/body)
(global-set-key (kbd "C-c 8") 'org-agenda)

(setq org-agenda-window-setup 'only-window)

(defhydra hydra-navigation ()
  "Navigating hydra"
  ("f"   (dired "/home/michael/Dropbox/1_Work/0_1_Vienna Work") "Vienna Work")
  ("e"   (dired "/home/michael/Dropbox/3_Emacs/Common") "emacs")
  ("d"   (dired "/home/michael/Desktop") "desktop")
  ("b"   (dired "/home/michael/Dropbox/1_Work/0_1_Vienna Work/2_Book/1_Phala") "book")
  ("m"   (find-file "/home/michael/Dropbox/3_Emacs/Common/new_main.el") "new_settings.org")
  ("o"   (find-file "/home/michael/Dropbox/3_Emacs/1_Org_Files/1_Appointments.org") "org")
  ("r"   (dired "/home/michael/Dropbox/") "dropbox")
  ("B"   (dired "/home/michael/Dropbox/7_Bibliography/") "Biblio")
  ("c"   (dired "/home/michael/Dropbox/MAIN_CV") "CV")
  ("p"   (dired "/home/michael/Dropbox/Python") "python")
  ("n"   (dired "/home/michael/Dropbox/1_Work/0_1_Vienna Work/0_Notes") "Notes")
  ("a"   (dired "/home/michael/Dropbox/1_Work/0_1_Vienna Work/5_Articles") "Articles")
  ("c"   (dired "/home/michael/Dropbox/1_Work/0_1_Vienna Work/6_Conferences") "Articles")
  ("i"   (dired "/home/michael/Dropbox/1_Work/0_1_Vienna Work/1_Isvaravada_Book") "Isvaravada")
  ("q"   (find-file "/home/michael/Dropbox/3_Emacs/Common/qute_quicklinks") "Qute quicklinks")
  ("Q"   (find-file "/home/michael/Dropbox/3_Emacs/Common/qute_quickmarks") "Qute quicklinks")
  ("s"   (call-interactively 'mike/find-all-files) "search dropbox"))

(defhydra hydra-org-roam ()
  "Sanskrit Hydra"
  ("f" (call-interactively 'find-name-dired) "search-dropbox")
  ("e" (dired "/home/michael/Dropbox/8_Essential_Texts") "essential texts")
  ("m" (dired "/home/michael/Dropbox/0_Storage/Manuscripts Nov") "manuscripts")
  ("s" (search-sastra-corpus) "search sastra corpus")
  ("p" (call-interactively 'mike/show-all-pdfs) "search through all academic pdfs")
  ("w" (call-interactively 'mike/sanskrit-lookup) "search for word in dictionaries")
  ("S" (search-corpus) "search corpus")
  ("c" (call-interactively 'crossref-lookup) "crossref add bibtex")
  ("o" (call-interactively 'org-roam-node-find) "find node")
  ("d" (call-interactively 'org-document-setup) "org document setup")
  ("t" (find-file "/home/michael/Dropbox/3_Emacs/1_Org_Files/Texts.org") "search texts")
  ("r" (helm-org-rifle-org-directory) "org rifle")
  ("b" (call-interactively 'doi-add-bibtex-entry) "bibtex by doi"))

(global-set-key (kbd "C-M-;") 'hydra-org-roam/body)

(defvar my-keys-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-o") 'next-line)
    (define-key map (kbd "C-j") 'backward-word)
    (define-key map (kbd "M-n") 'forward-paragraph)
    ;(define-key map (kbd "C-n") 'open-line)
    map)
  "my-keys-minor-mode keymap.")

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  :init-value t
  :lighter "my-keys")

(my-keys-minor-mode 1)

; Adjusted
(use-package ido-vertical-mode)
(ido-mode 1)
(ido-vertical-mode 1)
(setq ido-vertical-define-keys 'C-n-and-C-p-only)
;(setq ido-enable-flex-matching t)
;(setq ido-everywhere t)

(quail-set-keyboard-layout "pc105-uk")
(quail-update-keyboard-layout "pc105-uk")
(setq quail-keyboard-layout-type "pc105-uk")

; These lines are to stop that annoying *Async Shell Command* window from opening.
(defadvice async-shell-command (around hide-async-windows activate)
  (save-window-excursion
    ad-do-it))

;; Make EXWM start at 1 rather than 0 for workspaces.
(setq exwm-workspace-index-map (lambda (i) (number-to-string (1+ i))))

(define-key global-map (kbd "C-c <return>") 'exwm-workspace-move-window)

;; Interface settings
;; Necessary so you can switch to an EXWM supported program in a different workspace.
;(setq exwm-layout-show-all-buffers t)

(use-package helm-exwm
  :ensure t
  :config
  (setq helm-exwm-emacs-buffers-source (helm-exwm-build-emacs-buffers-source))
  (setq helm-exwm-source (helm-exwm-build-source))
  (setq helm-mini-default-sources `(helm-exwm-emacs-buffers-source
                                    helm-exwm-source
                                    helm-source-recentf)))

(defun helm-exwm-switch-to-previous-buffer ()
  (interactive)
  (setq a (car (last (helm-exwm-candidates))))
  (switch-to-buffer a))

(defun helm-exwm-switch-to-next-buffer ()
  (interactive)
  (if (eq (length (helm-exwm-candidates)) 2)
      (let ()
	(setq a (car (helm-exwm-candidates)))
	(switch-to-buffer a)))
  (if (> (length (helm-exwm-candidates)) 2)
      (let ()
	(setq a (first (cdr (helm-exwm-candidates))))
	(switch-to-buffer a))
    (let ()
      (setq a (first (cdr (helm-exwm-candidates))))
      (switch-to-buffer a))))

;; Control brightness using brightnessctl

(defun mike/increase-brightness ()
  (interactive)
  (async-shell-command "brightnessctl set +5%"))

(defun mike/decrease-brightness ()
  (interactive)
  (async-shell-command "brightnessctl set 5%-"))

(define-key global-map (kbd "<XF86MonBrightnessUp>") 'mike/increase-brightness)
(define-key global-map (kbd "<XF86MonBrightnessDown>") 'mike/decrease-brightness)

;; Make it easier to run dmenu
(use-package dmenu)

(defun run-dmenu ()
  (interactive)
  (shell-command "dmenu_run"))

(global-set-key (kbd "C-c C-d") 'run-dmenu)

(defun run-program ()
  (interactive)
  (setq program (read-string "Enter the program: "))
  (async-shell-command program))

(defun run-rofi ()
  (interactive)
  (call-process-shell-command "rofi -show run"))

(require 'itrans-sa)

(defun switch-trans-dev ()
  "Switches to transliteration if in devanagari and vice versa."
  (interactive)
  (if (equal current-input-method "iast-postfix")
      (set-input-method "devanagari-kyoto-harvard")
    (set-input-method "iast-postfix")))

(global-set-key (kbd "M-p") 'mike/backward-paragraph)
(global-set-key (kbd "C-~") 'other-window)
;(global-set-key (kbd "M-e") 'helm-exwm)

(defun print-entire-bibtex ()
  (interactive)
  (async-shell-command "python3 /home/michael/Dropbox/Python/1_Bib_Manager/Final/final.py > /home/michael/Dropbox/Python/1_Bib_Manager/Final/Current_Entries_Text.org\n")
  (dired "/home/michael/Dropbox/Python/1_Bib_Manager/Final/"))

;; Use define-mode-abbrev to enter new abbreviations for org mode

(setq abbrev-mode t)
(setq org-src-preserve-indentation t)

(defun mike/insert-org-headers ()
  """Insert the headers you would normally use to publish a document in Latex/ODT."""
  (interactive)
  (insert "#+TITLE: 
#+SUBTITLE: 
#+AUTHOR: 
#+LATEX_CLASS: 
#+LATEX_CLASS_OPTIONS: [letterpaper]
#+OPTIONS: toc:nil"))

(global-hl-line-mode)
 
;; Stuff for TEI critical editing

(defun tei/highlight-next-apparatus-entry ()
  (interactive)
  (search-backward "\"")
  (forward-char)
  (set-mark-command nil)
  (search-forward "\"")
  (backward-char)
  (copy-region-as-kill (region-beginning) (region-end))
  (switch-to-buffer "apparatus.xml")
  (unhighlight-regexp t)
  (highlight-lines-matching-regexp (car kill-ring) 'hi-yellow)
  (switch-to-buffer "output.xml"))

(defun open-thunar ()
  (interactive)
  (async-shell-command (concat "thunar " (s-replace " " "\\ " default-directory))))

(defun open-thunar-desktop ()
  (interactive)
  (async-shell-command "thunar /home/michael/Desktop"))

(require 'exwm-systemtray)
(exwm-systemtray-enable)
; Need to set height, otherwise tray won't always appear
(setq exwm-systemtray-height 24)

(display-time-mode 1)
(display-battery-mode 1)

; Startup applications
;(call-process-shell-command "blueman-manager" nil 0)
(call-process-shell-command "/opt/dropbox/dropboxd" nil 0)
;(start-process "dropboxd" "new_buffer" "/opt/dropbox/dropboxd")

; These should enable the clipboard
(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

; EXWM Settings

(defun exwm-logout ()
  (interactive)
  (recentf-save-list)
  (save-some-buffers)
  (start-process-shell-command "logout" nil "lxsession-logout"))

(require 'exwm-randr)
(setq exwm-randr-workspace-output-plist '(1 "eDP"))
(add-hook 'exwm-randr-screen-change-hook
          (lambda ()
            (start-process-shell-command
             "xrandr" nil "xrandr --output eDP --right-of HDMI-A-0 --auto")))
(exwm-randr-enable)

(require 'exwm)
(require 'exwm-config)
;(exwm-enable)
(exwm-config-default)
(set-frame-parameter nil 'fullscreen 'fullboth)

(require 'exwm-xim)
;(exwm-xim-enable)
;(push ?\C-\\ exwm-input-prefix-keys)   ;; use Ctrl + \ to switch input method

;; These keys should always pass through to Emacs
(setq exwm-input-prefix-keys
      '(?\C-x
	?\C-u
	?\C-h
	?\M-x
	?\M-`
	?\M-&
	?\M-:
	?\M-s
	?\C-\M-j
	?\M-h
	?\C-\M-l
	?\M-j
	?\M-k
	?\M-l
	?\M-i
	?\M-u
	?\M-q
	?\M-Q
	?\C-o
	;; This next one is the alt-space key
	134217760
	?\s-`
	?\C-\s-j
	?\C-\s-l
	?\C-\
        ?\s-!
        ?\s-\"
	?\s-£
	?\s-$
	?\s-%
	?\s-^
	?\s-&
	?\s-*
	?\s-\(
	?\s-\)
	))

(defun mike/move-to-other-window ()
  (interactive)
  (other-window 1))

; Global-EXWM key bindgs
(setq exwm-input-global-keys
      `(([?\s-r] . exwm-reset)
	(,(kbd "s-n") . helm-exwm-switch-to-next-buffer)
	(,(kbd "s-q") . delete-window)
	(,(kbd "s-Q") . delete-other-windows)
	(,(kbd "s-a") . dmenu)
        (,(kbd "s-z") . ivy-switch-buffer)
	(,(kbd "s-m") . mike/open-scratch-bottom)	
	(,(kbd "s-f") . open-thunar)
	(,(kbd "M-<tab>") . mike/move-to-other-window)
        (,(kbd "s-F") . open-thunar-desktop)
        (,(kbd "s-p") . hydra-org-roam/body)
	(,(kbd "s-t") . shell)
	(,(kbd "C-o") . next-line)
	(,(kbd "<s-tab>") . helm-exwm-switch-to-next-buffer)
	(,(kbd "s-d") . mike/start-rofi)
	(,(kbd "s-SPC") . mike/start-rofi-windows)
	(,(kbd "<s-q>") . helm-exwm)
	(,(kbd "s-k") . windmove-up)
	(,(kbd "s-j") . windmove-down)
	(,(kbd "s-h") . windmove-left)
	(,(kbd "s-l") . windmove-right)
	(,(kbd "s-s") . resize-window)
	(,(kbd "<s-down>") . shrink-window)
	(,(kbd "<s-up>") . enlarge-window)
	(,(kbd "<s-right>") . enlarge-window-horizontally)
	(,(kbd "<s-left>") . shrink-window-horizontally)
	(,(kbd "s-o") . org-roam-node-find)
	(,(kbd "s-H") . windmove-swap-states-left)
	(,(kbd "s-J") . windmove-swap-states-down)
	(,(kbd "s-K") . windmove-swap-states-up)
	(,(kbd "s-L") . windmove-swap-states-right)		
	(,(kbd "C-s-f") . enlarge-window-horizontally)
	(,(kbd "C-s-o") . enlarge-window)
	(,(kbd "C-s-p") . shrink-window)
	(,(kbd "C-s-b") . shrink-window-horizontally)
	(,(kbd "s-i") . split-window-horizontally)
	(,(kbd "s-u") . split-window-vertically)
        (,(kbd "<s-f2>") . emms-volume-mode-minus)
	(,(kbd "<s-f3>") . emms-volume-mode-plus)
        (,(kbd "<XF86AudioRaiseVolume>") . emms-volume-mode-plus)
        (,(kbd "<XF86AudioLowerVolume>") . emms-volume-mode-minus)	
        ([?\s-w] . exwm-workspace-switch)
        ,@(mapcar (lambda (i)
                    `(,(kbd (format "s-%d" i)) .
                      (lambda ()
                        (interactive)
                        (exwm-workspace-switch-create ,i))))
                  (number-sequence 0 9))))

(use-package deadgrep)
(setq deadgrep-max-buffers 1)

(defun search-corpus ()
  "Search through the Sanskrit text corpus using deadgrep."
  (interactive)
  (setq search-term (read-from-minibuffer "Sanskrit text: "))
  (dired "/home/michael/Dropbox/1_Work/0_Corpus")
  (deadgrep search-term))

(global-set-key (kbd "C-x C-j") 'dired/open-current-directory)

(use-package all-the-icons-dired)

(defun dired/open-current-directory ()
  (interactive)
  (dired default-directory))

;(add-hook 'dired-mode-hook (lambda () (dired-icon-mode)))

;; Tool selection may be jedi, or anaconda-mode. This script settle it
;; down with anaconda-mode.
(use-package company
 :ensure t
 :config
 (setq company-idle-delay 0
       company-minimum-prefix-length 2
       company-show-numbers t
       company-tooltip-limit 10
       company-tooltip-align-annotations t
       ;; invert the navigation direction if the the completion popup-isearch-match
       ;; is displayed on top (happens near the bottom of windows)
       company-tooltip-flip-when-above t))

(use-package anaconda-mode
  :ensure t
  :config
  (add-hook 'python-mode-hook 'anaconda-mode)
  (add-hook 'python-mode-hook 'anaconda-eldoc-mode))

(use-package company-anaconda
  :ensure t
  :init (require 'rx)
  :after (company)
  :config
  (add-to-list 'company-backends 'company-anaconda))

(use-package company-quickhelp
  ;; Quickhelp may incorrectly place tooltip towards end of buffer
  ;; See: https://github.com/expez/company-quickhelp/issues/72
  :ensure t)

;(add-to-list 'python-shell-extra-pythonpaths "/home/michael/Documents/Interview")

(setq user-mail-address	"michael.williams@oeaw.ac.at"
      user-full-name	"Michael Thomas Williams")

(setq gnus-select-method '(nnimap "Inbox"
                                  (nnimap-address "exchange.oeaw.ac.at")
                                  (nnimap-server-port 993)
                                  (nnimap-stream tls)))

;(setq send-mail-function		'smtpmail-send-it
;      message-send-mail-function	'smtpmail-send-it
;      smtpmail-smtp-server		"exchange.oeaw.ac.at")


(setq smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")

;;; God mode stuff

(use-package god-mode)

(defun my-god-mode-update-cursor ()
  (setq cursor-type (if (or god-local-mode buffer-read-only)
                        'box
                      'bar)))

(add-hook 'god-mode-enabled-hook #'my-god-mode-update-cursor)
(add-hook 'god-mode-disabled-hook #'my-god-mode-update-cursor)

;(global-set-key (kbd "<escape>") #'god-local-mode)

; Set to t if you want to retain the transliteration, nil if you just want to have no input method
(setq block-input-toggle nil)

(defun iast-mode ()
  "Switches input toggle when activating god mode on/off."
  (interactive)
  (if (equal block-input-toggle nil)
      (setq block-input-toggle t)
    (setq block-input-toggle nil)))

(defun me/switch-input-method ()
  (interactive)
  (if (or (string= current-input-method "iast-postfix") (string= current-input-method "devanagari-kyoto-harvard"))
      (toggle-input-method)))

(setq old-input-method nil)

(defun mike/god-mode-on-switch-im ()
  (interactive)
  (setq old-input-method current-input-method-title)
  (deactivate-input-method))

(defun mike/god-mode-off-switch-im ()
  (interactive)
  (if (string= old-input-method "InR<")
      (set-input-method "iast-postfix"))
  (if (string= old-input-method "DevKH")
      (set-input-method "devanagari-kyoto-harvard")))

;(add-hook 'god-mode-enabled-hook #'me/switch-input-method)
;(add-hook 'god-mode-disabled-hook #'toggle-input-method)
;(add-hook 'god-mode-disabled-hook (lambda () (if (equal block-input-toggle nil)
;	       (toggle-input-method))))

(add-hook 'god-mode-enabled-hook #'mike/god-mode-on-switch-im)
(add-hook 'god-mode-disabled-hook #'mike/god-mode-off-switch-im)

;(shell-command "setxkbmap -layout gb")
;(shell-command "xmodmap /home/michael/modmap")

(define-key god-local-mode-map (kbd ".") #'repeat)
(define-key god-local-mode-map (kbd "i") #'god-local-mode)
(define-key god-local-mode-map (kbd "z") #'repeat)
;(shell-command "/home/michael/footremap.sh")

;; insert evil mode stuff here

(defun write-file-copy (filename)
  (interactive "F")
  (write-region (point-min) (point-max) filename))

(define-key god-local-mode-map (kbd "C-S-A") 'cn)
(define-key god-local-mode-map (kbd "C-S-Q") 'cs)

(defun mark-whole-word (&optional arg allow-extend)
  "Like `mark-word', but selects whole words and skips over whitespace.
If you use a negative prefix arg then select words backward.
Otherwise select them forward.

If cursor starts in the middle of word then select that whole word.

If there is whitespace between the initial cursor position and the
first word (in the selection direction), it is skipped (not selected).

If the command is repeated or the mark is active, select the next NUM
words, where NUM is the numeric prefix argument.  (Negative NUM
selects backward.)"
  (interactive "P\np")
  (let ((num  (prefix-numeric-value arg)))
    (unless (eq last-command this-command)
      (if (natnump num)
          (skip-syntax-forward "\\s-")
        (skip-syntax-backward "\\s-")))
    (unless (or (eq last-command this-command)
                (if (natnump num)
                    (looking-at "\\b")
                  (looking-back "\\b")))
      (if (natnump num)
          (left-word)
        (right-word)))
    (mark-word arg allow-extend)))

(defun italicise-word ()
  (interactive)
  (save-excursion
    (goto-char (region-beginning))
    (insert "/"))
  (goto-char (region-end))
  (insert "/"))

(defun boldify-word ()
  (interactive)
  (save-excursion
    (goto-char (region-beginning))
    (insert "*"))
  (goto-char (region-end))
  (insert "*"))

(defun editing/delete-next-quotations ()
  (interactive)
  (search-forward "\"")
  (set-mark-command nil)
  (search-forward "\"")
  (backward-char)
  (kill-region (region-beginning) (region-end)))

(define-key god-local-mode-map (kbd "C-S-E") 'italicise-word)
(define-key god-local-mode-map (kbd "C-S-F") 'forward-word)
(define-key god-local-mode-map (kbd "C-S-B") 'backward-word)
(define-key god-local-mode-map (kbd "C-S-S") 'mike/superscript)
(define-key god-local-mode-map (kbd "C-\"") 'editing/delete-next-quotations)

;(set-fringe-mode 10)

(defun insert-danda ()
  (interactive)
  (insert "|"))

(global-set-key "¬" 'insert-danda)

;(async-shell-command "tint2")
;(async-shell-command "nm-applet")
;(global-set-key (kbd "M-n") 'forward-word)

;; This just makes sure that C-o is always bound to next-line

(defvar my-keys-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-o") 'next-line)
    (define-key map (kbd "C-j") 'next-word)
    ;(define-key map (kbd "C-n") 'open-line)
    map)
  "my-keys-minor-mode keymap.")

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  :init-value t
  :lighter " my-keys")

(my-keys-minor-mode 1)

(defun org-superscript (start end)
  (interactive "r")
  (save-excursion)
  (goto-char end) (insert "}")
  (goto-char start) (insert "^{"))

(defun show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name))
  (insert buffer-file-name)
  (kill-new (file-truename buffer-file-name)))

(defun angular ()
  "Insert some angular brackets"
  (interactive)
  (insert "⟨⟩")
  (backward-char 1))

(defun indev ()
  (interactive)
  (set-input-method "devanagari-kyoto-harvard"))

(defun intra ()
  (interactive)
  (set-input-method "iast-postfix"))

(defun inger ()
  (interactive)
  (set-input-method "german"))

(defun dots ()
  (interactive)
  (insert "…"))

(global-set-key (kbd "↓") (lambda () (interactive) (insert "ü")))
(global-set-key (kbd "ø") (lambda () (interactive) (insert "ö")))
(global-set-key (kbd "æ") (lambda () (interactive) (insert "ä")))
(global-set-key (kbd "Æ") (lambda () (interactive) (insert "Ä")))
(global-set-key (kbd "Ø") (lambda () (interactive) (insert "Ö")))
(global-set-key (kbd "↑") (lambda () (interactive) (insert "Ü")))

(defun transliterate-iast (text)
  (interactive)
  (insert (shell-command-to-string (concat "python /home/michael/Dropbox/Python/convert_to_dev.py " text))))

(defun nxml-where ()
  "Display the hierarchy of XML elements the point is on as a path."
  (interactive)
  (let ((path nil))
    (save-excursion
      (save-restriction
	(widen)
	(while (and (< (point-min) (point)) ;; Doesn't error if point is at beginning of buffer
		    (condition-case nil
			(progn
			  (nxml-backward-up-element) ; always returns nil
			  t)
		      (error nil)))
	  (setq path (cons (xmltok-start-tag-local-name) path)))
	(if (called-interactively-p t)
	    (message "/%s" (mapconcat 'identity path "/"))
	  (format "/%s" (mapconcat 'identity path "/")))))))

(defun cs ()
  "This helps to make a new bibliography from the main ones. Just select the entry you want to put into the new bibliography, and it's copied over to the buffer new.bib. This can then be saved to a file and processed with a script."
  (interactive)
  (bibtex-mark-entry)
  (kill-ring-save (region-beginning) (region-end))
  (get-buffer-create "new_sanskrit.bib")
  (with-current-buffer "new_sanskrit.bib" (insert "\n\n\n"))
  (with-current-buffer "new_sanskrit.bib" (insert (car kill-ring))))

(defun cn ()
  "This helps to make a new bibliography from the main ones. Just select the entry you want to put into the new bibliography, and it's copied over to the buffer new.bib. This can then be saved to a file and processed with a script."
  (interactive)
  (bibtex-mark-entry)
  (kill-ring-save (region-beginning) (region-end))
  (get-buffer-create "new_normal.bib")
  (with-current-buffer "new_normal.bib" (insert "\n\n\n"))
  (with-current-buffer "new_normal.bib" (insert (car kill-ring))))

(use-package ivy :demand
  ;; diminish ensures that the minor mode doesn't show on the modeline
  :diminish
  :config
  (setq ivy-use-virtual-buffers t
	ivy-count-format "%d/%d ")
  (ivy-mode 1))

(use-package swiper)
(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "C-r") 'swiper-isearch-backward)
(setq ivy-display-style 'fancy)

;; Automatically tangle our Emacs.org config file when we save it
(defun efs/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/Dropbox/3_Emacs/Common/main_config.org"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

;(use-package auctex)

;(use-package org2blog)

;(setq org2blog/wp-blog-alist
;      '(("myblog"
;         :url "http://nyayaloka.wordpress.com/xmlrpc.php"
;         :username "mikew2801@gmail.com")))

(use-package emms)

(defun vol ()
  (interactive)
  (async-shell-command "pavucontrol --tab=3"))

(defun start-brave ()
  (interactive)
  (async-shell-command "brave"))

(global-set-key (kbd "<f5>") 'start-brave)

(global-set-key (kbd "<s-f1>") 'emms-volume-mode-minus)
(global-set-key (kbd "<s-f2>") 'emms-volume-mode-plus)

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package expand-region
  :ensure t
  :after er/expand-region)

(use-package neotree
  :ensure t)

(use-package ediff
  :config (set 'ediff-window-setup-function 'ediff-setup-windows-plain))

(setq ediff-diff-options "--text")

(use-package popper
  :ensure t
  :bind (("M-`"   . popper-kill-latest-popup)
         ("C-M-`" . popper-toggle-latest))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          help-mode
          compilation-mode))
  (popper-mode +1))

(popper-mode 1)

(use-package dashboard
  :ensure t
  :config
    (dashboard-setup-startup-hook)
    (setq dashboard-startup-banner "~/Dropbox/3_Emacs/dashLogo.png")
    (setq dashboard-items '((recents  . 10)
                            (agenda . 10)))
    (setq dashboard-banner-logo-title "ARCH-EMACS-EXWM"))

(add-to-list 'load-path "~/.emacs.d/lisp/")
;(load "org-bullets.el")
(require 'org-bullets)
(setq org-bullets-bullet-list '("◉" "○" "✸" "✮" "▶"))
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(use-package arch-packer)

;(use-package pdf-tools)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 12)))

(use-package erc
  :ensure t
  :defer t)

(use-package general)
(general-define-key
 "C-M-j" 'ivy-switch-buffer)

(use-package all-the-icons)

(use-package elfeed)

(setq elfeed-feeds
      '("https://archlinux.org/feeds/news/"
        "https://planet.emacslife.com/atom.xml"
        "https://www.anarchistfederation.net/"
        "http://blog.practicalethics.ox.ac.uk/feed/"
        "http://aphilosopher.drmcl.com/feed/"
	"https://weekly.nixos.org/feeds/all.rss.xml"
        "https://friendlyatheist.patheos.com/feed/"
	"https://feministphilosophers.wordpress.com/feed/"))

(use-package slime)
(setq inferior-lisp-program "sbcl")

(remove-hook 'kill-emacs-hook 'pcache-kill-emacs-hook)
(global-set-key (kbd "C-c C-r") 'recentf-open-files)

(setq browse-url-browser-function 'browse-url-generic browse-url-generic-program "qutebrowser")

(define-key global-map (kbd "C-M-j") 'ivy-switch-buffer)
(define-key global-map (kbd "s-p") 'hydra-org-roam/body)

(global-set-key (kbd "<C-M-return>") 'eshell)

(defun open-org-agenda ()
  (interactive)
  (find-file "/home/michael/Dropbox/3_Emacs/1_Org_Files/1_Appointments.org"))

(define-key dired-mode-map [mouse-2] 'dired-mouse-find-file)

(global-set-key (kbd "C-=") 'er/expand-region)

(global-unset-key (kbd "C-t"))
(push ?\C-t exwm-input-prefix-keys)

(exwm-input-set-key (kbd "C-t v") 'pavucontrol)
(exwm-input-set-key (kbd "C-t t") 'eshell)

(global-set-key (kbd "C-t f")  'mike/org-sort-renumber-footnotes)

(global-set-key (kbd "C-q") 'forward-word)
(global-set-key (kbd "C-j") 'backward-word)
(global-set-key (kbd "M-n") 'forward-paragraph)

(global-set-key (kbd "M-f") 'forward-sentence)
(global-set-key (kbd "M-b") 'backward-sentence)
(global-set-key (kbd "s-`") 'helm-exwm)

(defun xmm ()
  (interactive)
  (shell-command "setxkbmap -layout gb")
  (shell-command "xmodmap /home/michael/modmap"))

(defun run-mm ()
  (interactive)
  (shell-command "xmodmap /home/michael/modmap"))

(global-set-key (kbd "C-c m") 'xmm)

(defun insert-danda ()
  (interactive)
  (insert "|"))

(global-set-key "¬" 'insert-danda)

(defun bull ()
  (interactive)
  (insert "•"))

(defun dhc ()
  (interactive)
  (insert "☸"))

(global-set-key (kbd "C-c 3") 'open-scratch-bottom)

(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-x w") 'counsel-web-search)

;; Preserve the open line functionality
(global-set-key (kbd "C-M-o") 'open-line)

(global-set-key (kbd "M-[") 'previous-buffer)
(global-set-key (kbd "M-]") 'next-buffer)

(defun insert-zero-width-space ()
  (interactive)
  (insert-char ?\u200B))

(global-set-key (kbd "C-c s") 'insert-zero-width-space)

(defun buffer/copy-path ()
  (interactive)
  (clipboard/set (file-name-directory (buffer-file-name)))
  (message "Copied file path to clipboard"))

(global-set-key (kbd "C-t b") 'buffer/copy-path)

(defun text/scratch ()
  (interactive)
    (let (
         (buf (get-buffer-create "text-scratch")))
     (with-current-buffer buf
       (text-mode)
       (pop-to-buffer buf))))

(setq abbrev-file-name "~/Dropbox/3_Emacs/Common/.abbrev_defs")

(setq dired-guess-shell-alist-user
    '(("\\.pdf\\'" "okular")
      ("\\.odt\\'" "libreoffice")))

(use-package openwith)
(openwith-mode t)

(setq openwith-associations '(("\\.pdf\\'" "okular" (file))
			      ("\\.tif\\'" "viewnior" (file))))


(setq dired-guess-shell-alist-user '(("\\.pdf\\'" "okular")
                                   ("\\.doc\\'" "libreoffice")
                                   ("\\.docx\\'" "libreoffice")
                                   ("\\.ppt\\'" "libreoffice")
                                   ("\\.pptx\\'" "libreoffice")
                                   ("\\.xls\\'" "libreoffice")
                                   ("\\.xlsx\\'" "libreoffice")
                                   ("\\.jpg\\'" "viewnior")
                                   ("\\.png\\'" "viewnior")
                                   ("\\.java\\'" "idea")))

;'(org-src-preserve-indentation nil)
(setq sentence-end-double-space nil)
(setq show-trailing-whitespace t)
(setq ring-bell-function 'ignore)

;; Turn on line numbers

(column-number-mode)
(global-display-line-numbers-mode t)

;; Turn line numbers off for various modes

(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook
		eww-mode))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;(add-hook 'org-mode-hook (lambda () (god-mode-activate)))
;(unicode-fonts-setup)

;; For use in converting docx/odt files to org mode using pandoc

'(indent-tabs-mode nil)
'(org-src-preserve-indentation nil)

(define-key dired-mode-map [mouse-2] 'dired-mouse-find-file)

(setq org-confirm-babel-evaluate nil)

(defun cas ()
  (interactive)
  (shell-command "import -window root /home/michael/Documents/screenshot.png"))

(global-set-key (kbd "C-t s") 'cas)

(defun org-document-setup ()
  (interactive)
  (switch-to-buffer "new-org-file")
  (org-mode)
  (intra)
  (insert "#+TITLE:
#+LATEX_HEADER_EXTRA: \\usepackage{polyglossia,fontspec,xunicode}
#+LATEX_HEADER_EXTRA: \\setmainfont[Ligatures=TeX]{Linux Libertine O}
#+LATEX_HEADER_EXTRA: \\usepackage[a4paper, total={6in, 8in}]{geometry}

"))

;(call-process-shell-command "blueman-applet" nil 0)
(async-shell-command "nm-applet")
(call-process-shell-command "dropbox start" nil 0)
;(call-process-shell-command "tint2" nil 0)
;(call-process-shell-command "polybar example --config=~/.config/polybar/config" nil 0)
;(call-process-shell-command "tint2 -c /home/michael/Dropbox/3_Emacs/Common/tint2conf/arcolinux-arc-dark.tint2rc" nil 0)

(defun sdropbox ()
  (interactive)
  (call-process-shell-command "dropbox start" nil 0))

;(god-mode)

(defun mike/start-rofi ()
  (interactive)
  (call-process-shell-command "rofi -modi drun,run -show drun -show-icons"))

(defun mike/start-rofi-windows ()
  (interactive)
  (call-process-shell-command "exec rofi -modi window -show window -show-icons"))

(add-hook 'org-mode-hook 'abbrev-mode)

(defun search-sastra-corpus ()
  "Search through the Sanskrit text corpus using deadgrep."
  (interactive)
  (setq search-term (read-from-minibuffer "Sanskrit text: "))
  (dired "/home/michael/Dropbox/1_Work/0_Corpus/6_sastra")
  (deadgrep search-term))

(use-package openwith)
(openwith-mode t)

(setq openwith-associations '(("\\.pdf\\'" "okular" (file))
			      ("\\.tif\\'" "phototonic" (file))
			      ("\\.odt\\'" "libreoffice" (file))
			      ("\\.jpg\\'" "phototonic" (file))))

(use-package slime)
(setq inferior-lisp-program "sbcl")
(setq neo-smart-open t)

(defun mike/bind-alt-window-buttons ()
  (interactive)
  (define-key org-mode-map (kbd "M-h") nil)
  (define-key global-map (kbd "C-M-j") 'windmove-down)
  (define-key global-map (kbd "C-M-k") 'windmove-up)
  (define-key global-map (kbd "C-M-l") 'windmove-right)
  (define-key global-map (kbd "C-M-h") 'windmove-left)
  (define-key global-map (kbd "M-i") 'split-window-right)
  (define-key global-map (kbd "M-u") 'split-window-below))

(mike/bind-alt-window-buttons)

;(define-key global-map (kbd "M-s M-s") 'window-swap-states)
(define-key global-map (kbd "C-x p") 'back-one-window)
(global-set-key (kbd "<C-M-return>") 'eshell)

(defun back-one-window ()
  (interactive)
  (other-window -1))

(add-hook 'minibuffer-setup-hook 'intra)

;(defun efs/configure-window-by-class ()
;  (interactive)
;  (pcase exwm-class-name
;    ("Brave-browser" (exwm-workspace-move-window 0))
;    ("firefox" (exwm-workspace-move-window 0))
;    ("qutebrowser" (exwm-workspace-move-window 0))))

(setq exwm-workspace-number 4)
;(add-hook 'exwm-manage-finish-hook #'efs/configure-window-by-class)

(defun efs/exwm-init-hook ()
  ;; Make workspace 1 be the one where we land at startup
  (exwm-workspace-switch-create 0))

;(add-hook 'exwm-init-hook #'efs/exwm-init-hook)

(defun mike/open-connect ()
  (interactive)
  (shell)
  (insert "sudo openconnect webvpn.oeaw.ac.at -u mwilliams"))

(define-key global-map (kbd "<M-SPC>") 'ivy-switch-buffer)
;(define-key global-map (kbd "M-q") 'god-local-mode)
(define-key global-map (kbd "C-M-g") 'dired)

(defun mike/open-dired ()
  (interactive)
  (if (buffer-file-name)
      (dired (file-name-directory (buffer-file-name)))
    (dired "/home/michael/Dropbox/3_Emacs/Common/")))

(defun mike/delete-sentence ()
  (interactive)
  (zap-to-char 1 ?.))

(defun mike/open-firefox ()
  (interactive)
  (async-shell-command "firefox"))

(defun mike/open-qutebrowser ()
  (interactive)
  (async-shell-command "qutebrowser"))

(define-key global-map (kbd "C-M-;") 'mike/open-dired)
(define-key global-map (kbd "M-o") 'mike/forward-paragraph)
(define-key global-map (kbd "s-t") 'shell)
(define-key global-map (kbd "s-e") 'eshell)
(define-key global-map (kbd "s-o") 'org-roam-node-find)
(define-key global-map (kbd "C-M-d") 'mike/delete-sentence)
(define-key global-map (kbd "s-b") 'mike/open-qutebrowser)
(define-key global-map (kbd "M-q") 'delete-window)


(define-key global-map (kbd "C-x u") 'split-window-below)
(define-key global-map (kbd "C-x 9") 'split-window-below)
(define-key global-map (kbd "C-x i") 'split-window-right)
(define-key global-map (kbd "s-t") 'eshell)

(define-key global-map (kbd "M-j") 'mike/forward-paragraph)
(define-key global-map (kbd "M-k") 'mike/backward-paragraph)
(define-key global-map (kbd "M-h") 'evil-backward-sentence-begin)
(define-key global-map (kbd "M-l") 'evil-forward-sentence-begin)

(define-key global-map (kbd "ł") (lambda () (interactive) (insert "|")))

(define-key global-map (kbd "<M-tab>") 'other-window)

(defun mike/org-sort-renumber-footnotes ()
  "Sort and renumber all footnotes in an org buffer."
  (interactive)
  (org-footnote-sort)
  (org-footnote-renumber-fn:N))

(use-package beacon)
(beacon-mode)

;; You need to install the_silver_searcher package on arch
(use-package org-seek)

(setq inhibit-startup-message t) 

(use-package nix-mode)
(use-package counsel-web)

;; Just an idea...
;(define-key global-map (kbd "C-s") 'forward-char)
;(define-key global-map (kbd "C-f") 'swiper)

(if (string= (substring (shell-command-to-string "hostname") 0 -1) "fedbox")
    (xmm))

(setq org-confirm-elisp-link-function nil)

;; Evil stuff

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-global-set-key 'motion "m" 'default-indent-new-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(eval-after-load 'evil-core
  '(evil-set-initial-state 'dashboard-mode 'emacs))

(eval-after-load 'elfeed-search-mode
  '(evil-set-initial-state 'dashboard-mode 'emacs))

(eval-after-load 'evil-core
  '(evil-set-initial-state 'eww-mode 'emacs))

(eval-after-load 'evil-core
  '(evil-set-initial-state 'dired-mode 'emacs))

(define-key evil-normal-state-map (kbd "u") 'undo)

(eval-after-load 'evil-core
  '(evil-set-initial-state 'shell-mode 'emacs))

(eval-after-load 'evil-core
  '(evil-set-initial-state 'eshell-mode 'emacs))

(eval-after-load 'evil-core
  '(evil-set-initial-state 'exwm-mode 'emacs))

;(defalias 'evil-insert-state 'evil-emacs-state)
(setq evil-insert-state-map (make-sparse-keymap))

;(define-key evil-normal-state-map (kbd "<escape>") 'evil-emacs-state)
(define-key evil-normal-state-map (kbd "SPC") 'evil-visual-char)
(global-set-key (kbd "<escape>") 'evil-normal-state)

(xmm)

(setq org-confirm-elisp-link-function nil)
(call-process-shell-command "feh --bg-scale ~/Dropbox/Wallpapers/kde.jpg")
(call-process-shell-command "picom -b --log-file /home/michael/picom.log --experimental-backends")

;(when (eq (cl-search "Mutter" (nth 0 (split-string (shell-command-to-string "wmctrl -m") "\n"))) nil)
;  (setq default-frame-alist
;	'((alpha . 93))))

;(setq default-frame-alist
;      '((alpha . 93)))

(scroll-bar-mode -1)

;No applicable method: xcb:-+request, nil, #s(xcb:SetInputFocus t 42 1 nil 0)

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))
