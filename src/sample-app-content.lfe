(defmodule sample-app-content
  (export all))

(include-lib "deps/exemplar/include/html-macros.lfe")

(defun get-side-menu ()
  "An example reusable menu."
  (list
    (li (a '(href "/") '"Main Page"))
    (li (a '(href "/content/1") '"/content/1"))
    (li (a '(href "/content/2") '"/content/2"))
    (li (a '(href "/content/3") '"/content/3"))
    (li
      (list
        (a '(href "/relation/1/2") '"/relation/1/2")))
    (li (a '(href "/bob") '"404"))))

(defun get-navbar()
  "A main navigation bar example."
  (nav '(class "navbar navbar-top" role "navigation")
    (div '(class "container")
      (div '(class "navbar-header")
        (div '(class "collapse navbar-collapse navbar-ex1-collapse")
          (list
            (ul '(class "nav navbar-nav navbar-right")
              (get-side-menu))))))))

(defun base-page (title remaining)
  "A function to provide the base for all pages."
  (list
    (!doctype 'html)
    (html '(lang "en")
      (list
        (head
          (list
            (title title)
            (link '(rel "stylesheet" href "/css/bootstrap-min.css"))
            (link '(rel "stylesheet" href "/css/bootstrap-slate-min.css"))
            (script '(src "/js/bootstrap-min.js"))))
        (body
          (main
            (list
              (get-navbar)
              (div '(class "section")
                (div '(class "container")
                  (div '(class "row well")
                    remaining))))))))))

(defun base-sidebar-page (title sidebar remaining)
  "We can also make building HTML easier by using functions."
  (base-page title
    (list
      sidebar
      remaining)))

(defun get-sidebar-content (arg-data)
  "1-arity content API function.

  This function generates its HTML from scratch."
  (let ((title '"Main Page"))
    (: sample-app-util make-200-result
        (base-sidebar-page
          title
          (div '(class "col-md-3 col-sm-4 sidebar")
            (ul '(class "nav nav-stacked nav-pills")
              (get-side-menu)))
          (div
            (list
              (h1 title)
              (h2 '"Introduction")
              (div
                (p '"This is the main page. Links are to the left."))))))))

(defun get-content (item-id arg-data)
  "2-arity content API.

  This function generates its HTML from scratch."
  ;; we'll pretent to pull content from a data store here ...
  (let ((fetched-title '"Queried Title")
        (fetched-content '"Some super-great queried lorem ipsum."))
    (: sample-app-util make-200-result
      (base-page
        fetched-title
        (div
          (list
            (h1 fetched-title)
            (h2 (++ '"Item " item-id))
            (div (p fetched-content))))))))

(defun get-content (user-id account-id arg-data)
  "3-arity content API.

  This function generates its HTML by calling another function. This is an
  example of how one could do templating -- including putting HTML-generating
  functions in their own modules."
  ;; we'll pretent to pull content from a data store here ...
  (let ((fetched-title '"Queried Title")
        (fetched-content '"Some super-great queried lorem ipsum."))
    (: sample-app-util make-200-result
      (base-page
        fetched-title
        (div
          (list
            (h1 fetched-title)
            (h2 (++ '"Relation: "
                    user-id '" (user id) | "
                    account-id '" (account id)"))
            (div (p fetched-content))))))))

(defun four-oh-four (message)
  "Custom 404 page."
    (: sample-app-util make-404-result
      (base-page
        '"404"
        (div
          (list
            (h1 '"404 - Not Found")
            (div (p message)))))))




