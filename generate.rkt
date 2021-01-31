#lang racket/base

(require rebellion/type/record
         racket/match
         racket/list
         json)

(define-record-type ruleset (title rules))
(define-record-type rule (description manipulators))
(define-record-type manipulator (type from to))
(define-record-type modifiers (mandatory optional))
(define-record-type event (keycode modifiers))
(define-record-setter event)

(define unshift-map
  (hash #\! #\1
        #\@ #\2
        #\# #\3
        #\$ #\4
        #\% #\5
        #\^ #\6
        #\& #\7
        #\* #\8
        #\( #\9
        #\) #\0
        #\{ #\[
        #\} #\]
        #\+ #\=
        #\~ #\`
        #\_ #\-
        #\? #\/))

(define (char->string c)
  (list->string (list c)))

(define (remap-manipulator from to)
  (define (remap-from-event)
    (define unshift (hash-ref unshift-map from #f))
    (cond
      [(char? unshift)
       (event #:keycode unshift
              #:modifiers (modifiers #:mandatory (list "shift") #:optional null))]
      [else
       (event #:keycode from
              #:modifiers null)]))

  (define (remap-to-event)
    (define unshift (hash-ref unshift-map to #f))
    (cond
      [(char? unshift)
       (event #:keycode unshift #:modifiers (list "shift"))]
      [else
       (event #:keycode to #:modifiers null)]))

  (manipulator #:type "basic"
               #:from (remap-from-event)
               #:to (list (remap-to-event))))

(define (->keycode x)
  (match x
    [#\= "equal_sign"]
    [#\` "grave_accent_and_tilde"]
    [#\[ "open_bracket"]
    [#\] "close_bracket"]
    [#\- "hyphen"]
    [#\/ "slash"]
    [(? char?) (char->string x)]
    [(? string?) x]))

(define (foldl2 f xs acc)
  (cond
    [(null? xs) acc]
    [else (foldl2 f
                  (rest (rest xs))
                  (f (first xs) (second xs) acc))]))

(define (strip-null-vals kvs)
  (reverse (foldl2 (lambda (k v acc)
                     (if (null? v)
                         acc
                         (cons v (cons k acc))))
                   kvs
                   null)))

(define (cleanhash . kvs)
  (apply hash (strip-null-vals kvs)))

(define (->jsexpr x)
  (match x
    [(ruleset #:title t #:rules r)
     (cleanhash 'title t
                'rules (->jsexpr r))]
    [(rule #:description d #:manipulators m)
     (cleanhash 'description d
                'manipulators (->jsexpr m))]
    [(manipulator #:type t #:from f #:to to)
     (cleanhash 'type t
                'from (->jsexpr f)
                'to (->jsexpr to))]
    [(event #:keycode k #:modifiers m)
     (cleanhash 'key_code (->keycode k)
                'modifiers (->jsexpr m))]
    [(modifiers #:mandatory m #:optional o)
     (cleanhash 'mandatory m
                'optional o)]
    [(? list?) (map ->jsexpr x)]
    [(? string?) x]))

(define config
  (ruleset #:title "Programmers Dvorak"
           #:rules (list (rule #:description "Programmers Dvorak"
                               #:manipulators (list (remap-manipulator #\= #\~)
                                                    (remap-manipulator #\~ #\#)
                                                    (remap-manipulator #\+ #\%)
                                                    (remap-manipulator #\1 #\_)
                                                    (remap-manipulator #\2 #\[)
                                                    (remap-manipulator #\3 #\()
                                                    (remap-manipulator #\4 #\{)
                                                    (remap-manipulator #\5 #\})
                                                    (remap-manipulator #\6 #\*)
                                                    (remap-manipulator #\7 #\))
                                                    (remap-manipulator #\8 #\+)
                                                    (remap-manipulator #\9 #\])
                                                    (remap-manipulator #\0 #\!)
                                                    (remap-manipulator #\! #\7)
                                                    (remap-manipulator #\@ #\5)
                                                    (remap-manipulator #\# #\3)
                                                    (remap-manipulator #\$ #\1)
                                                    (remap-manipulator #\% #\9)
                                                    (remap-manipulator #\^ #\0)
                                                    (remap-manipulator #\& #\2)
                                                    (remap-manipulator #\* #\4)
                                                    (remap-manipulator #\( #\6)
                                                    (remap-manipulator #\) #\8)
                                                    (remap-manipulator #\_ #\&)
                                                    (remap-manipulator #\/ #\#)
                                                    (remap-manipulator #\? #\$)
                                                    (remap-manipulator #\[ #\/)
                                                    (remap-manipulator #\{ #\?)
                                                    (remap-manipulator #\] #\@)
                                                    (remap-manipulator #\} #\^))))))

(displayln (jsexpr->string (->jsexpr config)))
