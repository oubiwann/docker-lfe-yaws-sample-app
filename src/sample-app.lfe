(defmodule sample-app
  (export all))

(defun my-adder (x y)
  (+ x (+ y 1)))

(defun out (arg-data)
  "This function is executed by YAWS. It is the YAWS entry point for our app."
  (let ((raw-path-info (: sample-app-util parse-path arg-data)))
    (if (== raw-path-info 'undefined)
      (: sample-app-routes routes '("") arg-data)
      (let ((path-info (: string tokens raw-path-info '"/")))
        (: sample-app-routes routes path-info arg-data)))))
