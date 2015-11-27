(defmodule kla-util
  (export all))

(defun get-kla-version ()
  (lutil:get-app-version 'kla))

(defun get-versions ()
  (++ (lutil:get-versions)
      `(#(kla ,(get-kla-version)))))
