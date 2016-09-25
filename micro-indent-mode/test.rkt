#lang racket

(require "lib.rkt"
         rackunit)

(check-equal?
 '((a) b)
 (parenify "
(a
b
"))

(check-equal?
 '((a b))
 (parenify "
(a
 b
"))

(check-equal?
 '((a b))
 (parenify "
(a
 b
"))

(check-equal?
 '((a b))
 (parenify "
(a
 b
"))

(check-equal?
 '((a (b) c))
 (parenify "
(a (b
 c
"))

(check-equal?
 '((a (b) c))
 (parenify "
(a (b
 c
"))

(check-equal?
 '((a (b) c))
 (parenify "
(a (b
   c
"))

(check-equal?
 '((a (b c)))
 (parenify "
(a (b
    c
"))

(check-equal?
 '((a (b) c))
 (parenify "
(a (b
   c"))

(check-equal?
 '((a (b) c))
 (parenify "
(a (b
   c)"))

(check-equal?
 '((define (append l s)
     (cond
       ((null? l)
        s)
       (else
        (cons (car l) (append (cdr l) s))))))
 (parenify "
(define (append l s
  (cond
    ((null? l
     s
    (else
     (cons (car l) (append (cdr l) s
"))