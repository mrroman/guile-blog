(use-modules (ice-9 ftw)
             (ice-9 match)
             (srfi srfi-9)
             (srfi srfi-19)
             (sxml html))

(define blog-name "mrroman's blog")
(define post-dir "./posts/")

(define post-filename-re
  (make-regexp "^([0-9]{4,4})-([0-9]{2,2})-([0-3][0-9])_.*\\.scm$"))

(define (local-zone-offset)
  (date-zone-offset (current-date)))

(define (parse-post-date fn)
  (let ((m (regexp-exec post-filename-re fn)))
    (when m
      (make-date 0 0 0 0
                 (string->number (match:substring m 3))
                 (string->number (match:substring m 2))
                 (string->number (match:substring m 1))
                 (local-zone-offset)))))

(define (post-filename? fn)
  (not (not (regexp-exec post-filename-re fn))))

(define (list-post-files)
  (scandir post-dir post-filename?))

(define (load-sexp-from-file fn)
  (with-input-from-file (string-append post-dir fn)
    read))

(define-record-type <post>
  (make-post date)
  post?
  (title post-title set-post-title!)
  (body post-body set-post-body!)
  (date post-date))

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

(define (parse-post pp p)
  (when (eq? (car pp) 'post)
    (parse-post-props (cdr pp) p)))

(define (load-post fn)
  (let* ((post (make-post (parse-post-date fn))))
    (parse-post (load-sexp-from-file fn) post)))

(define (load-posts)
  (map load-post (list-post-files)))

(define (post->sxml p)
  `(section (@ (class "post"))
            (h2 (@ (class "post-title"))
                ,(post-title p))
            (div (@ (class "post-date"))
                 ,(date->string (post-date p) "~e ~b ~Y"))
            (div (@ (class "post-body"))
                 ,(post-body p))))

(define (blog->sxml ps)
  `((doctype "html")
    (html
     (head
      (meta (@ (charset "UTF-8")))
      (title ,blog-name))
     (body
      (h1 ,blog-name)
      ,(map post->sxml ps)))))

(define (date>? a b)
  (time>? (date->time-utc a)
          (date->time-utc b)))

(define (post<? a b)
  (date>? (post-date a)
          (post-date b)))

(define (output-blog)
  (call-with-output-file "index.html"
    (lambda (port)
      (let* ((posts (load-posts))
             (sorted-posts (sort-list posts post<?)))
        (sxml->html (blog->sxml sorted-posts) port)))))

(output-blog)
