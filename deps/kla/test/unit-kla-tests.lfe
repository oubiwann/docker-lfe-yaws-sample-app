(defmodule unit-kla-tests
  (behaviour ltest-unit)
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest -replace-dash
  (is-equal "has_dash" (kla:-replace-dash "has-dash"))
  (is-equal "has_underscore" (kla:-replace-dash "has_underscore"))
  (is-equal "neither" (kla:-replace-dash "neither")))

(deftest replace-dash-string
  (is-equal "has_dash" (kla:replace-dash "has-dash"))
  (is-equal "has_underscore" (kla:replace-dash "has_underscore"))
  (is-equal "neither" (kla:replace-dash "neither")))

(deftest replace-dash-atom
  (is-equal 'has_dash (kla:replace-dash 'has-dash))
  (is-equal 'has_underscore (kla:replace-dash 'has_underscore))
  (is-equal 'neither (kla:replace-dash 'neither)))

(deftest append-integer-string
  (is-equal "a1" (kla:append-integer "a" 1))
  (is-equal "abc1" (kla:append-integer "abc" 1))
  (is-equal "abc100" (kla:append-integer "abc" 100))
  (is-equal "abc1001" (kla:append-integer "abc" 1001))
  (is-equal "abc1" (kla:append-integer "abc" 001)))

(deftest append-integer-atom
  (is-equal 'a1 (kla:append-integer 'a 1))
  (is-equal 'abc1 (kla:append-integer 'abc 1))
  (is-equal 'abc100 (kla:append-integer 'abc 100))
  (is-equal 'abc1001 (kla:append-integer 'abc 1001))
  (is-equal 'abc1 (kla:append-integer 'abc 001)))

(deftest append-integer-integer
  (is-equal "11" (kla:append-integer 1 1))
  (is-equal "2001" (kla:append-integer 200 1))
  (is-equal "200100" (kla:append-integer 200 100))
  (is-equal "2001001" (kla:append-integer 200 1001))
  (is-equal "21" (kla:append-integer 002 001)))

(deftest make-args
  (is-equal '() (kla:make-args 0))
  (is-equal '(arg-1) (kla:make-args 1))
  (is-equal '(arg-1 arg-2) (kla:make-args 2))
  (is-equal '(arg-1 arg-2 arg-3 arg-4) (kla:make-args 4)))

(deftest make-func
  (is-equal
    '(defun my-func-name ()
      (apply 'mod-1 'my_func_name (list )))
    (kla:make-func '(my-func-name 0) 'mod-1))
  (is-equal
    '(defun my-func-name (arg-1)
      (apply 'mod-2 'my_func_name (list arg-1)))
    (kla:make-func '(my-func-name 1) 'mod-2))
  (is-equal
    '(defun my-func-name (arg-1 arg-2)
      (apply 'mod-3 'my_func_name (list arg-1 arg-2)))
    (kla:make-func '(my-func-name 2) 'mod-3)))

(deftest make-funcs
  (is-equal
    '((defun func-y ()
        (apply 'my-mod 'func_y (list)))
      (defun func-y (arg-1)
        (apply 'my-mod 'func_y (list arg-1)))
      (defun func-y (arg-1 arg-2)
        (apply 'my-mod 'func_y (list arg-1 arg-2))))
    (kla:make-funcs '((func-y 0) (func-y 1) (func-y 2)) 'my-mod)))

(deftest wrap-exported-func
  (is-equal
   '(defun my-func (arg-1)
       (apply 'my-mod 'my-func (list arg-1)))
   (kla:wrap-exported-func 'my-mod #(my-func 1)))
  (is-equal
   '(defun my-func (arg-1 arg-2)
       (apply 'my-mod 'my-func (list arg-1 arg-2)))
   (kla:wrap-exported-func 'my-mod #(my-func 2))))