(setq warning-minimum-level :emergency)

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

(setq org-startup-folded t)
(setq org-icalendar-timezone "Europe/Vienna")
(setq org-agenda-span 28)

(defun oa ()
  (interactive)
  (delete-other-windows)
  (split-window-below)
  (find-file "/home/michael/Dropbox/3_Emacs/1_Org_Files/1_Appointments.org")
  (other-window 1)
  (find-file "/home/michael/Dropbox/3_Emacs/1_Org_Files/2_Todo_Notes.org"))

(add-hook 'org-mode-hook (lambda () (setq electric-indent-mode nil)))

;(use-package org-tree-slide
;  :custom
;  (org-image-actual-width nil))

;(org-babel-do-load-languages
; 'org-babel-load-languages
; '((python . t)))

(defvar org-electric-pairs '((?\* . ?\*) (?/ . ?/)
                             (?\_ . ?\_)) "Electric pairs for org-mode.")

(defun org-add-electric-pairs ()
  (setq-local electric-pair-pairs (append electric-pair-pairs org-electric-pairs))
  (setq-local electric-pair-text-pairs electric-pair-pairs))

;(add-hook 'org-mode-hook 'org-add-electric-pairs)
(add-hook 'org-mode-hook 'toggle-truncate-lines)

(defun mike/org-sort-renumber-footnotes ()
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
;(global-set-key (kbd "C-z") 'undo)

(defun biblify ()
  (interactive)
  (insert "#+csl-style: apa-5th-edition.csl
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
  "navigating hydra"
  ("f"   (dired "/home/michael/Dropbox/1_Work/0_1_Vienna Work") "files")
  ("e"   (dired "/home/michael/Dropbox/3_Emacs") "emacs")
  ("d"   (dired "/home/michael/Desktop") "desktop")
  ("b"   (dired "/home/michael/Dropbox/1_Work/0_1_Vienna Work/2_Book/1_A_Final_Leg/1_Cynthia") "book")
  ("m"   (find-file "/home/michael/Dropbox/3_Emacs/Common/new_settings.org") "new_settings.org")
  ("o"   (find-file "/home/michael/Dropbox/3_Emacs/1_Org_Files/1_Appointments.org") "org")
  ("r"   (dired "/home/michael/Dropbox/") "dropbox")
  ("B"   (dired "/home/michael/Dropbox/7_Bibliography/") "Biblio")
  ("c"   (dired "/home/michael/Dropbox/MAIN_CV") "CV")
  ("p"   (dired "/home/michael/Dropbox/Python") "python")
  ("n"   (dired "/home/michael/Dropbox/1_Work/0_1_Vienna Work/0_Notes") "Notes")
  ("c"   (dired "/home/michael/Dropbox/1_Work/0_Corpus") "Corpus")
  ("s"   (find-file "/home/michael/Dropbox/Python/Practice/snippets.py") "Snippets")
  ("i"   (dired "/home/michael/Documents/Interview") "Interview")
  ("t"   (dired "/home/michael/Dropbox/1_Work/0_1_Vienna Work/1_Chapters/1_Translation") "Translation"))

(defhydra hydra-org-roam ()
  "Sanskrit Hydra"
  ("f" (find-name-dired) "search-dropbox")
  ("s" (search-corpus) "search-corpus"))

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

(use-package ido-vertical-mode)
(ido-mode 1)
(ido-vertical-mode 1)
(setq ido-vertical-define-keys 'C-n-and-C-p-only)

(quail-set-keyboard-layout "pc105-uk")
(quail-update-keyboard-layout "pc105-uk")
(setq quail-keyboard-layout-type "pc105-uk")

; These lines are to stop that annoying *Async Shell Command* window from opening.
(defadvice async-shell-command (around hide-async-windows activate)
  (save-window-excursion
    ad-do-it))

;; Interface settings
;; Necessary so you can switch to an EXWM supported program in a different workspace.
(setq exwm-layout-show-all-buffers t)

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
  (if (> (length (helm-exwm-candidates)) 2)
      (let ()
	(setq a (first (cdr (helm-exwm-candidates))))
	(switch-to-buffer a))
    (let ()
      (setq a (first (cdr (helm-exwm-candidates))))
      (switch-to-buffer a))))

;; Make it easier to run dmenu
(use-package dmenu)

(defun run-dmenu ()
  (interactive)
  (shell-command "dmenu_run"))

(global-set-key (kbd "C-c C-d") 'run-dmenu)

(require 'itrans-sa)

(defun switch-trans-dev ()
  "Switches to transliteration if in devanagari and vice versa."
  (interactive)
  (if (equal current-input-method "iast-postfix")
      (set-input-method "devanagari-kyoto-harvard")
    (set-input-method "iast-postfix")))

(global-set-key (kbd "M-p") 'backward-paragraph)
(global-set-key (kbd "C-~") 'other-window)
(global-set-key (kbd "M-e") 'helm-exwm)

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

(require 'exwm)
(require 'exwm-config)
(exwm-config-default)
(set-frame-parameter nil 'fullscreen 'fullboth)

;; These keys should always pass through to Emacs
(setq exwm-input-prefix-keys
      '(?\C-x
	?\C-u
	?\C-h
	?\M-x
	?\M-`
	?\M-&
	?\M-:
	?\C-\M-j
	?\C-o
	?\C-\s-j
	?\C-\s-l
	?\C-\ ))

; Global-EXWM key bindgs
(setq exwm-input-global-keys
      `(([?\s-r] . exwm-reset)
	(,(kbd "s-n") . helm-exwm-switch-to-next-buffer)
	(,(kbd "s-q") . delete-window)
	(,(kbd "s-Q") . delete-other-windows)
	(,(kbd "s-a") . dmenu)
	(,(kbd "s-y") . intra)
	(,(kbd "s-d") . ido-dired)
	(,(kbd "s-f") . open-thunar)
	(,(kbd "s-m") . open-scratch-bottom)
	(,(kbd "s-t") . shell)
	(,(kbd "s-p"). helm-exwm)
	(,(kbd "<s-tab>") . helm-exwm)
	(,(kbd "<s-q>") . helm-exwm)
	(,(kbd "s-k") . windmove-up)
	(,(kbd "s-j") . windmove-down)
	(,(kbd "s-h") . windmove-left)
	(,(kbd "s-l") . windmove-right)
	(,(kbd "s-s") . resize-window)
	(,(kbd "s-o") . org-roam-node-find)
	(,(kbd "s-H") . windmove-swap-states-left)
	(,(kbd "s-J") . windmove-swap-states-down)
	(,(kbd "s-K") . windmove-swap-states-up)
	(,(kbd "s-L") . windmove-swap-states-right)		
	(,(kbd "C-s-l") . split-window-horizontally)
	(,(kbd "C-s-j") . split-window-vertically)
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

(shell-command "setxkbmap -layout gb")
(shell-command "xmodmap /home/michael/modmap")

(god-mode)

(define-key god-local-mode-map (kbd ".") #'repeat)
(define-key god-local-mode-map (kbd "i") #'god-local-mode)
(define-key god-local-mode-map (kbd "z") #'repeat)
;(shell-command "/home/michael/footremap.sh")

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

;(use-package unicode-fonts)

(use-package emms)

(defun vol ()
  (interactive)
  (async-shell-command "pavucontrol --tab=3"))

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
;(require 'org-bullets)
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

(use-package treemacs)
(setq treemacs--width-is-locked nil)
(setq window-size-fixed nil)
(treemacs-toggle-fixed-width)

(use-package elfeed)

(setq elfeed-feeds
      '("https://archlinux.org/feeds/news/"
        "https://planet.emacslife.com/atom.xml"
        "https://www.anarchistfederation.net/"
        "http://blog.practicalethics.ox.ac.uk/feed/"
        "http://aphilosopher.drmcl.com/feed/"))

(remove-hook 'kill-emacs-hook 'pcache-kill-emacs-hook)
(global-set-key (kbd "C-c C-r") 'recentf-open-files)

(setq browse-url-browser-function 'browse-url-generic browse-url-generic-program "qutebrowser")

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

(defun open-scratch-bottom ()
  (interactive)
  (split-window-below 37)
  (other-window 1)
  (switch-to-buffer "*scratch*")
  (text-mode))

(global-set-key (kbd "C-c 3") 'open-scratch-bottom)
(global-set-key (kbd "M-q") 'company-complete)

(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-x w") 'counsel-web-search)

;; Preserve the open line functionality
(global-set-key (kbd "C-M-o") 'open-line)

(global-set-key (kbd "M-[") 'previous-buffer)
(global-set-key (kbd "M-]") 'next-buffer)

(defun insert-zero-width-space ()
  (interactive)
  (insert-char ?\u200B))

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

(call-process-shell-command "blueman-applet" nil 0)
(call-process-shell-command "dropbox start" nil 0)
(async-shell-command "nm-applet")

(defun sdropbox ()
  (interactive)
  (call-process-shell-command "dropbox start" nil 0))

(god-mode)

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

(defalias 'evil-insert-state 'evil-emacs-state)
(setq evil-insert-state-map (make-sparse-keymap))

(define-key evil-normal-state-map (kbd "<escape>") 'evil-emacs-state)
(define-key evil-normal-state-map (kbd "SPC") 'evil-visual-char)
(global-set-key (kbd "<escape>") 'evil-normal-state)

(setq evil-emacs-state-cursor '("firebrick" box)) 
(setq evil-normal-state-cursor '("deep sky blue" box)) 
(setq evil-visual-state-cursor '("deep sky blue" box))
(setq evil-insert-state-cursor '("firebrick" box))
(setq evil-replace-state-cursor '("firebrick" bar))
(setq evil-operator-state-cursor '("firebrick" hollow))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))
