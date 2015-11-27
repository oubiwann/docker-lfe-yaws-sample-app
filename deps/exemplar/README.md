# exemplar [![Build Status][travis-badge]][travis]

[travis]: https://travis-ci.org/lfex/exemplar
[travis-badge]: https://travis-ci.org/lfex/exemplar.png?branch=master

[![][juggernaut-tiny]][juggernaut-large]

[juggernaut-tiny]: resources/images/juggernaut-tiny.png
[juggernaut-large]: resources/images/juggernaut-large.png

*Markup Language Expressions for LFE: creating HTML with s-expressions on the Erlang VM.*


## Introduction

### Supported Tags

[![][html5_logo]][html5_logo]

[html5_logo]: resources/images/HTML5_Logo_tiny.png

Right now, only HTML5 is supported. Feel free to submit pull requests to support
older/different tags/elements.

The list of tags was obtained from [Mozilla's HTML 5 documentation][mz]

[mz]: https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/HTML5/HTML5_element_list

Note that XML namespacing hasn't been explored yet, but *should* be possible.

### Current Status

As you can see in the example usage below, you can use exemplar to build HTML
strings using LFE S-expressions. However, do note that the project has *just*
started and there are lots of unexplored HTML edge-cases that simply won't work
right now.

If you come across anything, feel free to submit a bug in the github issue
tracker, or even send us a pull request :-)


### About the Name

Naming and cache invalidation, right?

The first thought was to name the project ML-expr: ML for HTML, replacing the
"s" of "s-expression". MLEXPR isn't all that pronouncable, so another "e" and
an "a" were added for "exemplar". That's all there is to it.

Also: "Do you know who I *am*?!"


## Dependencies

