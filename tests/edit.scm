(import impromptu.edit)

(test-group "composing the edit command"
  (test "vim '/tmp/foo.txt'"
	(begin
	  (setenv "EDITOR" "vim")
	  (edit-command "/tmp/foo.txt")))
  (test "vi '/tmp/foo.txt'"
	(begin
	  (unsetenv "EDITOR")
	  (unsetenv "VISUAL")
	  (edit-command "/tmp/foo.txt")))
  (test "/x/vi '/tmp/foo.txt'"
	(begin
	  (unsetenv "EDITOR")
	  (setenv "VISUAL" "/x/vi")
	  (edit-command "/tmp/foo.txt")))
  (test "subl -w '/tmp/foo.txt'"
	(begin
	  (setenv "EDITOR" "subl -w")
	  (edit-command "/tmp/foo.txt"))))

(test-group "storing contents in temp files"
  (test "Hello, world!"
	(let ((filename (in-temp-file "Hello, world!")))
	  (with-input-from-file filename read-all))))

