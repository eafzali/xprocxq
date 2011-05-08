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
 declare namespace ext="http://xproc.net/xproc/ext";

 (: module imports :)
 import module namespace const = "http://xproc.net/xproc/const" at "const.xqm";



 (: -------------------------------------------------------------------------- :)
 declare function parse:type($node) as xs:string{
 (: -------------------------------------------------------------------------- :)
 let $name := name($node)
 return
   if ($const:std-steps/p:declare-step[@type=$name]) then
     'std-step'
   else if($const:opt-steps/p:declare-step[@type=$name]) then
     'opt-step'
   else if($const:ext-steps/p:declare-step[@type=$name]) then
     'ext-step'
   else if($const:comp-steps/xproc:element[@type=$name][@xproc:step eq "true"]) then
     'comp-step'
   else if($const:comp-steps/xproc:element[@type=$name]) then
     'comp'
   else if($node/@type) then
     'defined'
   else
     'error'      (: throw err:XS0044 ?:)
 };

 (: -------------------------------------------------------------------------- :)
 declare function parse:pipeline-step-sort($unsorted, $sorted, $pipelinename){
 (: -------------------------------------------------------------------------- :)
    if (empty($unsorted)) then
        ($sorted)
    else
        let $allnodes := $unsorted [ every $id in p:input[@primary eq 'true'][@port eq 'source']/p:pipe/@step satisfies ($id = $sorted/@xproc-defaultname or $id = $pipelinename)]
    return
        if ($allnodes) then
            parse:pipeline-step-sort( $unsorted except $allnodes, ($sorted, $allnodes ),$pipelinename)
        else
            ()         
 };

 (: -------------------------------------------------------------------------- :)
 declare function parse:explicit-name($pipeline){
 (: -------------------------------------------------------------------------- :)
  element p:declare-step {
    $pipeline/@*,
    attribute xproc:default-name {'!1'},
    parse:explicit-name($pipeline, '!1')
  }
 };

 (: -------------------------------------------------------------------------- :)
 declare function parse:explicit-name($pipeline,$cname){
 (: -------------------------------------------------------------------------- :)
 (: generate ext:pre with all components :)
 (: resolve import or throw XD0002:)
 (: output pipeline steps:)
 (: generate ext:xproc if p:declare-step/@type :)
 (: give each step default name :)
 (: ensure ports refer to these default names :)
 (: sort :)
 (: generate ext:post :)

( 
 for $step in $pipeline/*[@xproc:type eq 'comp']
 return
   element {node-name($step)} {
     $step/@*,
      parse:explicit-name($step, $cname)
   }
,
 for $step at $count in $pipeline/*[@xproc:step eq  'true']
 return
   element {node-name($step)} {
     $step/@*,
     attribute xproc:defaultname { fn:concat($cname,".",$count)},
     parse:explicit-name($step, fn:concat($cname,".",$count))
   }
)
};


 (: -------------------------------------------------------------------------- :)
 declare function parse:explicit-type($pipeline){
 (: -------------------------------------------------------------------------- :)
    for $node at $count in $pipeline
    let $type := parse:type($node)
    return 
        typeswitch($node)
            case text()
                   return $node
            case document-node() 
                   return
                     parse:explicit-type($node/node()) 
            case element(p:pipeline)
                   return element p:declare-step {$node/@*,
                     namespace xproc {'http://xproc.net/xproc'},
                     attribute xproc:type {$type}, 
                     parse:explicit-type($node/node())}
            case element(p:declare-step) 
                   return element p:declare-step {$node/@*,
                     namespace xproc {'http://xproc.net/xproc'},
                     attribute xproc:type {$type}, 
                     parse:explicit-type($node/node())}
            case element() 
                   return element {node-name($node)} {$node/@*,
                     if (fn:contains($type,'step')) then attribute xproc:step {fn:true()} else (),
                     if ($type ne 'error') then attribute xproc:type {$type} else (),
                     parse:explicit-type($node/node())} 
            default return parse:explicit-type($node/node())
 };