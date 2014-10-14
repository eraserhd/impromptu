(module impromptu.scatter (make-template)

  (import scheme chicken)
  (use posix irregex utils)

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

  )
