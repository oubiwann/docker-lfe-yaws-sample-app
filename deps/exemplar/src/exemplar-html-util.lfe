(defmodule exemplar-html-util
  (export all)
  (import
    (from lutil-type
      (string? 1)
      (list? 1))
    (from exemplar
      (attrs? 1))))

(defun make-html (tag)
  (: exemplar-xml make-xml tag))

(defun doctype ()
  (: exemplar opening-tag '"!DOCTYPE html"))

(defun doctype (arg1 arg2)
  (: exemplar opening-tag
    (: lists flatten
      (: io_lib format
        '"!DOCTYPE html PUBLIC \"~s\" \"~s\""
        (list arg1 arg2)))))

(defun handle-doctype
  (('html)
    (doctype))
  (('(html))
    (doctype))
  ((`(,_ ,_ ,arg1 ,arg2))
    (doctype arg1 arg2)))

(defun make-html
  (('"!doctype" data)
    (: io_lib format (++ (handle-doctype data) '"~n") '()))
  (('"link" attrs)
    (: exemplar non-closing-tag '"link" attrs))
  (('"script" attrs)
    (make-html '"script" attrs '""))
  ((tag content-or-attrs)
   (let ((data (: exemplar-xml make-xml tag content-or-attrs)))
     (cond
       ;; if it's a list, it could be a list of elements or it could be a list of
       ;; attr/value pairs
       ((attrs? content-or-attrs)
         (++ (: exemplar self-closing-tag tag content-or-attrs)))
       ;; if it's a string, use the make-xml/2 function, since that's going to be
       ;; content
       ((string? content-or-attrs)
         data)
       ;; if it's a list of elements (i.e., not a list of attrs), use the same
       ;; function, but flatten the result
       ((list? content-or-attrs)
         (: lists flatten data))))))

(defun make-html (tag attrs content)
  (: exemplar-xml make-xml tag attrs content))

