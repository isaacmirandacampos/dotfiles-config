if exists("b:current_syntax")
  finish
endif

" HTTP Methods
syn keyword hurlMethod GET POST PUT DELETE PATCH OPTIONS HEAD CONNECT TRACE
syn match hurlMethod /^\s*\(GET\|POST\|PUT\|DELETE\|PATCH\|OPTIONS\|HEAD\|CONNECT\|TRACE\)\>/

" URL
syn match hurlUrl /https\?:\/\/[^ \t\n]*/

" HTTP version and status
syn match hurlHttpVersion /HTTP\/[0-9.]\+/
syn match hurlStatus /^HTTP\s\+[0-9]\{3\}/
syn match hurlStatusCode /\<[1-5][0-9][0-9]\>/

" Sections
syn match hurlSection /^\s*\[QueryStringParams\]/
syn match hurlSection /^\s*\[FormParams\]/
syn match hurlSection /^\s*\[MultipartFormData\]/
syn match hurlSection /^\s*\[BasicAuth\]/
syn match hurlSection /^\s*\[Cookies\]/
syn match hurlSection /^\s*\[Captures\]/
syn match hurlSection /^\s*\[Asserts\]/
syn match hurlSection /^\s*\[Options\]/

" Headers (key: value)
syn match hurlHeader /^\s*[A-Za-z][A-Za-z0-9_-]*\s*:/ contains=hurlHeaderKey,hurlHeaderColon
syn match hurlHeaderKey /[A-Za-z][A-Za-z0-9_-]*/ contained
syn match hurlHeaderColon /:/ contained

" Strings
syn region hurlString start=/"/ skip=/\\"/ end=/"/
syn region hurlString start=/`/ end=/`/
syn region hurlMultilineString start=/```/ end=/```/

" Template variables
syn match hurlVariable /{{[^}]*}}/

" Comments
syn match hurlComment /#.*$/

" Predicates / Assert functions
syn keyword hurlPredicate equals notEquals contains includes startsWith endsWith matches exists isBoolean isCollection isEmpty isFloat isInteger isString isDate
syn keyword hurlFilter count urlEncode urlDecode htmlEscape htmlUnescape toInt toFloat split regex nth replace jsonpath xpath header cookie variable body status url bytes sha256 md5 daysAfterNow daysBeforeNow

" Numeric values
syn match hurlNumber /\<[0-9]\+\(\.[0-9]\+\)\?\>/

" Boolean
syn keyword hurlBoolean true false

" null
syn keyword hurlNull null

" Highlights
hi def link hurlMethod Keyword
hi def link hurlUrl Underlined
hi def link hurlHttpVersion Type
hi def link hurlStatus Statement
hi def link hurlStatusCode Number
hi def link hurlSection Title
hi def link hurlHeaderKey Identifier
hi def link hurlHeaderColon Delimiter
hi def link hurlString String
hi def link hurlMultilineString String
hi def link hurlVariable Special
hi def link hurlComment Comment
hi def link hurlPredicate Function
hi def link hurlFilter Function
hi def link hurlNumber Number
hi def link hurlBoolean Boolean
hi def link hurlNull Constant

let b:current_syntax = "hurl"
