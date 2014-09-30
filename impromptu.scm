(include "impromptu.scatter.scm")
(include "impromptu.gather.scm")
(include "impromptu.edit.scm")

(module impromptu (edit-properties)

  (import scheme chicken)
  (use posix irregex embedded-test utils impromptu.scatter impromptu.gather impromptu.edit)

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
