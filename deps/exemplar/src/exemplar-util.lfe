(defmodule exemplar-util
  (export all))

(defun get-exemplar-version ()
  (lutil:get-app-src-version "src/exemplar.app.src"))

(defun get-versions ()
  (++ (lutil:get-version)
      `(#(exemplar ,(get-exemplar-version)))))
