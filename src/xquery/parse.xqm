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
 declare namespace opt="http://xproc.net/xproc/opt";

 (: module imports :)
 import module namespace const = "http://xproc.net/xproc/const" at "const.xqm";


 (:~
  : looks up std, ext, and opt step definition 
  :
  : @returns step signature
  :)
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


 (:~
  : determines type of xproc element<br/>
  :
  : std-step: standard xproc step<br/>
  : opt-step: optional xproc step<br/>
  : ext-step: xprocxq proprietary extension step<br/>
  : declare-step: an author defined step<br/>
  : comp-step: p:choose, p:viewport, etc<br/>
  : comp: component (ex. p:input)<br/>
  : error: means that the element has not been identified<br/>
  : <br/>
  : @returns 'std-step|opt-step|ext-step|declare-step|comp-step|comp|error(unknown type)'
  :)
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


 (:~
  : sorts pipeline based on input port dependencies<br/>
  :
  : @returns node()*
  :)
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:pipeline-step-sort($unsorted, $sorted) as node()*{
 (: --------------------------------------------------------------------------------------------------------- :)
    if (empty($unsorted)) then
       ($sorted,                
       <ext:post xproc:step="true" xproc:default-name="{$sorted[1]/@xproc:default-name}!">
         <p:input port="source" primary="true">
         (: need to pipe in last step or override from top level p:output :)
         </p:input>
         <p:output primary="true" port="stdout" select="/"/>
       </ext:post>)
    else
        let $allnodes := $unsorted [ every $id in p:input[@primary eq 'true'][@port eq 'source']/p:pipe/@xproc:default-step-name satisfies ($id = $sorted/@xproc:default-name)]
    return
        if ($allnodes) then
          parse:pipeline-step-sort( $unsorted except $allnodes, ($sorted, $allnodes ))
        else
          ()
 };

 (:~
  : entry point for parse:explicit-bindings
  :
  : @returns element(p:declare-step)
  :)
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:explicit-bindings($pipeline) as element(p:declare-step){
 (: --------------------------------------------------------------------------------------------------------- :)
 element p:declare-step {$pipeline/@*,
    namespace xproc {"http://xproc.net/xproc"},
    namespace ext {"http://xproc.net/xproc/ext"},
    namespace c {"http://www.w3.org/ns/xproc-step"},
    namespace err {"http://www.w3.org/ns/xproc-error"},
    namespace xxq-error {"http://xproc.net/xproc/error"},
   parse:explicit-bindings($pipeline/*,'!1')
 }
 };

 (:~
  : make all p:input and p:output ports explicit
  :
  : @returns element()*
  :)
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:explicit-bindings($pipeline,$unique_id){
 (: --------------------------------------------------------------------------------------------------------- :)
  for $node at $count in $pipeline
  let $unique_before  := fn:concat($unique_id,'.',$count - 2)
  let $unique_current := fn:concat($unique_id,'.',$count)
  let $unique_after   := fn:concat($unique_id,'.',$count + 2)
  return   
    if(fn:contains($node/@xproc:type,'step')) then

      element {node-name($node)} {$node/@*,
       for $input in $node//p:input
         return
          element p:input {$input/@*,
          namespace xproc {"http://xproc.net/xproc"},
          namespace ext {"http://xproc.net/xproc/ext"},
          namespace c {"http://www.w3.org/ns/xproc-step"},
          namespace err {"http://www.w3.org/ns/xproc-error"},
          namespace xxq-error {"http://xproc.net/xproc/error"},

           if ($input//p:pipe) then
               element p:pipe {
                 $input/p:pipe/@port,
                 $input/p:pipe/@step,
                 attribute xproc:default-step-name {($pipeline[@name eq $input/p:pipe/@step]/@xproc:default-name,$pipeline//*[@name eq $input/p:pipe/@step]/@xproc:default-name)[1]}
                 }
           else if ($input/(p:inline|p:empty|p:data|p:document)) then
             $input/*
           else
               element p:pipe {
                 attribute port {"result"},
                 attribute step {$unique_before},
                 attribute xproc:default-step-name {$unique_before}
               }
           }
           ,parse:explicit-bindings($node/*[name(.) ne 'p:input'],$unique_current) 
     }
   else
     $node
};

 (:~
  : parse input bindings
  :
  : @returns element(p:input)
  :)
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:input-port($node as element(p:input)*, $step-definition) as element(p:input)*{
 (: --------------------------------------------------------------------------------------------------------- :)
  for $input in $step-definition/p:input
  let $name as xs:string := fn:string($input/@port)  
  let $s := $node[@port eq $name]
  return 
    element p:input {
      attribute xproc:type {'comp'},
      $input/@*[name(.) ne 'select'],
      ($s/@select, $input/@select)[1],
      $s/*
    }
};


 (:~
  : parse output bindings
  :
  : @returns element(p:output)
  :) 
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:output-port($node as element(p:output)*, $step-definition) as element(p:output)*{
 (: --------------------------------------------------------------------------------------------------------- :)
  for $output in $step-definition/p:output
  let $name as xs:string := fn:string($output/@port)  
  let $s := $node[@port eq $name]
  return
    if ($output/@required eq 'true' and fn:empty($s)) then
       fn:error(xs:QName('err:XS0027'),'output required')   (: error XS0027:)
    else
      element p:output {
        attribute xproc:type {'comp'},
        $output/@*[name(.) ne 'select'],
        ($s/@select,  $output/@select)[1],
        $s/*
      }
 };


 (:~
  : parse a steps options, converting all options to a nested p:with-option element
  :
  : @returns element(p:with-option)
  :)
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:options($node as element(p:with-option)*, $step-definition) as element(p:with-option)*{
 (: --------------------------------------------------------------------------------------------------------- :)
 for $option in $step-definition/p:option
 let $name as xs:string := fn:string($option/@name)
 let $defined-option := $node[@name eq $name]
 return
   if ($defined-option) then
     element p:with-option {
       attribute xproc:type {'comp'},
       ($defined-option/@name)[1],
       ($defined-option/@select)[1]

(:
       attribute select {concat("'",$defined-option/@select,"'")}
:)
     }
   else
     element p:with-option {
       attribute xproc:type {'comp'},
       ($option/@name)[1], 
       ($option/@select)[1]
     }
 };


 (:~
  : generate abstract syntax tree
  :
  : generate ext:post
  : make fully explicit all port names 
  : resolve imports or throw XD0002
  : generate ext:xproc if p:declare-step/@type 
  :
  :
  :
  :
  : @returns
  :)
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:AST($pipeline as node()*){
 (: --------------------------------------------------------------------------------------------------------- :)
    for $node in $pipeline
    let $type := parse:type($node)
    let $step-definition := parse:get-step($node)
    return
        typeswitch($node)
            case text()
                   return $node/text()
            case element(p:declare-step)
                   return element p:declare-step {
                     namespace xproc {"http://xproc.net/xproc"},
                     namespace ext {"http://xproc.net/xproc/ext"},
                     namespace c {"http://www.w3.org/ns/xproc-step"},
                     namespace err {"http://www.w3.org/ns/xproc-error"},
                     namespace xxq-error {"http://xproc.net/xproc/error"},
                     $node/@*,
                     element ext:pre {attribute xproc:default-name {fn:concat($node/@xproc:default-name,'.0')},
                       attribute xproc:step {"true"},
                       parse:input-port($node/p:input, $step-definition),
                       parse:output-port($node/p:output, $step-definition),
                       parse:options($node/p:with-option,$step-definition)
                     },
                     parse:AST($node/*[@xproc:type ne 'comp'])
                   }

           case element()
                   return element {node-name($node)}{
                     $node/@*,
                     $node/p:log,
                     parse:input-port($node/p:input, $step-definition),
                     parse:output-port($node/p:output, $step-definition),
                     parse:options($node/p:with-option,$step-definition),
                     parse:AST($node/*[@xproc:type ne 'comp'])
                   }
            default
            return ()
 };


 (:~
  : entry point for parse:explicit-name
  :
  : @returns 
  :)
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:explicit-name($pipeline as element(p:declare-step)){
 (: --------------------------------------------------------------------------------------------------------- :)
 element p:declare-step {
    $pipeline/@*,
    namespace xproc {"http://xproc.net/xproc"},
    namespace ext {"http://xproc.net/xproc/ext"},
    namespace c {"http://www.w3.org/ns/xproc-step"},
    namespace err {"http://www.w3.org/ns/xproc-error"},
    namespace xxq-error {"http://xproc.net/xproc/error"},
    attribute xproc:default-name {'!1'},
    $pipeline/*[not(@xproc:step)],
    parse:explicit-name($pipeline/*[@xproc:step eq "true"], '!1')
  }
 };

 (:~
  : inject xproc:default-name attribute to all step elements
  :
  : @returns node()*
  :)
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:explicit-name($pipeline as node()*,$cname as xs:string) as node()*{
 (: --------------------------------------------------------------------------------------------------------- :) 
 for $node at $count in $pipeline
 let $name := if($node/@xproc:step eq 'true') then fn:concat($cname,".",$count) else $cname
 return
   typeswitch($node)
     case text()
         return $node/text()
     case element(p:documentation)
         return element p:documentation {
           $node/@*,
           $node/node()
         }
     case element()
         return element {node-name($node)} {
           $node/@*,
           if($node/@xproc:step eq 'true') then
             attribute xproc:default-name {$name}
           else
             (),
(:             $node[not(p:*)]/*, :)
$node/text(),
             parse:explicit-name($node/*,if($node/@xproc:step eq 'true') then $name else $cname)
         }
     default
        return ()
};


 (:~
  : add namespace declarations and explicitly type each step
  :
  : @returns node()*
  :)
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:explicit-type($pipeline as node()*) as node()*{
 (: --------------------------------------------------------------------------------------------------------- :)
    for $node at $count in $pipeline
    let $type := parse:type($node)
    return 
        typeswitch($node)
            case text()
                   return $node/text()
            case element(p:documentation)
                   return element p:documentation {
                     attribute xproc:type {'comp'}, 
                     $node/node()
                     }
            case element(p:inline)
                   return element p:inline {
                     attribute xproc:type {'comp'}, 
                     $node/node()
                     }
            case element(p:pipeinfo)
                   return $node
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
                     $node/@*,
                     if (fn:contains($type,'step')) then attribute xproc:step {fn:true()} else (),
                     attribute xproc:type {$type},
                     if (fn:contains($type,'step')) then
                       for $option in $node/@*[name(.) ne 'name']      (: normalize all step attribute options to be represented as p:with-option elements :)
                       return
                         element p:with-option {
                           attribute xproc:type {'comp'},
                           attribute name {name($option)},
                           attribute select {data($option)}
                         }
                       else
                         ()
                         ,
                         parse:explicit-type($node/node())} 
            case element(p:when)
                   return element p:when {$node/@*,
                     attribute xproc:type {$type}, 
                     parse:explicit-type($node/node())}                 
            default 
                   return parse:explicit-type($node/node())
 };
