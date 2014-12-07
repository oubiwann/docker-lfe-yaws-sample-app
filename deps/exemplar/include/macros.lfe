(defmacro defelem arg
  (let ((tag (car arg)))
    `(progn
      (defun ,tag ()
        (: exemplar-xml make-xml (atom_to_list ',tag)))
      (defun ,tag (content)
        (: exemplar-xml make-xml (atom_to_list ',tag) content))
      (defun ,tag (attrs content)
        (: exemplar-xml make-xml (atom_to_list ',tag) attrs content)))))
