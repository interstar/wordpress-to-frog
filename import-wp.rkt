#lang racket

(require xml xml/xexpr xml/path racket/match)

(define (read-export)
  (let* ([f-name (string->path "my-wordpress-export.xml")])
  (with-handlers ([exn:fail? (λ (e) "CAN'T LOAD")])
    (file->string f-name))))

(permissive-xexprs true)

(struct Post (title body date tags))

;; 
(define (item? xs) (eq? 'item (car xs)))
(define (remove? x)
  (match x
    ["\n\t" false]
    ["\n" false]
    ["\n\n\t" false]
    [_ (item? x)]
   
    )
)


(define (extract-cdata cd)
  (let* ([r (pregexp "<!\\[CDATA\\[(.*)\\]\\]>")]         
         [s (cdata-string cd)])
    (cadr (regexp-match r s))
  ))

(define (make-post x)
 (let* ([title (se-path* '(title) x)]
         [body (extract-cdata  (se-path* '(content:encoded) x))]
         [post-date
          (regexp-replace #px"00:00:00" (regexp-replace #px"\\s" (extract-cdata (se-path* '(wp:post_date_gmt) x)) "T") "01:01:01" )
          ]
         [tag-list (se-path*/list '(category) x)]
         [tags (cond
                 [(eq? #f tag-list) ""]
                 [(list? tag-list) (string-join (map (lambda (x) (regexp-replace #px"\\s" (extract-cdata x) "_" ) ) tag-list ) ", ") ]
                 [(cdata? tag-list) (extract-cdata tag-list)]
                 [else (~a "unrecognized " tag-list)])
          ]
         )
    (Post title body post-date tags)))
                   
(define (render-post p)
  (~a   "    Title: " (Post-title p)
      "\n    Date: " (Post-date p)
      "\n    Tags: " (Post-tags p)
      "\n\n" (Post-body p)))

(define (year-post p) (substring (Post-date p) 0 4))

(define (file-name-post p)
  (let* ([date (Post-date p)])
    (string-append "_src/posts/" (year-post p) "/" (substring date 0 10) "-"
                   (string-downcase (regexp-replace* #px"[\\W|\\s]+" (~a (Post-title p)) "_")) ".md" )  ))

(let* ([doc (xml->xexpr (document-element (read-xml (open-input-string (read-export)))))]
       [full-list (se-path*/list '(channel) doc)]
       [posts  (map make-post (filter remove? full-list))]
       )
 (for* ([p posts])
   (displayln (year-post p))
   (with-handlers ([exn:fail? (lambda (v) 'failed)])
     (make-directory (string-append "_src/posts/" (year-post p))))
     
   (displayln (file-name-post p))
   (displayln (Post-date p))
     (display-to-file (render-post p) (file-name-post p) #:exists 'replace)
   (displayln (render-post p))
  ))