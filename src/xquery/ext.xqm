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
import module namespace const = "http://xproc.net/xproc/const" at "const.xqm";
import module namespace u = "http://xproc.net/xproc/util" at "util.xqm";



(: declare functions :)
declare variable $ext:pre       := ext:pre#4;
declare variable $ext:post      := ext:post#4;
declare variable $ext:xproc     := ext:xproc#4;
declare variable $ext:xsltforms := ext:xsltforms#4;

(: -------------------------------------------------------------------------- :)
declare function ext:pre($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
$primary
};


(: -------------------------------------------------------------------------- :)
declare function ext:post($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
$primary
};


(: -------------------------------------------------------------------------- :)
declare function ext:xproc($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
()
(: unsure if this is defined here or in xproc.xqm

  let $pipeline :=  u:get-secondary('pipeline',$secondary)
  let $dflag    :=  u:get-option('dflag',$options,$primary)
  let $tflag    :=  u:get-option('tflag',$options,$primary)
  let $bindings := ()
  let $options  := ()
  return
    $xproc:run-step($pipeline,$primary,$bindings,$options,(),$dflag,$tflag)
:)
};


(:-------------------------------------------------------------------------- :)
declare function ext:xsltforms($primary,$secondary,$options,$variables){
(: TODO- unsure about the logic of this :)
(: -------------------------------------------------------------------------- :)
()
};


