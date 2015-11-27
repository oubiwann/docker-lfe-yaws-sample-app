(defmodule kla
  (export all))

(defun -replace-dash (item)
  (re:replace item "-" "_" '(global #(return list))))

(defun replace-dash
  ((item) (when (is_list item))
    (-replace-dash item))
  ((item) (when (is_atom item))
    (list_to_atom (-replace-dash (atom_to_list item)))))

(defun -append-integer (item integer)
  (++ item (integer_to_list integer)))

(defun append-integer
  ((item integer) (when (is_list item))
    (-append-integer item integer))
  ((item integer) (when (is_atom item))
    (list_to_atom (-append-integer (atom_to_list item) integer)))
  ((item integer) (when (is_integer item))
    (-append-integer (integer_to_list item) integer)))

(defun make-args
  ((arity) (when (== arity 0))
    '())
  ((arity)
    (lists:map
      (lambda (x)
        (append-integer 'arg- x))
      (lists:seq 1 arity))))

(defun make-func
  ((`(,lfe-func-name ,func-arity) mod)
    (let ((erlang-func-name (replace-dash lfe-func-name))
          (func-args (make-args func-arity)))
      `(defun ,lfe-func-name ,func-args
        (apply ',mod ',erlang-func-name (list ,@func-args))))))

(defun make-funcs (func-list mod)
  (lists:map
    (lambda (x)
      (make-func x mod))
    func-list))

(defun wrap-mod-funcs (mod)
  (let ((funcs (lutil-file:get-module-exports mod)))
    (lists:map
     (lambda (x)
       (wrap-exported-func mod x))
     (filter-funcs funcs))))

(defun filter-funcs (funcs)
  (let ((skips '(module_info)))
    (lists:filter
      (match-lambda
        ((`#(,func ,_)) (not (lists:member func skips))))
      funcs)))

(defun wrap-exported-func
  ((mod `#(,func ,arity))
   (let ((func-args (make-args arity)))
     `(defun ,func ,func-args
        (apply ',mod ',func (list ,@func-args))))))
