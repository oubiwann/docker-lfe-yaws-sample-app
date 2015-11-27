(defmodule lfest-text-resp
  (export all))

(defun text-content (data)
  (lfest-resp:content "text/plain" data))

(defun created (message)
  (lfest-resp:response
    (lfest-codes:created)
    (text-content message)))

(defun created (message location)
  (lfest-resp:response
    (lfest-codes:created)
    (text-content message)
    (list (lfest:make-header 'location location))))

(defun created ()
  (created "created"))

(defun updated (message)
  (lfest-resp:response
    (lfest-codes:ok)
    (text-content message)))

(defun updated ()
  (updated "updated"))

(defun deleted (message)
  (lfest-resp:response
    (lfest-codes:ok)
    (text-content message)))

(defun deleted ()
  (deleted "deleted"))

(defun error (status-code message)
  (lfest-resp:response
    status-code
    (text-content (++ "error :" message))))

(defun error ()
  (error
    (lfest-codes:internal-server-error)
    "internal server error"))

(defun not-found (message)
  (error
    (lfest-codes:not-found)
    message))

(defun not-found ()
  (not-found "not found"))

(defun method-not-allowed ()
  (error
    (lfest-codes:method-not-allowed)
    "method not allowed"))

(defun ok (content)
  (lfest-resp:ok (text-content content)))

(defun ok ()
  (ok "ok"))
