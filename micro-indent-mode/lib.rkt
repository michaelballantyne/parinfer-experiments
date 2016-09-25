#lang racket

(provide parinfer)

(struct ctx (parent column left) #:transparent)

(define (ctx-push c item)
  (struct-copy ctx c
               [left (cons item (ctx-left c))]))

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
        (close-ctx (ctx-push parent (reverse left)))))
  
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
  (define (push-id)
    (ctx-push c (string->symbol (list->string (reverse chars)))))
  
  (match s
    [(or (cons (or #\) #\space #\newline) _) '())
     (parse-line s (push-id) col)]
    [(cons ch r)
     (parse-identifier r c (add1 col) (cons ch chars))]))

(define (parse-line s c col)
  (match s
    [(cons #\( r)
     (parse-line r (ctx c col '()) (add1 col))]
    [(or (cons #\newline _) '())
     (parse-indent s c)]
    [(cons #\) r)
     (match-let ([(ctx parent _ left) c])
       (parse-line r (ctx-push parent (reverse left)) (add1 col)))]
    [(cons #\space r)
     (parse-line r c (add1 col))]
    [_
     (parse-identifier s c col)]))
