(: ------------------------------------------------------------------------------------- 

	opt.xqm - Implements all xproc optional steps.
	
---------------------------------------------------------------------------------------- :)
xquery version "3.0" encoding "UTF-8";

module namespace opt = "http://xproc.net/xproc/opt";

(: declare namespaces :)
declare namespace xproc = "http://xproc.net/xproc";
declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";

(: module imports :)
import module namespace const = "http://xproc.net/xproc/const" at "const.xqm";
(: import module namespace xslfo = "http://exist-db.org/xquery/xslfo"; (: for p:xsl-formatter :) :)

(: declare functions :)
declare variable $opt:exec := ();
declare variable $opt:hash := ();
declare variable $opt:uuid := ();
declare variable $opt:www-form-urldecode := ();
declare variable $opt:www-form-urlencode := ();
declare variable $opt:validate-with-xml-schema := ();
declare variable $opt:validate-with-schematron := ();
declare variable $opt:validate-with-relax-ng := ();
declare variable $opt:xquery := ();
declare variable $opt:xsl-formatter := ();


(: -------------------------------------------------------------------------- :)
declare function opt:exec($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};

(: -------------------------------------------------------------------------- :)
declare function opt:hash($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function opt:uuid($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function opt:www-form-urldecode($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function opt:www-form-urlencode($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function opt:validate($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function opt:xsl-formatter($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function opt:xquery($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};



