#lang racket

(require "lib.rkt"
         rackunit)

(check-equal?
 '((a) b)
 (parinfer "
(a
b
"))

(check-equal?
 '((a b))
 (parinfer "
(a
 b
"))

(check-equal?
 '((a b))
 (parinfer "
(a
 b
"))

(check-equal?
 '((a b))
 (parinfer "
(a
 b
"))

(check-equal?
 '((a (b) c))
 (parinfer "
(a (b
 c
"))

(check-equal?
 '((a (b) c))
 (parinfer "
(a (b
 c
"))

(check-equal?
 '((a (b) c))
 (parinfer "
(a (b
   c
"))

(check-equal?
 '((a (b c)))
 (parinfer "
(a (b
    c
"))

(check-equal?
 '((a (b) c))
 (parinfer "
(a (b
   c"))

(check-equal?
 '((a (b) c))
 (parinfer "
(a (b
   c)"))

(check-equal?
 '((define (append l s)
     (cond
       ((null? l)
        s)
       (else
        (cons (car l) (append (cdr l) s))))))
 (parinfer "
(define (append l s
  (cond
    ((null? l
     s
    (else
     (cons (car l) (append (cdr l) s
"))
