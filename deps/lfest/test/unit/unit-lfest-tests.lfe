(defmodule unit-lfest-tests
  (export all)
  (import
    (from ltest
      (check-failed-assert 2)
      (check-wrong-assert-exception 2))))

(include-lib "deps/ltest/include/macros.lfe")

(deftest placeholder
  (is-equal 1 1))
