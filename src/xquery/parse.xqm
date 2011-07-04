(: -------------------------------------------------------------------------------------

    parse.xqm - 

 ---------------------------------------------------------------------------------------- :)
xquery version "3.0"  encoding "UTF-8";

module namespace parse = "http://xproc.net/xproc/parse";

declare boundary-space preserve;

 (: declare namespaces :)
 declare namespace xproc="http://xproc.net/xproc";
 declare namespace p="http://www.w3.org/ns/xproc";
 declare namespace c="http://www.w3.org/ns/xproc-step";
 declare namespace err="http://www.w3.org/ns/xproc-error";
 declare namespace ext="http://xproc.net/xproc/ext";

 (: module imports :)
 import module namespace const = "http://xproc.net/xproc/const" at "const.xqm";


 (: returns step definition :)
 (: -------------------------------------------------------------------------- :)
 declare function parse:get-step($node){
 (: -------------------------------------------------------------------------- :)
 let $name := name($node)
 return
   ($const:std-steps/p:declare-step[@type=$name][@xproc:support eq 'true']   
   ,$const:opt-steps/p:declare-step[@type=$name][@xproc:support eq 'true']
   ,$const:ext-steps/p:declare-step[@type=$name][@xproc:support eq 'true']
   ,$const:comp-steps/xproc:element[@type=$name][@xproc:support eq 'true'][@xproc:step eq "true"])[1]
   (: throw err:XS0044 ?:)
 };


 (: determines xproc type of element:)
 (: -------------------------------------------------------------------------- :)
 declare function parse:type($node) as xs:string{
 (: -------------------------------------------------------------------------- :)
 let $name := name($node)
 return
   if ($const:std-steps/p:declare-step[@type=$name][@xproc:support eq 'true']) then
     'std-step'
   else if($const:opt-steps/p:declare-step[@type=$name][@xproc:support eq 'true']) then
     'opt-step'
   else if($const:ext-steps/p:declare-step[@type=$name][@xproc:support eq 'true']) then
     'ext-step'
   else if($node/@type) then
     'declare-step'
   else if($const:comp-steps/xproc:element[@type=$name][@xproc:support eq 'true'][@xproc:step eq "true"]) then
     'comp-step'
   else if($const:comp-steps/xproc:element[@type=$name][@xproc:support eq 'true']) then
     'comp'
   else
     'error'      (: check if unknown p: element else throw error XS0044:)
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

 (: entry point for parse:explicit-bindings:)
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:explicit-bindings($pipeline){
 (: --------------------------------------------------------------------------------------------------------- :)
 element p:declare-step {$pipeline/@*,
   parse:explicit-bindings($pipeline/*,'!1')
 }
 };

 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:explicit-bindings($steps,$unique_id){
 (: --------------------------------------------------------------------------------------------------------- :)
  for $node at $count in $steps
  let $unique_before  := fn:concat($unique_id,'.',$count - 2)
  let $unique_current := fn:concat($unique_id,'.',$count)
  let $unique_after   := fn:concat($unique_id,'.',$count + 2)
  return   
    if(fn:contains($node/@xproc:type,'step')) then
      element {node-name($node)} {$node/@*,
       for $input in $node/p:input
         return
           if ($input/*) then
             $input
           else
             element p:input {$input/@*,
             <p:pipe step="{$unique_before}" port="result"/>
             }
       ,$node/*[name(.) ne 'p:input']
      }
    else
      $node
};

 (: parse input bindings:)  
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:input-port($node as element(p:input)*, $step-definition){
 (: --------------------------------------------------------------------------------------------------------- :)
  for $input in $step-definition//p:input
  let $s := $node//*[@port eq $input/@port]
  return 
    element p:input {
        $input/@*[name(.) ne 'select'],
        ($s/@select, $input/@select)[1],
        $s/*
    }
};

 (: parse output bindings:)  
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:output-port($node as element(p:output)*, $step-definition){
 (: --------------------------------------------------------------------------------------------------------- :)
  for $output in $step-definition//p:output
  let $s := $node[@port eq $output/@port]
  return
    if ($output/@required eq 'true' and fn:empty($s)) then
       fn:error(xs:QName('err:XS0027'),'output required')   (: error XS0027:)
    else
      element p:outport {
        $output/@*[name(.) ne 'select'],
        ($s/@select,  $output/@select)[1],
        $s/*
      }
 };

 (: parse options :)  
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:options($node as element(p:with-option)*, $step-definition){
 (: --------------------------------------------------------------------------------------------------------- :)
 for $option in $step-definition//p:option
 let $name as xs:string := fn:string($option/@name)
 let $defined-option := $node[@name eq $name]
 return
   if ($defined-option) then
     element p:with-option {
       ($defined-option/@name)[1],
       ($defined-option/@select)[1]
     }
   else
     element p:with-option {
       ($option/@name)[1],
       ($option/@select)[1]
     }
 };

 (: parse options :)  
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:bindings($step as node()*, $step-definition){
 (: --------------------------------------------------------------------------------------------------------- :)
  (
    parse:input-port($step//p:input, $step-definition),
    parse:output-port($step//p:output, $step-definition),
    parse:options($step//p:with-option,$step-definition) 
  )
 };

 (: generate abstract syntax tree :)
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:AST($pipeline as node()*){
 (: --------------------------------------------------------------------------------------------------------- :)
 (: generate ext:post :)
 (: sort :)
 (: make fully explicit all port names :)
 (: resolve imports or throw XD0002:)
 (: generate ext:xproc if p:declare-step/@type :)
    for $node in $pipeline
    let $type := parse:type($node)
    let $step-definition := parse:get-step($node)
    return 
        typeswitch($node)
            case text()
                   return $node
            case element(p:declare-step) 
                   return element p:declare-step {
                     $node/@name,
                     $node/@xproc:step,
                     $node/@xproc:type,
                     element ext:pre {attribute xproc:default-name {fn:concat($node/@xproc:default-name,'.0')},
                     parse:bindings($node[@xproc:type eq 'comp'],$step-definition)},
                     parse:AST($node/*[@xproc:type ne 'comp'])}
                   default 
                   return element {node-name($node)}{
                     $node/@name,
                     $node/@xproc:step,
                     $node/@xproc:type,
                     attribute default-element {'test'},
                     parse:bindings($node/*[@xproc:type eq 'comp'],$step-definition),
                     parse:AST($node/*[@xproc:type ne 'comp'])}
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

 (: applies default naming (ex. !1) to all step elements :)
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
   },
 for $step at $count in $pipeline/*[@xproc:step eq  'true']
 return
   element {node-name($step)} {
     $step/@*,
     attribute xproc:default-name { fn:concat($cname,".",$count)},
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


 (: add namespace declarations and explicitly type each step :)
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
                     namespace xproc {"http://xproc.net/xproc"},
                     namespace ext {"http://xproc.net/xproc/ext"},
                     namespace c {"http://www.w3.org/ns/xproc-step"},
                     namespace err {"http://www.w3.org/ns/xproc-error"},
                     namespace xxq-error {"http://xproc.net/xproc/error"},
                     attribute xproc:type {$type}, 
                     parse:explicit-type($node/node())}
            case element(p:declare-step) 
                   return element p:declare-step {$node/@*,
                     namespace xproc {"http://xproc.net/xproc"},
                     namespace ext {"http://xproc.net/xproc/ext"},
                     namespace c {"http://www.w3.org/ns/xproc-step"},
                     namespace err {"http://www.w3.org/ns/xproc-error"},
                     namespace xxq-error {"http://xproc.net/xproc/error"},
                     attribute xproc:type {$type}, 
                     parse:explicit-type($node/node())}
            case element()
                   return element {node-name($node)} {
                     $node/@*,                                      (: TODO - this will need to constrain at some point :)
                     if (fn:contains($type,'step')) then attribute xproc:step {fn:true()} else (),
                     if ($type ne 'error') then attribute xproc:type {$type} else (),
                     if (fn:contains($type,'step')) then
                       for $option in $node/@*[name(.) ne 'name']   (: normalize all step attribute options to be represented as p:with-option elements :)
                       return
                         element p:with-option {
                           attribute name {name($option)},
                           attribute select {data($option)}
                         }
                       else
                         ()
                         ,
                         parse:explicit-type($node/node())} 
            default 
                   return parse:explicit-type($node/node())
 };
