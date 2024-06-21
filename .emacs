;; .emacs

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; enable visual feedback on selections
;(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
;(setq require-final-newline 'query)

;;; uncomment for CJK utf-8 support for non-Asian users
;; (require 'un-define)


;straight package manager bootstrapping
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
    (load bootstrap-file nil 'nomessage))

(straight-use-package 'helm)
(straight-use-package 'projectile)
(straight-use-package 'helm-projectile)
(straight-use-package 'firecode-theme)
(straight-use-package 'magit)


;package
;(require 'package)
;(package-initialize)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")
			 ("org" . "http://orgmode.org/elpa/")))



;helm-related adds

;(require 'helm-config)
;(helm-mode 1)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-c h") 'helm-projectile)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

;(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
;(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
;(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z



;projectile
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(comint-input-ring-file-name "/home/joch/.bash_history")
 '(comint-input-ring-size 50000)
 '(comint-prompt-read-only nil)
 '(comint-use-prompt-regexp nil)
 '(custom-safe-themes
   '("a1c18db2838b593fba371cb2623abd8f7644a7811ac53c6530eebdf8b9a25a8d" "c38363d290dc139853ae018ec595b5fa477769d828f350c4f93708e9591ba5de" "9375315e4786e5cc84b739537102802c18650f3168cf7c29f7fbb00a54f9b8e0" "18a33cdb764e4baf99b23dcd5abdbf1249670d412c6d3a8092ae1a7b211613d5" "ea489f6710a3da0738e7dbdfc124df06a4e3ae82f191ce66c2af3e0a15e99b90" default))
 '(global-hl-line-mode t)
 '(grep-find-ignored-files
   '(".#*" "*.cmti" "*.cmt" "*.annot" "*.cmi" "*.cmxa" "*.cma" "*.cmx" "*.cmo" "*.o" "*~" "*.bin" "*.lbin" "*.so" "*.a" "*.ln" "*.blg" "*.bbl" "*.elc" "*.lof" "*.glo" "*.idx" "*.lot" "*.fmt" "*.tfm" "*.class" "*.fas" "*.lib" "*.mem" "*.x86f" "*.sparcf" "*.dfsl" "*.pfsl" "*.d64fsl" "*.p64fsl" "*.lx64fsl" "*.lx32fsl" "*.dx64fsl" "*.dx32fsl" "*.fx64fsl" "*.fx32fsl" "*.sx64fsl" "*.sx32fsl" "*.wx64fsl" "*.wx32fsl" "*.fasl" "*.ufsl" "*.fsl" "*.dxl" "*.lo" "*.la" "*.gmo" "*.mo" "*.toc" "*.aux" "*.cp" "*.fn" "*.ky" "*.pg" "*.tp" "*.vr" "*.cps" "*.fns" "*.kys" "*.pgs" "*.tps" "*.vrs" "*.pyc" "*.pyo" "tags" "TAGS" ".gitignore"))
 '(helm-autoresize-mode t)
 '(menu-bar-mode nil)
 '(openwith-associations
   '(("\\.pdf\\'" "open"
      (file))
     ("\\.\\(?:jp?g\\|png\\)\\'" "open"
      (file))))
 '(package-selected-packages '(popup firecode-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor ((t (:background "light green"))))
 '(font-lock-variable-name-face ((t (:foreground "SeaGreen1" :weight bold))))
 '(highline-face ((t (:background "dark cyan"))))
 '(hl-line ((t (:inherit highlight :background "color-27" :foreground "brightwhite"))))
 '(mode-line ((t (:background "#2f2f2f" :foreground "color-49" :box nil))))
 '(mode-line-buffer-id ((t (:foreground "color-27" :box nil :overline "red" :underline "red" :weight bold :height 0.9))))
 '(mode-line-emphasis ((t (:weight bold)))))

(add-hook 'python-mode-hook (lambda() (progn (define-key python-mode-map (quote [C-return]) 
					       (lambda() (interactive) 
						 (my-python-send-region)
						 (python-nav-forward-statement)))
					     (auto-revert-mode t))))

(add-hook 'inferior-python-mode-hook (lambda() (progn (define-key inferior-python-mode-map (kbd "C-c C-l") 'helm-comint-input-ring))))

(defun my-python-send-region (&optional beg end)
  (interactive)
  (let ((beg (cond (beg beg)
                   ((region-active-p)
                    (region-beginning))
                   (t (line-beginning-position))))
        (end (cond (end end)
                   ((region-active-p)
                    (copy-marker (region-end)))
                   (t (line-end-position)))))
    (progn
      (python-shell-send-string (buffer-substring beg end) nil t)
      )))

(setq
 python-shell-interpreter "ipython"
 python-shell-interpreter-args "--colors Linux --no-autoindent"
 python-shell-prompt-regexp "In \\[[0-9]+\\]: "
 python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
 python-shell-completion-setup-code
   "from IPython.core.completerlib import module_completion"
 python-shell-completion-module-string-code
   "';'.join(module_completion('''%s'''))\n"
 python-shell-completion-string-code
   "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

;; Set keyboard maps
(global-set-key (kbd "<f1>") 'helm-buffers-list)
(global-set-key (kbd "<f2>") 'kill-this-buffer)
(global-set-key (kbd "<f3>") 'rename-uniquely)
(global-set-key (kbd "<f4>") 'shell)
(global-set-key (kbd "<f5>") 'helm-projectile)
(global-set-key (kbd "<f6>") 'helm-projectile-find-file)
(global-set-key (kbd "<f7>") 'helm-projectile-grep)
(global-set-key (kbd "<f8>") 'helm-occur)
(global-set-key (kbd "<f2>") 'kill-buffer-and-window)
(global-set-key (kbd "<f11>") 'magit-status)
(global-set-key (kbd "<f12>") 'revert-buffer)
(global-set-key (kbd "M-y")  'helm-show-kill-ring)
(global-set-key (kbd "C-x g")  'magit-status)
(global-set-key (kbd "C-x b") 'helm-buffers-list)

(define-key shell-mode-map (kbd "C-c C-l") 'helm-comint-input-ring)


(setq backup-directory-alist '(("." . "~/.emacssaves")))
(setq backup-by-copying t)

(menu-bar-mode -1)


(setq-default mode-line-buffer-identification
              (list 'buffer-file-name
                    (propertized-buffer-identification "%12f")
                    (propertized-buffer-identification "%12b")))

(add-hook 'dired-mode-hook
          (lambda ()
            ;; TODO: handle (DIRECTORY FILE ...) list value for dired-directory
            (setq mode-line-buffer-identification
                  ;; emulate "%17b" (see dired-mode):
                  '(:eval
                    (propertized-buffer-identification
                     (if (< (length default-directory) 8)
                         (concat default-directory
                                 (make-string (- 8 (length default-directory))
                                              ?\s))
                       default-directory))))))

(add-hook 'shell-mode-hook
	  (lambda ()
	    (setq shell-dirstack-query "dirs -l")))
(put 'erase-buffer 'disabled nil)

(setq inhibit-startup-message t)
(load-theme 'firecode)

(setq auto-mode-alist (append '(("emacs" . lisp-mode)) auto-mode-alist))



