(define-module (sxml rss)
  #:use-module (ice-9 i18n)
  #:use-module (srfi srfi-19))

(define (date->rfc822 d)
  (date->string d "~a, ~d ~b ~Y ~T ~z"
                (make-locale LC_TIME "en_US")))

(date->rfc822 (time-utc->date (current-time)))

(define* (rss items #:key title description link)
  `((rss (@ (version "2.0")))
    (channel
     (title ,title)
     (description ,description)
     (link ,link)
     (lastBuildDate))))
