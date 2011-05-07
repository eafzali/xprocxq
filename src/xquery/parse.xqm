(: -------------------------------------------------------------------------------------

    parse.xqm - 

 ---------------------------------------------------------------------------------------- :)
xquery version "3.0"  encoding "UTF-8";

module namespace parse = "http://xproc.net/xproc/parse";

 (: declare namespaces :)
 declare namespace xproc="http://xproc.net/xproc";
 declare namespace p="http://www.w3.org/ns/xproc";
 declare namespace c="http://www.w3.org/ns/xproc-step";
 declare namespace err="http://www.w3.org/ns/xproc-error";

 (: module imports :)
 import module namespace const = "http://xproc.net/xproc/const" at "const.xqm";


 (: -------------------------------------------------------------------------- :)
 declare function parse:pipeline-step-sort($unsorted, $sorted, $pipelinename )  {
 (: -------------------------------------------------------------------------- :)
    if (empty($unsorted)) then
        ($sorted)
    else
        let $allnodes := $unsorted [ every $id in p:input[@primary eq 'true'][@port eq 'source']/p:pipe/@step satisfies ($id = $sorted/@name or $id=$pipelinename)]
    return
        if ($allnodes) then
            parse:pipeline-step-sort( $unsorted except $allnodes, ($sorted, $allnodes ),$pipelinename)
        else
            ()         
 };

 (: -------------------------------------------------------------------------- :)
 declare function parse:explicit-names($pipeline){
 (: -------------------------------------------------------------------------- :)
  parse:explicit-names($pipeline, "!1")
 };

 (: -------------------------------------------------------------------------- :)
 declare function parse:explicit-names($pipeline, $cname){
 (: -------------------------------------------------------------------------- :)
    for $node at $count in $pipeline
    let $default-name := fn:concat($cname,'.',$count)
    return 
        typeswitch($node)
            case document-node() 
                 return parse:explicit-names($node/node(),$cname) 
            case text() return $node
            case element(p:pipeline) 
                   return element p:declare-step {$node/@*,
                   if ($node/@name) then () else attribute default-name {$cname},   (: pipeline/step requires name :)
                   parse:explicit-names($node/node(),$cname)}
            case element(p:declare-step) 
                   return element p:declare-step {$node/@*,
                   if ($node/@name) then () else attribute default-name {$cname},   (: pipeline/step requires name :)
                   parse:explicit-names($node/node(),$default-name)}
            case element(p:input) 
                   return element p:input {$node/@*,
                   parse:explicit-names($node/node(),$cname)}
            case element(p:output) 
                   return element p:output {$node/@*,
                   parse:explicit-names($node/node(),$cname)}
            case element(p:identity) 
                   return element p:identity {$node/@*,
                   if ($node/@name) then () else attribute xproc:default-name {$default-name},  
                   parse:explicit-names($node/node())}
            case element() return element {name($node)} {$node/@*,parse:explicit-names($node/node(),$default-name)}
            default return parse:explicit-names($node/node(),$cname)
 };