#lang racket

(require parser-tools/lex
         (prefix-in : parser-tools/lex-sre))

(provide parinfer)

(struct ctx (parent column left) #:transparent)

(define (ctx-push c item)
  (struct-copy ctx c
               [left (cons item (ctx-left c))]))

(define (parinfer str)
  (let ([port (open-input-string str)])
    (port-count-lines! port)
    (reverse
     (ctx-left
      ((lex (ctx #f -1 '())) port)))))

(define (close-ctx c indent-col)
  (match-let ([(ctx parent column left) c])
    (if (< column indent-col)
        c
        (close-ctx (ctx-push parent (reverse left)) indent-col))))

(define (lex c)
  (lexer
   [#\(
    ((lex (ctx c (position-col start-pos) '())) input-port)]
   [#\)
    (match-let ([(ctx parent _ left) c])
      ((lex (ctx-push parent (reverse left))) input-port))]
   [(:: #\newline (:* #\space))
    ((lex (close-ctx c (position-col end-pos))) input-port)]
   [#\space
    ((lex c) input-port)]
   [(:+ (:or alphabetic #\? #\! #\-))
    ((lex (ctx-push c (string->symbol lexeme))) input-port)]
   [(eof)
    (close-ctx c 0)]))

