(defun value (tag &key contents classes attrs styles)
    ;; if contents is list, concatenate contents
    (if (listp contents)
        (setq contents (apply 'concatenate 'string contents)))
    (concatenate 'string
        "<" tag
        (if classes (concatenate 'string " class=\"" classes "\""))
        (if attrs (concatenate 'string " " attrs))
        (if styles (concatenate 'string " style=\"" styles "\""))
        (if (string-equal tag "DOCTYPE")
            (concatenate 'string ">" contents)
            (if (member tag (list "img" "meta"))
                "/>"
                (concatenate 'string ">" contents "</" tag ">")
            )
        )
    )
)

(defvar attributes (list "p" "img" "meta" "link" "script" "style" "body" "html" "head" "doctype" "table" "h1" "br" "hr" "a" "table" "tr" "td" "th" "ul" "li" "nav" "title"))

;; use format 'item item
(defvar *allowed-tags* 
    (loop for item in attributes
        ;; get item as quote
        collect (list (read-from-string item) item)
))

(print *allowed-tags*)

(loop for tag in *allowed-tags* do
    (eval `(defun ,(nth 0 tag) (contents &key classes attrs styles)
        (value ,(nth 1 tag) :contents contents :classes classes :attrs attrs :styles styles)
        ;; value ,tag :contents contents :classes classes :attrs attrs)
    )
))

(defvar global-styles 
    (style "li {
        padding: 10px;
    }")
)

(defvar myhead
    (list
        (title "James' Coffee Blog")
        (meta "" :attrs "description='this is my blog!'")
        (meta "" :attrs "rel='me' value='mailto:jamesg@jamesg.blog'")
        global-styles
    )
)

(defvar content
    (list
        (h1 "James' Coffee Blog")
        (p "I am presently experimenting with the Lisp programming langauge. To learn more about Lisp, I have been implementing my own HTML template generator." :styles "max-width: 300px;")
        (p "This is a web page made in Lisp!")
        (table 
            (list
                (tr (list (td (a "Home" :attrs "href='/'"))
                    (td (a "About" :attrs "href='/about'"))
                    (td (a "Contact" :attrs "href='/contact'"))
                )) 
                (tr (list (td (a "Home" :attrs "href='/'"))
                    (td (a "About" :attrs "href='/about'"))
                    (td (a "Contact" :attrs "href='/contact'"))
                ))
            )
            :styles "background-color: lightblue; border: 1px solid black;"
        )
        (hr "")
        (p "Made with love and coffee by capjamesg!")
        (a "View my website" :attrs "rel='me' href='http://jamesg.blog'")
        (nav (ul (list (li "Home") (li "About") (li "Contact")) :styles "background-color: lightblue; display: flex; flex-direction: row; list-style-type: none; padding: 0;"))
    )
)

(defun doc (contents)
    (html 
        (list
            (head myhead)
            (body contents)
        )
    )
)

(with-open-file (stream "output.html" :direction :output :if-exists :overwrite)
    (format stream (doc content))
)