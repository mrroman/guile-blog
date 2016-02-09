(use-modules (ice-9 ftw)
             (ice-9 match)
             (srfi srfi-9)
             (sxml html))

(define post-dir "./posts/")

(define (post-filename? fn)
  (string-match "^[0-9]{4,4}-[0-9]{2,2}-[0-3][0-9]_.*\\.scm$" fn))

(define (list-posts)
  (scandir post-dir post-filename?))

(define (load-post fn)
  (with-input-from-file (string-append post-dir fn)
    read))

(define-record-type <post>
  (make-post)
  post?
  (title post-title set-post-title!)
  (body post-body set-post-body!))

(define (parse-post-props ps p)
  (if (null? ps)
      p
      (match (car ps)
        (() p)
        (('title t) (begin
                      (set-post-title! p t)
                      (parse-post-props (cdr ps) p)))
        (('body b) (begin
                     (set-post-body! p b)
                     (parse-post-props (cdr ps) p)))
        (_ (parse-post-props (cdr ps) p)))))

(define (parse-post pp)
  (when (eq? (car pp) 'post)
    (parse-post-props (cdr pp) (make-post))))

(parse-post (load-post "2016-02-07_first_post.scm"))
