; extends

(call_expression
 function: (member_expression
   object: (identifier) @_name
     (#eq? @_name "py"))
 arguments: ((template_string) @injection.content
   (#offset! @injection.content 0 1 0 -1)
   (#set! injection.language "python")))

(call_expression
 function: (call_expression
   function: (member_expression
    object: (identifier) @_name
      (#eq? @_name "py")))
 arguments: ((template_string) @injection.content
   (#offset! @injection.content 0 1 0 -1)
   (#set! injection.language "python")))

(call_expression
 function: (member_expression
   object: (identifier) @_name
     (#eq? @_name "html"))
 arguments: ((template_string) @injection.content
   (#offset! @injection.content 0 1 0 -1)
   (#set! injection.language "html")))

(call_expression
 function: (call_expression
   function: (member_expression
    object: (identifier) @_name
      (#eq? @_name "html")))
 arguments: ((template_string) @injection.content
   (#offset! @injection.content 0 1 0 -1)
   (#set! injection.language "html")))

(call_expression
 function: (member_expression
   object: (identifier) @_name
     (#eq? @_name "js"))
 arguments: ((template_string) @injection.content
   (#offset! @injection.content 0 1 0 -1)
   (#set! injection.language "tsx")))

(call_expression
 function: (call_expression
   function: (member_expression
    object: (identifier) @_name
      (#eq? @_name "js")))
 arguments: ((template_string) @injection.content
   (#offset! @injection.content 0 1 0 -1)
   (#set! injection.language "tsx")))

(call_expression
 function: (member_expression
   object: (identifier) @_name
     (#eq? @_name "ts"))
 arguments: ((template_string) @injection.content
   (#offset! @injection.content 0 1 0 -1)
   (#set! injection.language "tsx")))

(call_expression
 function: (call_expression
   function: (member_expression
    object: (identifier) @_name
      (#eq? @_name "ts")))
 arguments: ((template_string) @injection.content
   (#offset! @injection.content 0 1 0 -1)
   (#set! injection.language "tsx")))

(call_expression
 function: (member_expression
   object: (identifier) @_name
     (#eq? @_name "react"))
 arguments: ((template_string) @injection.content
   (#offset! @injection.content 0 1 0 -1)
   (#set! injection.language "tsx")))

(call_expression
 function: (call_expression
   function: (member_expression
    object: (identifier) @_name
      (#eq? @_name "react")))
 arguments: ((template_string) @injection.content
   (#offset! @injection.content 0 1 0 -1)
   (#set! injection.language "tsx")))


(call_expression
 function: (member_expression
   object: (identifier) @_name
     (#eq? @_name "svelte"))
 arguments: ((template_string) @injection.content
   (#offset! @injection.content 0 1 0 -1)
   (#set! injection.language "svelte")))

(call_expression
 function: (call_expression
   function: (member_expression
    object: (identifier) @_name
      (#eq? @_name "svelte")))
 arguments: ((template_string) @injection.content
   (#offset! @injection.content 0 1 0 -1)
   (#set! injection.language "svelte")))
