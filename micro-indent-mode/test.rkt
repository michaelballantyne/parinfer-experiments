#lang at-exp racket

(require "with-lexer.rkt"
         rackunit)

(check-equal?
 (parinfer
  @string-append{
    (a
    b
  })
 '((a) b))

(check-equal?
 (parinfer
  @string-append{
    (a
     b
  })
 '((a b)))

(check-equal?
 (parinfer
  @string-append{
   (a
    b

  })
 '((a b)))

(check-equal?
 (parinfer
  @string-append{
    
    (a
     b
  })
 '((a b)))

(check-equal?
 (parinfer
  @string-append{
    (a (b
     c
  })
 '((a (b) c)))

(check-equal?
 (parinfer
  @string-append{
   (a (b
      c
  })
 '((a (b) c)))

(check-equal?
 (parinfer
  @string-append{
    (a (b
        c
  })
 '((a (b c))))

(check-equal?
 (parinfer
  @string-append{
    (a (b
       c)
  })
 '((a (b) c)))

(check-equal?
 (parinfer
  @string-append{
    (define (append l s
      (cond
        ((null? l
         s
        (else
         (cons (car l) (append (cdr l) s
  })
 '((define (append l s)
     (cond
       ((null? l)
        s)
       (else
        (cons (car l) (append (cdr l) s)))))))
