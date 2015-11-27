(defmodule unit-exemplar-html-util-tests
  (behaviour ltest-unit)
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")
(include-lib "exemplar/include/html-macros.lfe")

(deftest make-html
  (is-equal "<br />"
            (exemplar-html-util:make-html "br")))

(deftest make-html-with-content
  (is-equal "<pre>some code</pre>"
            (exemplar-html-util:make-html "pre" "some code")))

(deftest make-html-with-attrs
  (is-equal "<img src=\"http://url\" />"
            (exemplar-html-util:make-html "img" '(src "http://url"))))

(deftest make-html-with-attrs-and-content
  (is-equal "<pre class=\"lisp\">some code</pre>"
            (exemplar-html-util:make-html "pre" '(class "lisp") "some code")))

(deftest make-html-with-lists
  (let ((html-string (ul (list (li "a") (li "b") (li "c")))))
    (is-equal "<ul><li>a</li><li>b</li><li>c</li></ul>" html-string)))
