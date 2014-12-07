(defmacro in (item collection)
  `(orelse ,@(lists:map (lambda (x) `(=== ,x ,item)) collection)))

(defmacro not-in (item collection)
  `(not (in ,item ,collection)))

;; If you want to call functions from macros, they need to be
;; wrapped in (eval-when-compile ...).
(eval-when-compile

  (defun check-segment
    (((cons colon var-name)) (when (=:= colon 58))
     (list_to_atom var-name))
    ((seg)
     seg))

  (defun parse-path (path-string)
    (lists:map
      #'check-segment/1
      (string:tokens path-string "/")))

  (defun rebuild-head
    (((list method path-string))
     `(,method ,(parse-path path-string) arg-data)))

  (defun split-params (elements)
    "For each form passed, the last element is always the expression to
    execute; before it are the method, the path, and the data from YAWS.

    We need to re-form each route as a function head pattern and the
    expression (function to call or output to render) for that pattern."
    (let* (((cons tail rev-head) (lists:reverse elements))
           (head (lists:reverse rev-head)))
      (case (eval (car head))
        ('ALLOWONLY `((method p a) (when (not-in method ,(lists:nth 2 head)))
                      ,tail))
        ('NOTFOUND `((method path arg-data) ,tail))
        (_ `((,@(rebuild-head head)) ,tail)))))

  (defun compile-routes (forms)
    (lists:map #'split-params/1 forms)))

(defmacro defroutes body
  `(defun routes ,@(compile-routes body)))
