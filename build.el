;;; build.el — Batch org→HTML export via ox-tufte

(defun ptsw-ensure-package (feature name)
  "Try to require FEATURE. If not found, scan common paths for package NAME."
  (condition-case nil
      (require feature)
    (error
     (let ((straight-build-dir (expand-file-name "~/.emacs.d/.local/straight/build"))
           (straight-repos-dir (expand-file-name "~/.emacs.d/.local/straight/repos"))
           (vanilla-elpa-dir (expand-file-name "~/.emacs.d/elpa")))
       (dolist (base (list straight-build-dir straight-repos-dir))
         (let ((pkg-dir (expand-file-name name base)))
           (when (file-directory-p pkg-dir)
             (add-to-list 'load-path pkg-dir))))
       (dolist (pkg (directory-files vanilla-elpa-dir t (concat "^" name "-[0-9]")))
         (when (file-directory-p pkg)
           (add-to-list 'load-path pkg))))
     (condition-case nil
         (require feature)
       (error
        (message "ERROR: Cannot find package %s. Install via: M-x package-install RET %s RET" name name)
        (kill-emacs 1))))))

(defun ptsw-ensure-dir (dir)
  (unless (file-directory-p dir)
    (make-directory dir t)))

;; Bootstrap packages
(ptsw-ensure-package 'htmlize "htmlize")
(ptsw-ensure-package 'ox-tufte "ox-tufte")

;; Common preamble/postamble for all pages
(setq org-html-preamble
      "<nav>
  <div class=\"site-title\"><a href=\"/\">plateaux</a></div>
  <div class=\"site-nav\">
    <a href=\"/about/\">About</a>
    <a href=\"/stuff/\">Stuff</a>
    <a href=\"/blog/\">Posts</a>
    <a href=\"/books/\">Reading</a>
  </div>
</nav>
<br/>")

(setq org-html-head-include-default-style nil)

(setq org-html-postamble
      "
  <a href=\"https://twitter.com/_ptsw\">Twitter</a>
  <a href=\"https://github.com/paultsw\">GitHub</a>
  <a href=\"https://stackoverflow.com/users/3141064/ptsw\">StackOverflow</a>")



(defun ptsw-export-to-html (org-path html-path)
  "Export ORG-PATH to HTML-PATH using ox-tufte."
  (ptsw-ensure-dir (file-name-directory html-path))
  (find-file org-path)
  (org-export-to-file 'tufte-html html-path)
  (kill-buffer)
  (message "Exported: %s → %s" org-path html-path))

(defun ptsw-export-file (org-path)
  "Export ORG-PATH to docs/ mirroring directory structure."
  (let* ((rel-path (file-relative-name
                    (concat (file-name-sans-extension org-path) ".html")))
         (html-path (expand-file-name rel-path (expand-file-name "docs"))))
    (ptsw-export-to-html org-path html-path)))

(defun ptsw-export-post (org-path)
  "Export a post from posts/ to docs/blog/posts/."
  (let ((html-path (expand-file-name
                    (concat "blog/posts/" (file-name-base org-path) ".html")
                    (expand-file-name "docs"))))
    (ptsw-export-to-html org-path html-path)))

(defun ptsw-extract-heading (org-file)
  "Extract first #+TITLE: from ORG-FILE."
  (with-temp-buffer
    (insert-file-contents org-file)
    (goto-char (point-min))
    (when (re-search-forward "^#\\+TITLE:\\s-*\\(.*\\)" nil t)
      (string-trim (match-string 1)))))

(defun ptsw-extract-date (org-file)
  "Extract #+DATE: from ORG-FILE."
  (with-temp-buffer
    (insert-file-contents org-file)
    (goto-char (point-min))
    (when (re-search-forward "^#\\+DATE:\\s-*\\(.*\\)" nil t)
      (string-trim (match-string 1)))))

(defun ptsw-generate-blog-listing ()
  "Scan posts/*.org for #+TITLE and #+DATE, generate docs/blog/index.html."
  (let* ((posts-dir (expand-file-name "posts"))
         (files (directory-files posts-dir t "\\.org$")))
    (setq files (sort files
                      (lambda (a b)
                        (let ((da (ptsw-extract-date a))
                              (db (ptsw-extract-date b)))
                          (if (and da db)
                              (string> da db)
                            t)))))
    (ptsw-ensure-dir (expand-file-name "docs/blog"))
    (with-temp-buffer
      (insert "<!DOCTYPE html>\n<html>\n<head>\n")
      (insert "<meta charset=\"utf-8\">\n")
      (insert "<title>Posts — plateaux</title>\n")
      (insert "<link rel=\"stylesheet\" href=\"/tufte.css\" type=\"text/css\" />\n")
      (insert "</head>\n<body>\n")
      (insert "<nav><div class=\"site-title\"><a href=\"/\">plateaux</a></div>\n")
      (insert "<div class=\"site-nav\">\n")
      (insert "<a href=\"/about/\">About</a>\n")
      (insert "<a href=\"/stuff/\">Stuff</a>\n")
      (insert "<a href=\"/blog/\">Posts</a>\n")
      (insert "<a href=\"/books/\">Reading</a>\n")
      (insert "</div></nav><br/>\n")
      (insert "<article>\n<h1>Posts</h1>\n")
      (dolist (f files)
        (let ((title (ptsw-extract-heading f))
              (date  (ptsw-extract-date f))
              (slug  (file-name-base f)))
          (when title
            (insert "<section>\n")
            (insert (format "<p><a href=\"/blog/posts/%s.html\">%s</a></p>\n" slug title))
            (insert (format "<p>%s</p>\n" (or date "")))
            (insert "</section>\n"))))
      (insert "</article>\n</body>\n</html>\n")
      (write-file (expand-file-name "docs/blog/index.html")))
    (message "Generated blog listing → docs/blog/index.html")))

(provide 'build)
