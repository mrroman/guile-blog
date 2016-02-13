(define-module (blog html)
  #:use-module (sxml html)
  #:use-module (srfi srfi-19)
  #:use-module (blog utils)
  #:use-module ((blog post) #:prefix post:)
  #:export (blog->sxml))

(define (post->sxml p)
  `(section (@ (class "post"))
            (h2 (@ (class "post-title"))
                ,(post:post-title p))
            (div (@ (class "post-date"))
                 ,(date->string (post:post-date p) "~e ~b ~Y"))
            (div (@ (class "post-body"))
                 ,(post:post-body p))))

(define (link-css path)
  `(link (@ (rel "stylesheet")
            (href ,path))))

(define (script-src path)
  `(script (@ (src ,path))))

(define (blog->sxml blog-name ps)
  `((doctype "html")
    (html
     (head
      (meta (@ (charset "UTF-8")))
      (meta (@ (name "viewport")
               (content "width=device-width, initial-scale=1")))
      (title ,blog-name)
      ,(link-css "https://fonts.googleapis.com/css?family=Cutive+Mono")
      ,(link-css "https://fonts.googleapis.com/css?family=Open+Sans")
      ,(link-css "css/main.css")
      ,(link-css "//cdn.jsdelivr.net/highlight.js/9.1.0/styles/default.min.css")
      ,(script-src "//cdn.jsdelivr.net/highlight.js/9.1.0/highlight.min.js")
      (script "hljs.initHighlightingOnLoad();"))
     (body
      (h1 ,blog-name)
      ,(map post->sxml ps)))))
