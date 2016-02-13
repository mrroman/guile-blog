#!guile \
-L ./site -e main -s
!#

(use-modules
 (blog html)
 ((blog post) #:select (post<? load-posts))
 (sxml html))

(define blog-name "mrroman's blog")
(define post-dir "./posts/")

(define (output-blog)
  (call-with-output-file "index.html"
    (lambda (port)
      (let* ((posts (load-posts post-dir))
             (sorted-posts (sort-list posts post<?)))
        (sxml->html (blog->sxml blog-name sorted-posts) port)))))

(define (main args)
  (display "Generate blog\n")
  (output-blog))
