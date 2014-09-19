(require-extension posix)
(setenv "TESTS" "1")

(change-directory "..")
(include "impromptu.scm")

(run-tests)
