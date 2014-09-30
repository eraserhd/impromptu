(module impromptu.edit (edit-command in-temp-file)

  (import scheme chicken)
  (use posix irregex embedded-test utils)

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

  )