(use test)

(load-relative "../impromptu.scatter.scm")
(load-relative "../impromptu.gather.scm")
(load-relative "../impromptu.edit.scm")

(test-begin)
(load-relative "scatter.scm")
(load-relative "gather.scm")
(load-relative "edit.scm")
(test-end)
