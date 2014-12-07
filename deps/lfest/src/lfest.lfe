(defmodule lfest
  (export all))

(include-lib "yaws/include/yaws_api.hrl")

(defun parse-path (arg-data)
  (string:tokens (get-path-info arg-data) "/"))

(defun make-header (key value)
  "Makes a header tuple in the format required by YAWS."
  `#(header #(,key ,value)))

(defun get-http-method (arg-data)
  "Extract the HTTP method from the reqeust data."
  (http_request-method (get-request arg-data)))

(defun get-request (arg-data)
  "Use the LFE record macros to extract the request from the records defined in
  yaws_api.hrl."
  (arg-req arg-data))

(defun get-querydata (arg-data)
  "Use the LFE record macros to extract any query parameters from the records
  defined in yaws_api.hrl."
  (arg-querydata arg-data))

(defun get-path-info (arg-data)
  "Use the LFE record macros to extract the path info from the records defined
  in yaws_api.hrl."
  (let ((path-info (arg-pathinfo arg-data)))
    (case path-info
      ('undefined '())
      (_ path-info))))

(defun get-data (arg-data)
  "Use the LFE record macros to extract the path info from the records defined
  in yaws_api.hrl."
  (arg-clidata arg-data))

(defun out-helper (arg-data router)
  "This is intended to be called by your application's 'out' function that is
  called by YAWS."
  (let ((method-name (get-http-method arg-data))
        (path-info (parse-path arg-data)))
    (funcall router method-name path-info arg-data)))
