(import impromptu.gather)

(test-group "parsing templates"
  (test '((Foo: . "Bar"))
	(parse-template ":Foo: Bar\n"))
  (test '((Foo: . "Bar") (Baz: . "Quux"))
	(parse-template ":Foo: Bar\n:Baz: Quux\n"))
  (test '((Foo: . "Hello"))
	(parse-template ":Foo:\nHello\n"))
  (test '((Foo: . "Hello\nWorld!\nThree"))
	(parse-template ":Foo:\nHello\nWorld!\nThree\n")))

