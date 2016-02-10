(define-module (blog post)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-19)
  #:use-module (blog utils)
  #:export (load-posts
            post-title
            post-body
            post-date
            post<?))

(define-record-type <post>
  (make-post date)
  post?
  (title post-title set-post-title!)
  (body post-body set-post-body!)
  (date post-date))

(define (post<? a b)
  (date>? (post-date a)
          (post-date b)))

;; post loading

(define post-filename-re
  (make-regexp "^([0-9]{4,4})-([0-9]{2,2})-([0-3][0-9])_.*\\.scm$"))

(define (parse-post-date fn)
  (let ((m (regexp-exec post-filename-re fn)))
    (when m
      (make-date 0 0 0 0
                 (string->number (match:substring m 3))
                 (string->number (match:substring m 2))
                 (string->number (match:substring m 1))
                 (local-zone-offset)))))

;; post parsing and loading

(define (parse-post-props ps p)
  (if (null? ps)
      p
      (match (car ps)
        (() p)
        (('title t) (begin
                      (set-post-title! p t)
                      (parse-post-props (cdr ps) p)))
        (('body b ...) (begin
                     (set-post-body! p b)
                     (parse-post-props (cdr ps) p)))
        (_ (parse-post-props (cdr ps) p)))))

(define (parse-post pp p)
  (when (eq? (car pp) 'post)
    (parse-post-props (cdr pp) p)))

(define (load-post fn d)
  (let* ((post (make-post d)))
    (parse-post (load-sexp-from-file fn) post)))

;; load posts

(define (post-filename? fn)
  (not (not (regexp-exec post-filename-re fn))))

(define (list-post-files post-dir)
  (scandir post-dir post-filename?))

(define (load-posts post-dir)
  (map (lambda (fn)
         (load-post (string-append post-dir fn)
                    (parse-post-date fn)))
       (list-post-files post-dir)))
