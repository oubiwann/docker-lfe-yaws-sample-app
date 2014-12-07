(defmodule exemplar
  (export all)
  (import
    (from lutil-math
      (even? 1))
    (from lutil-type
      (atom? 1)
      (list? 1)
      (partition-list 1))))

(include-lib "exemplar/include/macros.lfe")

(defun space () '" ")

(defun slash () '"/")

(defun opening-bracket () '"<")

(defun closing-bracket () '">")

(defun self-closing-bracket ()
  (++ (space)
      (slash)
      (closing-bracket)))

(defun attrs? (data)
  "a list of attr/value key pairs has to have an even number of elements. The
  first element also has to be an atom. In fact, all even-indexed (zero-based
  counting) elements have to be atoms.

  If these criteria are not met, the list is not an attr collection."
  (let* ((len (length data))
         ((tuple names values) (partition-list data))
         (evens-atoms? (== (length names) (length values))))
    (and (list? data) (and (> len 0) (and (even? len) evens-atoms?)))))

(defun attr-to-string (name value)
  (++ (atom_to_list name)
      '"=\""
      value
      '"\" "))

(defun attrs-to-string (attrs)
  (let (((tuple names values) (partition-list attrs)))
    (: lists concat
      (: lists zipwith #'attr-to-string/2 names values))))

(defun -opening-tag (tag bracket)
  (++ (opening-bracket)
      tag
      bracket))

(defun -opening-tag (tag attrs bracket)
  (++ (opening-bracket)
      tag
      (space)
      (: lutil-text strip (attrs-to-string attrs))
      bracket))

(defun opening-tag (tag)
  (-opening-tag tag (closing-bracket)))

(defun opening-tag (tag attrs)
  (-opening-tag tag attrs (closing-bracket)))

(defun closing-tag (tag)
  (++ (opening-bracket)
      (slash)
      tag
      (closing-bracket)))

(defun self-closing-tag (tag)
  (-opening-tag tag (self-closing-bracket)))

(defun self-closing-tag (tag attrs)
  (-opening-tag tag attrs (self-closing-bracket)))

(defun non-closing-tag (tag)
  (-opening-tag tag (closing-bracket)))

(defun non-closing-tag (tag attrs)
  (-opening-tag tag attrs (closing-bracket)))
