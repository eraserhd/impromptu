(include "impromptu.scatter.scm")
(include "impromptu.gather.scm")

(module impromptu (edit-properties)

  (import scheme chicken)
  (use posix irregex embedded-test utils impromptu.scatter impromptu.gather)

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
