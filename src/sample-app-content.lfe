(defmodule sample-app-content
  (export all))

(include-file "deps/exemplar/include/html-macros.lfe")

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
              (sample-app-nav:get-navbar)
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
  (let ((title "Main Page"))
    (lfest-html-resp:ok
        (base-sidebar-page
          title
          (div '(class "col-md-3 col-sm-4 sidebar")
            (ul '(class "nav nav-stacked nav-pills")
              (sample-app-nav:get-side-menu)))
          (div
            (list
              (h1 title)
              (h2 "Introduction")
              (div
                (p "This is the main page. Links are to the left."))))))))

(defun get-content (item-id arg-data)
  "2-arity content API.

  This function generates its HTML from scratch."
  ;; we'll pretent to pull content from a data store here ...
  (let ((fetched-title "Queried Title")
        (fetched-content "Some super-great queried lorem ipsum."))
    (lfest-html-resp:ok
      (base-page
        fetched-title
        (div
          (list
            (h1 fetched-title)
            (h2 (++ "Item " item-id))
            (div (p fetched-content))))))))

(defun get-content (user-id account-id arg-data)
  "3-arity content API.

  This function generates its HTML by calling another function. This is an
  example of how one could do templating -- including putting HTML-generating
  functions in their own modules."
  ;; we'll pretent to pull content from a data store here ...
  (let ((fetched-title "Queried Title")
        (fetched-content "Some super-great queried lorem ipsum."))
    (lfest-html-resp:ok
      (base-page
        fetched-title
        (div
          (list
            (h1 fetched-title)
            (h2 (++ "Relation: "
                    user-id " (user id) | "
                    account-id " (account id)"))
            (div (p fetched-content))))))))

(defun four-oh-four (message)
  "Custom 404 page."
    (lfest-html-resp:not-found
      (base-page
        "404"
        (div
          (list
            (h1 "404 - Not Found")
            (div (p message)))))))




