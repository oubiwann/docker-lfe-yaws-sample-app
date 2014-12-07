(defmodule sample-app-util
  (export all))

(defun get-sample-app-version ()
  (lutil:get-app-src-version "src/sample-app.app.src"))

(defun get-versions ()
  (++ (lutil:get-version)
      `(#(sample-app ,(get-sample-app-version)))))
