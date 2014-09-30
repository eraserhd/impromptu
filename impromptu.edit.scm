(module impromptu.edit (edit-command in-temp-file)

  (import scheme chicken)
  (use posix irregex embedded-test utils)

  (define (editor)
    (or (get-environment-variable "EDITOR")
	(get-environment-variable "VISUAL")
	"vi"))

  (define (edit-command filename)
    (string-append (qs (editor)) " " (qs filename)))

  (define (in-temp-file contents)
    (let-values (((fd filename) (file-mkstemp "/tmp/impromptu.XXXXXX")))
      (let ((port (open-output-file* fd)))
	(display contents port)
	(close-output-port port))
      filename))

  )