This project assumes that you have [rebar](https://github.com/rebar/rebar)
installed somwhere in your ``$PATH``.

This project depends upon the following, which installed to the ``deps``
directory of this project when you run ``make deps``:

* [LFE](https://github.com/rvirding/lfe) (Lisp Flavored Erlang; needed only
  to compile)
* [ltest](https://github.com/lfex/ltest) (needed only to run the tests)


## Installation

Just add it to your ``rebar.config`` deps:

```erlang
{deps, [
    ...
    {exemplar, ".*", {git, "git@github.com:lfex/exemplar.git", "master"}}
  ]}.
```

And then do the usual:

```bash
$ rebar get-deps
$ rebar compile
```


## Usage

### Interactive Use from the REPL

#### HTML

Start the REPL:

```bash
$ make shell
```

Then, from a clone of exemplar:

```lfe
> (slurp "src/exemplar-html.lfe")
#(ok exemplar-html)
> (html (body (div (p "Here is some content")))))
```

Or, from your own project with exemplar as a dep:

```lfe
> (slurp "deps/exemplar/src/exemplar-html.lfe")
#(ok exemplar-html)
> (html (body (div (p "Here is some content")))))
```

Which will give the following output

```html
"<html><body><div><p>Here is some content</p></div></body></html>"
```


#### Custom Elements

You can create your own elements, too. In your project that has exemplar set
up as a dependency, create a module and ``include-lib`` the macros file:

```lfe
(defmodule my-project
  (export all))

(include-lib "exemplar/include/xml-macros.lfe")

(defelem custom-elem)
```

Then, you can ``make shell``, ``slurp`` that file, and use your new element:

```lfe
> (slurp "src/my-project.lfe")
#(ok my-project)
> (custom-elem (custom-elem "much wow"))
```

Which will give the following output

```html
"<custom-elem><custom-elem>much wow</custom-elem></custom-elem>"
```

#### Current Limitations

Right now, the ``defelem`` macro which generates all the HTML functions only
generates functions with three different arities. For instance,
``include/html-macros.lfe`` defines the ``div`` element:

```lfe
(defelem div)
```

The ``defelem`` macro in ``include/xml-macros.lfe`` generates three functions with
this definition:

* ``div/0``
* ``div/1``
* ``div/2``

We can see these three aritiies in action by slurping ``src/exemplar-html.lfe``
and calling these functions:

```lfe
> (slurp "src/exemplar-html.lfe")
#(ok exemplar-html)
> (div)
"<div />"
> (div "some content")
"<div>some content</div>"
> (div '(class "some-css") "some content")
"<div class=\"some-css\">some content</div>"
```

What this means is that (for now) you cannot do something like this:

```lfe
> (div (p "paragraph 1") (p "paragraph 2") (p "paragraph 3"))
exception error: #(unbound_func #(div 3))
```

Since there is no ``#'div/3``. Instead, you will have to do this:

```lfe
> (div (list (p "paragraph 1") (p "paragraph 2") (p "paragraph 3")))
"<div><p>paragraph 1</p><p>paragraph 2</p><p>paragraph 3</p></div>"
```

Another common use case:

```lfe
> (ul (list (li "a") (li "b") (li "c")))
"<ul><li>a</li><li>b</li><li>c</li></ul>"
```

Note that the 1-arity generated functions have some smarts: in addition to being
able to handle lists of elements, they can also handle lists of attributes and
string content. You've seen the string content and list arguments above; here's
``#'div/1`` with attributes:

```lfe
> (div '(id "div-1" class "big"))
"<div id=\"div-1\" class=\"big\" />"
```

Here's an example using a variable:

```lfe
> (set class "bigger")
"bigger"
> (div `(id "div-1" class ,class))
"<div id=\"div-1\" class=\"bigger\" />"
> (div (list 'id "div-1" 'class class))
"<div id=\"div-1\" class=\"bigger\" />"
```


### Using Exemplar with YAWS

If you are running a YAWS-based project, you can easily include exemplar in it.
Any function that is returning content to YAWS can simply use the exemplar HTML
macros.

For instance, let's say you had a YAWS project that was configured like so:

```apache
logdir = logs
ebin_dir = deps/yaws/var/yaws/ebin
ebin_dir = ebin
log_resolve_hostname = false
fail_on_bind_err = true

<server localhost>
        port = 5099
        listen = 0.0.0.0
        appmods = </, my-project>
        docroot = www
</server>
```

Then the ``my-project.lfe`` file might look something like this:
```lfe
(defmodule my-project
  (export all))

(include-lib "deps/exemplar/include/html-macros.lfe")

(defun out (arg-data)
  "This function is executed by YAWS. It is the YAWS entry point for our app."
  (let ((path-info (string:tokens
                      (parse-path arg-data)
                      "/")))
    (routes path-info arg-data)))

(defun routes
  "Routes for our app."
  ;; /content/:id
  (((list "content" item-id) arg-data)
   (content-api item-id arg-data))
  ;; potentially many other routes
  ...
  ;; When nothing matches, do this
  ((path method arg)
    (io:format
      "Unmatched route!~n Path-info: ~p~n arg-data: ~p~n~n"
      (list path arg))
    (make-error-response "Unmatched route.")))

(defun make-html-response (html)
  (tuple 'content
         "text/html"
         html))

(defun content-api (id request-data)
  ;; pull content from a data store
  (let ((fetched-title "Queried Title")
        (fetched-content "Some super-great queried lorem ipsum."))
    ({{PROJECT}}-util:make-200-result
      (html
        (list
            (head
              (title fetched-title))
            (body
              (main
                (div '(class "dynamic content")
                  (list
                    (h1 fetched-title)
                    (h2 (++ "Item " item-id))
                    (div (p fetched-content)))))))))))
```

Note that, due to the current limitation of the generated HTML element function
arities, we have to wrap sibling calls (e.g., ``(head ...) (body ...)`` in a
``list``.

Needless to say, one could also create custom templates via functions that
generate partial HTML and have parameters/variables for addition HTML to be
passed.

If you'd like to see this example running, download
[lfetool](https://github.com/lfex/lfetool), install it, and then
execute these commands:
```bash
$ lfetool new yaws my-web-proj
$ cd my-web-proj
$ make dev
```

Then point your browser at [http://localhost:5099/](http://localhost:5099/).

For more information on using LFE with YAWS, be sure to check out the
[LFE REST example app](https://github.com/lfex/yaws-rest-starter).
