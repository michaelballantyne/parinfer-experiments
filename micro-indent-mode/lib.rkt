#lang racket

(provide parinfer)

(struct ctx (parent column left) #:transparent)

(define (parinfer str)
  (reverse
   (ctx-left
    (parse-line (string->list str)
                (ctx #f -1 '())
                0))))

(define (parse-indent s c [count 0])
  (define (close-ctx c)
    (match-define (ctx parent column left) c)
    (if (< column count)
        c
        (close-ctx (struct-copy ctx parent
                                [left (cons (reverse left)
                                            (ctx-left parent))]))))
  (match s
    [(cons #\space r)
     (parse-indent r c (add1 count))]
    [(cons #\newline r)
     (parse-indent r c)]
    [(cons ch r)   
     (parse-line s (close-ctx c) count)]
    ['()
     (close-ctx c)]))

(define (parse-identifier s c col [chars '()])
  (define (id-finished-ctx)
    (struct-copy ctx c
                 [left (cons (string->symbol (list->string (reverse chars)))
                             (ctx-left c))]))
  (match s
    [(cons #\space r)
     (parse-line r (id-finished-ctx) (add1 col))]
    [(cons #\) _)
     (parse-line s (id-finished-ctx) col)]
    [(cons #\newline r)
     (parse-indent r (id-finished-ctx))]
    [(cons ch r)
     (parse-identifier r c (add1 col) (cons ch chars))]
    ['()
     (parse-indent '() (id-finished-ctx))]))

(define (parse-line s c col)
  (match s
    [(cons #\( r)
     (parse-line r (ctx c col '()) (add1 col))]
    [(cons #\newline r)
     (parse-indent r c)]
    [(cons #\) r)
     (match-define (ctx parent _ left) c)
     (parse-line r (struct-copy ctx parent [left (cons (reverse left) (ctx-left parent))]) (add1 col))]
    ['()
     (parse-indent '() c)]
    [(cons #\space r)
     (parse-line r c (add1 col))]
    [_
     (parse-identifier s c col)]))
