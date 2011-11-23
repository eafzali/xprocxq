(: ------------------------------------------------------------------------------------- 

	std.xqm - Implements all standard xproc steps.
	
---------------------------------------------------------------------------------------- :)
xquery version "3.0" encoding "UTF-8";

module namespace std = "http://xproc.net/xproc/std";

(: declare namespaces :)
declare namespace xproc = "http://xproc.net/xproc";
declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";

(: module imports :)
import module namespace const = "http://xproc.net/xproc/const" at "const.xqm";
import module namespace u = "http://xproc.net/xproc/util" at "util.xqm";

(: declare functions :)
declare variable $std:add-attribute      := ();
declare variable $std:add-xml-base       := ();
declare variable $std:count              := std:count#4;
declare variable $std:compare            := ();
declare variable $std:delete             := ();
declare variable $std:error              := ();
declare variable $std:filter             := ();
declare variable $std:directory-list     := ();
declare variable $std:escape-markup      := ();
declare variable $std:http-request       := ();
declare variable $std:identity           := std:identity#4;
declare variable $std:insert             := ();
declare variable $std:label-elements     := ();
declare variable $std:load               := ();
declare variable $std:make-absolute-uris := ();
declare variable $std:namespace-rename   := ();
declare variable $std:pack               := ();
declare variable $std:parameters         := ();
declare variable $std:rename             := ();
declare variable $std:replace            := ();
declare variable $std:set-attributes     := ();
declare variable $std:sink               := ();
declare variable $std:split-sequence     := ();
declare variable $std:store              := ();
declare variable $std:string-replace     := ();
declare variable $std:unescape-markup    := ();
declare variable $std:xinclude           := ();
declare variable $std:wrap               := ();
declare variable $std:wrap-sequence      := ();
declare variable $std:unwrap             := ();
declare variable $std:xslt               := ();


(: -------------------------------------------------------------------------- :)
declare function std:add-attribute($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:add-xml-base($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:compare($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: --------------------------------------------------------------------------------------- :)
declare function std:count($primary,$secondary,$options,$variables) as element(c:result){
(: --------------------------------------------------------------------------------------- :)
let $limit as xs:integer := xs:integer(u:get-option('limit',$options,$primary))
let $count as xs:integer := count($primary)
return
    if ($limit eq 0 or $count lt $limit ) then
      u:outputResultElement($count)
    else
      u:outputResultElement($limit)
};


(: -------------------------------------------------------------------------- :)
declare function std:delete($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:directory-list($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:escape-markup($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:error($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:filter($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:http-request($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:identity($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
$primary
};


(: -------------------------------------------------------------------------- :)
declare function std:insert($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:label-elements($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:load($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:make-absolute-uris($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:namespace-rename($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};



(: -------------------------------------------------------------------------- :)
declare function std:pack($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:parameters($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:rename($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:replace($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:set-attributes($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:sink($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:split-sequence($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:store($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:string-replace($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:unescape-markup($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:xinclude($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:wrap($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:wrap-sequence($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:unwrap($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:xslt($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
()
};


