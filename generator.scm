#!guile \
-L ./site -e main -s
!#

(use-modules
 (blog html)
 ((blog post) #:select (post<? load-posts))
 (sxml html)
 (ice-9 getopt-long)
 (ice-9 format))

(load "config.scm")

(define (generate-pages posts)
  (format #t "Generate pages...~%")
  (call-with-output-file "index.html"
    (lambda (port)
      (sxml->html (blog->sxml blog-name posts) port))))

(define (generate-rss posts)
  (format #t "Generate rss...~%")
  #f)

(define (generate)
  (let ((posts (sort-list (load-posts post-dir)
                          post<?)))
    (format #t "Generate blog for ~a...~%" blog-name)
    (generate-pages posts)
    (generate-rss posts)))

(define (main args)
  (generate))
