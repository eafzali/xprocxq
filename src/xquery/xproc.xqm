(: -------------------------------------------------------------------------------------

    xproc.xqm - core xqm contains entry points, primary eval-step function and
    control functions.

 ---------------------------------------------------------------------------------------- :)
xquery version "3.0"  encoding "UTF-8";

module namespace xproc = "http://xproc.net/xproc";

 (: declare namespaces :)
 declare namespace p="http://www.w3.org/ns/xproc";
 declare namespace c="http://www.w3.org/ns/xproc-step";
 declare namespace err="http://www.w3.org/ns/xproc-error";

 (: module imports :)
 import module namespace const = "http://xproc.net/xproc/const" at "const.xqm";
 import module namespace parse = "http://xproc.net/xproc/parse" at "parse.xqm";

 (: declare options :)
 declare boundary-space strip;
 declare option saxon:output "indent=yes";

 (: declare functions :)
 declare variable $xproc:run-step       := xproc:run#6;
 declare variable $xproc:parse-and-eval := ();
 declare variable $xproc:declare-step   := ();
 declare variable $xproc:choose         := ();
 declare variable $xproc:try            := ();
 declare variable $xproc:catch          := ();
 declare variable $xproc:group          := ();
 declare variable $xproc:for-each       := ();
 declare variable $xproc:viewport       := ();
 declare variable $xproc:library        := ();
 declare variable $xproc:pipeline       := ();
 declare variable $xproc:variable       := ();


 (: entry point :)
 (: -------------------------------------------------------------------------- :)
 declare function xproc:run($pipeline,$stdin,$dflag,$tflag,$bindings,$options){
 (: -------------------------------------------------------------------------- :)

     (: STEP I: preprocess :)
     let $validate       := ()
     let $namespaces     := ()
     let $explicit-type  := parse:explicit-type($pipeline)
     let $explicit-name  := parse:explicit-name($explicit-type,'!1')

     let $xproc-binding   := ()

     (: STEP II: eval AST :)
     let $eval_result := ()

     (: STEP III: serialize and return results :)
     let $serialized_result := $pipeline

     return 
       $serialized_result

         
 };

