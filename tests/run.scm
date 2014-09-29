(use posix embedded-test)
(setenv "TESTS" "1")

(change-directory "..")
(include "impromptu.scm")

(run-tests)
