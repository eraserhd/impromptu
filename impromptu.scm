(include "impromptu.scatter.scm")

(module impromptu (edit-properties)

  (import scheme chicken)
  (use posix irregex embedded-test utils impromptu.scatter)

  ;; -- Parsing templates --

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

  ;; -- Editing --

  (define (editor)
    (or (get-environment-variable "EDITOR")
	(get-environment-variable "VISUAL")
	"vi"))

  (define (edit-command filename)
    (string-append (qs (editor)) " " (qs filename)))

  (test (begin
	  (setenv "EDITOR" "vim")
	  (edit-command "/tmp/foo.txt"))
	"'vim' '/tmp/foo.txt'")
  (test (begin
	  (unsetenv "EDITOR")
	  (unsetenv "VISUAL")
	  (edit-command "/tmp/foo.txt"))
	"'vi' '/tmp/foo.txt'")
  (test (begin
	  (unsetenv "EDITOR")
	  (setenv "VISUAL" "/x/vi")
	  (edit-command "/tmp/foo.txt"))
	"'/x/vi' '/tmp/foo.txt'")

  (define (in-temp-file contents)
    (let-values (((fd filename) (file-mkstemp "/tmp/impromptu.XXXXXX")))
      (let ((port (open-output-file* fd)))
	(display contents port)
	(close-output-port port))
      filename))

  (test (let ((filename (in-temp-file "Hello, world!")))
	  (with-input-from-file filename read-all))
	"Hello, world!")

  (define (edit-properties alist)
    (let* ((text (make-template alist))
	   (filename (in-temp-file text))
	   (exit-code (system (edit-command filename))))
      (if (not (= 0 exit-code))
	#f
	(let* ((edited-text (with-input-from-file filename read-all))
	       (result (parse-template edited-text)))
	  (delete-file filename)
	  result))))

  )
