(defmodule unit-exemplar-tests
  (behaviour ltest-unit)
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")
(include-lib "clj/include/predicates.lfe")

(deftest attrs?
  (is (exemplar:attrs? '(class "css")))
  (is (exemplar:attrs? '(class "css" id "asdf-1")))
  (is-not (exemplar:attrs? '()))
  (is-not (exemplar:attrs? '(class "css" "id" "asdf-1")))
  (is-not (exemplar:attrs? '(1 2 3 4))))

(deftest attr-to-string
  (is-equal "href=\"http://url\" "
            (exemplar:attr-to-string 'href "http://url")))

(deftest attrs-to-string
  (is-equal "a=\"1\" b=\"2\" "
            (exemplar:attrs-to-string '(a "1" b "2"))))

(deftest opening-tag
  (is-equal "<a>"
            (exemplar:opening-tag "a")))

(deftest opening-tag-with-attrs
  (is-equal "<a href=\"url\">"
            (exemplar:opening-tag
              "a"
              '(href "url")))
  (is-equal "<a class=\"link\" href=\"url\">"
            (exemplar:opening-tag
              "a"
              '(class "link" href "url")))
  (is-equal "<a class=\"link\" custom=\"data\" href=\"url\">"
            (exemplar:opening-tag
              "a"
              '(class "link" custom "data" href "url"))))

(deftest closing-tag
  (is-equal "</a>"
            (exemplar:closing-tag "a")))

(deftest self-closing-tag
  (is-equal "<br />"
            (exemplar:self-closing-tag "br")))

(deftest self-closing-tag-with-attrs
  (is-equal "<img class=\"pic\" src=\"url\" />"
            (exemplar:self-closing-tag
              "img"
              (list 'class "pic" 'src "url"))))
