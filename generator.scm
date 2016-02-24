#!guile \
-L ./site -e main -s
!#

(use-modules
 (blog html)
 ((blog post) #:select (post<? load-posts))
 (sxml html)
 (ice-9 format))

(load "config.scm")

(define (output-blog posts port)
  (let ((sorted-posts (sort-list posts post<?)))
    (sxml->html (blog->sxml blog-name sorted-posts) port)))

(define (main args)
  (let ((posts (load-posts post-dir)))
    (format #t "Generate blog for ~a...~%" blog-name)
    (call-with-output-file "index.html"
      (lambda (port)
        (output-blog posts port)))))
