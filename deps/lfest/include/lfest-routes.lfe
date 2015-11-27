(defmacro in (item collection)
  `(orelse ,@(lists:map (lambda (x) `(=== ,x ,item)) collection)))

(defmacro not-in (item collection)
  `(not (in ,item ,collection)))

;; If you want to call functions from macros, they need to be
;; wrapped in (eval-when-compile ...).
(eval-when-compile

  (defun handle-segment
    ((`(#\: . ,var-name))
     (list_to_atom var-name))
    ((seg)
     seg))

  (defun parse-path (path-string)
    (lists:map
     #'handle-segment/1
     (string:tokens path-string "/")))

  (defun make-pattern (method path-string)
    `(,method ,(parse-path path-string) arg-data))

  (defun compile-route
    "For each form passed, the last element is always the expression to
    execute; before it are the method, the path, and the data from YAWS.

    We need to re-form each route as a function head pattern and the
    expression (function to call or output to render) for that pattern."
    ((`('ALLOWONLY ,methods ,expr))
     `((method path arg-data) (when (not-in method ,methods))
       ,expr))
    ((`('NOTFOUND ,expr))
      `((method path arg-data) ,expr))
    ((`(,method ,path ,expr))
     `((,@(make-pattern method path)) ,expr)))

  (defun compile-routes (forms)
    (lists:map #'compile-route/1 forms))

  ) ;; end eval-when-compile

(defmacro defroutes body
  `(defun routes ,@(compile-routes body)))

(defun loaded-lfest-routes ()
  "This is just a dummy function for display purposes when including from the
  REPL (the last function loaded has its name printed in stdout).

  This function needs to be the last one in this include."
  'ok)
