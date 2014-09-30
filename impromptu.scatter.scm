(module impromptu.scatter (make-template)

  (import scheme chicken)
  (use posix irregex embedded-test utils)

  (define (format-value value)
    (if (memv #\newline (string->list value))
      (string-append "\n" value)
      (string-append " " value)))

  (define (format-entry entry)
    (let ((name (car entry))
	  (value (cdr entry)))
      (string-append
	":" (symbol->string name) ":"
	(format-value value))))

  (define (make-template alist)
    (if (null? alist)
      ""
      (string-append
	(format-entry (car alist))
	"\n"
	(make-template (cdr alist)))))

  (test (make-template '())
	"")
  (test (make-template '((Foo: . "bar")))
	":Foo: bar\n")
  (test (make-template '((Foo: . "bar") (Baz: . "quux")))
	":Foo: bar\n:Baz: quux\n")
  (test (make-template '((Foo: . "bar") (Baz: . "Hello, this is a\nmulti-line test.")))
	":Foo: bar\n:Baz:\nHello, this is a\nmulti-line test.\n")

  )
