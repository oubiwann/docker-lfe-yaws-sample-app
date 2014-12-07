(defmodule lfest-json-resp
  (export all))

(defun json-content (data)
  (lfest-resp:content "application/json" data))

(defun json-result (data)
  (json-content (++ "{\"result\": " data "}")))

(defun json-text-result (text)
  (json-content (++ "{\"result\": \"" text "\"}")))

(defun created (message)
  (lfest-resp:response
    (lfest-codes:created)
    (json-text-result message)))

(defun created (message location)
  (lfest-resp:response
    (lfest-codes:created)
    (json-text-result message)
    (list (lfest:make-header 'location location))))

(defun created ()
  (created "created"))

(defun updated (message)
  (lfest-resp:response
    (lfest-codes:ok)
    (json-text-result message)))

(defun updated ()
  (updated "updated"))

(defun deleted (message)
  (lfest-resp:response
    (lfest-codes:ok)
    (json-text-result message)))

(defun deleted ()
  (deleted "deleted"))

(defun error (status-code message)
  (lfest-resp:response
    status-code
    (json-result (++ "{\"error\": \"" message "\"}"))))

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
  (lfest-resp:ok (json-text-result content)))

(defun ok ()
  (ok "ok"))
