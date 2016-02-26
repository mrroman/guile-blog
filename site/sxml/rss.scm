(define-module (sxml rss)
  #:use-module (ice-9 i18n)
  #:use-module (ice-9 regex)
  #:use-module (srfi srfi-19))

(define months (vector "Jan" "Feb" "Mar" "Apr"
                       "May" "Jun" "Jul" "Aug"
                       "Sep" "Oct" "Nov" "Dec"))

(define (date->rfc822 d)
  (string-append
   (date->string d "~d ")
   (vector-ref months (- (date-month d) 1))
   (date->string d " ~Y ~T ~z")))

(define* (rss items #:key title description link)
  `((rss (@ (version "2.0")))
    (channel
     (title ,title)
     (description ,description)
     (link ,link)
     (lastBuildDate ,(date->rfc822 (current-date))))))
