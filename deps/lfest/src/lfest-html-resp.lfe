(defmodule lfest-html-resp
  (export all))

(defun html-content (data)
  (lfest-resp:content "text/html" data))

(defun not-found (html)
  (lfest-resp:not-found (html-content html)))

(defun ok (html)
  (lfest-resp:ok (html-content html)))

(defun error (status-code html)
  (lfest-resp:response
    status-code
    (html-content html)))
