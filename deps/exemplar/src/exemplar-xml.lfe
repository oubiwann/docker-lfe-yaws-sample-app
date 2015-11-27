(defmodule exemplar-xml
  (export all))

(defun make-xml (tag)
  (++ (exemplar:self-closing-tag tag)))

(defun make-xml (tag content)
  (++ (exemplar:opening-tag tag)
      content
      (exemplar:closing-tag tag)))

(defun make-xml (tag attrs content)
  (++ (exemplar:opening-tag tag attrs)
      content
      (exemplar:closing-tag tag)))
