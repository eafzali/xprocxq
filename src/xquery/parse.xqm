(: -------------------------------------------------------------------------------------

    parse.xqm - 

 ---------------------------------------------------------------------------------------- :)
xquery version "3.0"  encoding "UTF-8";

module namespace parse = "http://xproc.net/xproc/parse";

declare boundary-space strip;

 (: declare namespaces :)
 declare namespace xproc="http://xproc.net/xproc";
 declare namespace p="http://www.w3.org/ns/xproc";
 declare namespace c="http://www.w3.org/ns/xproc-step";
 declare namespace err="http://www.w3.org/ns/xproc-error";
 declare namespace ext="http://xproc.net/xproc/ext";

 (: module imports :)
 import module namespace const = "http://xproc.net/xproc/const" at "const.xqm";


 (: determines xproc type of element:)
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
   else if($node/@type) then
     'declare-step'
   else if($const:comp-steps/xproc:element[@type=$name][@xproc:step eq "true"]) then
     'comp-step'
   else if($const:comp-steps/xproc:element[@type=$name]) then
     'comp'
   else
     'error'      (: throw err:XS0044 ?:)
 };

 (: sorts pipeline based on input port dependencies :)
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:pipeline-step-sort($unsorted as node()*, $sorted as node()) as node()*{
 (: --------------------------------------------------------------------------------------------------------- :)
    if (empty($unsorted)) then
        ($sorted)
    else
        let $allnodes := $unsorted [ every $id in p:input[@primary eq 'true'][@port eq 'source']/p:pipe/@step satisfies ($id = $sorted/@xproc-defaultname)]
    return
        if ($allnodes) then
          parse:pipeline-step-sort( $unsorted except $allnodes, ($sorted, $allnodes ))
        else
          ()
 };

 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:AST($pipeline as element(p:declare-step)){
 (: --------------------------------------------------------------------------------------------------------- :)

 (: generate ext:pre with all components :)
 (: resolve import or throw XD0002:)
 (: generate ext:xproc if p:declare-step/@type :)
 (: ensure ports refer to these default names :)
 (: sort :)
 (: generate ext:post :)
 $pipeline
};

 (: entry point for parse:explicit-name() :)
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:explicit-name($pipeline as element(p:declare-step)){
 (: --------------------------------------------------------------------------------------------------------- :)
  element p:declare-step {
    $pipeline/@*,
    attribute xproc:default-name {'!1'},
    parse:explicit-name($pipeline, '!1')
  }
 };

 (: applies default naming (ex. !1) to each xproc step :)
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:explicit-name($pipeline as node()*,$cname as xs:string) as node()*{
 (: --------------------------------------------------------------------------------------------------------- :)
 ( 
 for $step in $pipeline/*[@xproc:type eq 'comp']
 return
   element {node-name($step)} {
     $step/@*,
     $step/text(),
     parse:explicit-name($step, $cname)
   }
 ,
 for $step at $count in $pipeline/*[@xproc:step eq  'true']
 return
   element {node-name($step)} {
     $step/@*,
     attribute xproc:defaultname { fn:concat($cname,".",$count)},
     $step/text(),
     parse:explicit-name($step, fn:concat($cname,".",$count))
   },
 for $step at $count in $pipeline/*[fn:not(@xproc:step eq  'true')][fn:not(@xproc:type eq 'comp')]
 return
   element {node-name($step)} {
     $step/@*,
     $step/text(),
     parse:explicit-name($step,$cname)
   }
 )
};


 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:explicit-type($pipeline as node()*) as node()*{
 (: --------------------------------------------------------------------------------------------------------- :)
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