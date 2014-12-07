(defmodule unit-exemplar-xml-tests
  (behaviour ltest-unit)
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest make-xml
  (is-equal '"<pre>some code</pre>"
            (: exemplar-xml make-xml '"pre" '"some code")))

(deftest make-xml-with-attrs
  (is-equal '"<pre class=\"lisp\">some code</pre>"
            (: exemplar-xml make-xml '"pre" '(class "lisp") '"some code")))
