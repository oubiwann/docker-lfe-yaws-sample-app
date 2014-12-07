;;;; This module is provided as a convenience for using the HTML macros.
;;;;
(defmodule exemplar-html
  (export all))

(include-lib "exemplar/include/html-macros.lfe")

(defun noop ()
  'noop)
