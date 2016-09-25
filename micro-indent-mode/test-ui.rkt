#lang racket

(define km (new keymap%))
(send km map-function "d:c" "copy-clipboard")
(send km map-function "d:v" "paste-clipboard")
(send km map-function "d:a" "select-all")
(add-editor-keymap-functions km)

(define f (new frame% [label "Simple Edit"]
                      [width 200]
                      [height 200]))
(define c1 (new editor-canvas% [parent f]))
(define t1 (new (class text%
                  (super-new)
                  (define (update-t2)
                    (void)
                    (send t2 select-all)
                    (send t2 clear)
                    (displayln (run (send t1 get-flattened-text)))
                    (call-with-input-string (~a (run (send t1 get-flattened-text)))
                      (lambda (s) (send t2 insert-port s))))
                  (define (after-insert a b)
                    (update-t2))
                  (define (after-delete a b)
                    (update-t2))
                  (augment after-insert
                           after-delete))))
(send c1 set-editor t1)
(send t1 set-keymap km)

(define c2 (new editor-canvas% [parent f]))
(define t2 (new text%))
(send c2 set-editor t2)
(send t2 set-keymap km)


(define mb (new menu-bar% [parent f]))
(define m-font (new menu% [label "Font"] [parent mb]))
(append-editor-font-menu-items m-font)

(send f show #t)