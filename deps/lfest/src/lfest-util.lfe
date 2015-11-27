(defmodule lfest-util
  (export all))

(defun get-lfest-version ()
  (lutil:get-app-src-version "src/lfest.app.src"))

(defun get-versions ()
  (++ (lutil:get-version)
      `(#(lfest ,(get-lfest-version)))))
