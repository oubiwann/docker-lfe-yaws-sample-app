(defmodule unit-macros-tests
  (behaviour ltest-unit)
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")
(include-lib "exemplar/include/xml-macros.lfe")

(defelem special)

(deftest defelem
  (is-equal "<special />" (special))
  (is-equal "<special>my content</special>" (special "my content")))
