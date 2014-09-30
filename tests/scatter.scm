(import impromptu.scatter)

(test-group "generating templates"
  (test ""
	(make-template '()))
  (test ":Foo: bar\n"
	(make-template '((Foo: . "bar"))))
  (test ":Foo: bar\n:Baz: quux\n"
	(make-template '((Foo: . "bar") (Baz: . "quux"))))
  (test ":Foo: bar\n:Baz:\nHello, this is a\nmulti-line test.\n"
	(make-template '((Foo: . "bar") (Baz: . "Hello, this is a\nmulti-line test.")))))

