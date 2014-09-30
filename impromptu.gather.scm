(module impromptu.gather (parse-template)

  (import scheme chicken)
  (use posix irregex embedded-test utils)

  (define field-re (irregex
		     '(: bos #\: (=> name (: upper-case (* (or alpha digit #\-)))) #\: (* whitespace) (=> rest (* any)))
		     '(s m)))

  (define trim-re (irregex
		    '(: (+ whitespace) eos)
		    '(s m)))

  (define newline-re (irregex #\newline '(s m)))

  (define (parse-line line)
    (let ((m (irregex-match field-re line)))
      (if (not m)
	(list line)
	(list
	  (string->keyword (irregex-match-substring m 'name))
	  (irregex-match-substring m 'rest)))))

  (define (tokenize s)
    (apply append
	   (map parse-line
		(map (cut string-append <> "\n")
		     (irregex-split newline-re s)))))

  (define (parse-template s)
    (define current-field #f)
    (define fields '((#f . "")))
    (for-each
      (lambda (token)
	(cond
	  ((symbol? token)
	   (set! current-field token)
	   (set! fields (cons (cons current-field "") fields)))

	  (else
	   (let ((location (assq current-field fields)))
	   (set-cdr! location (string-append (cdr location) token))))))
      (tokenize s))

    (map
      (lambda (entry)
	(cons
	  (car entry)
	  (irregex-replace trim-re (cdr entry) "")))
      (cdr (reverse fields))))


  (test (parse-template ":Foo: Bar\n")
	'((Foo: . "Bar")))
  (test (parse-template ":Foo: Bar\n:Baz: Quux\n")
	'((Foo: . "Bar") (Baz: . "Quux")))
  (test (parse-template ":Foo:\nHello\n")
	'((Foo: . "Hello")))
  (test (parse-template ":Foo:\nHello\nWorld!\nThree\n")
	'((Foo: . "Hello\nWorld!\nThree")))


  )

