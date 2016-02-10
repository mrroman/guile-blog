(define-module (blog utils)
  #:use-module (srfi srfi-19)
  #:export (local-zone-offset
            load-sexp-from-file
            date>?))

(define (local-zone-offset)
  (date-zone-offset (current-date)))

(define (date>? a b)
  (time>? (date->time-utc a)
          (date->time-utc b)))

(define (load-sexp-from-file fn)
  (with-input-from-file fn
    read))
