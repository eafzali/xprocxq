(: ------------------------------------------------------------------------------------- 

	ext.xqm - implements all xprocxq specific extension steps.
	
---------------------------------------------------------------------------------------- :)
xquery version "3.0" encoding "UTF-8";

module namespace ext = "http://xproc.net/xproc/ext";

(: declare namespaces :)
declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";
declare namespace xproc = "http://xproc.net/xproc";

(: module imports :)


(: declare functions :)
declare variable $ext:pre       := ();
declare variable $ext:post      := ();
declare variable $ext:xproc     := ();
declare variable $ext:xsltforms := ();

(: -------------------------------------------------------------------------- :)
declare function ext:pre($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
()
(:
let $v := u:get-primary($primary)
return
	$v
:)
};


(: -------------------------------------------------------------------------- :)
declare function ext:post($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function ext:xproc($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
(: NOTE - this function needs to be defined here, but use-function in xproc.xqm :)
    ()
};


(:-------------------------------------------------------------------------- :)
declare function ext:xsltforms($primary,$secondary,$options,$variables){
(: TODO- unsure about the logic of this :)
(: -------------------------------------------------------------------------- :)
()
};


