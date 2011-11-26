xquery version "3.0";

(: temporary commandline runner :)

declare boundary-space strip;

declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";
declare namespace ext ="http://xproc.net/xproc/ext";

import module namespace xproc = "http://xproc.net/xproc" at "../src/xquery/xproc.xqm";

declare variable $xml-uri external;
declare variable $pipe-uri external;
  
let $pipeline := fn:doc($pipe-uri)
let $stdin    := fn:doc($xml-uri)
let $dflag    := 0
let $tflag    := 0
let $bindings := ()
let $options  := ()
let $output   := ()
return
  $xproc:run-step($pipeline,$stdin,$bindings,$options,$output,$dflag,$tflag)

