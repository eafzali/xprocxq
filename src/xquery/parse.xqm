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
 declare function parse:pipeline-step-sort($unsorted, $sorted) as node()*{
 (: --------------------------------------------------------------------------------------------------------- :)
    if (empty($unsorted)) then
       ($sorted,                
       <ext:post xproc:default-name="{$sorted[1]/@xproc:default-name}!">
         <p:input port="source" primary="true"/>
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

 (: entry point for parse:explicit-bindings:)
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:explicit-bindings($pipeline){
 (: --------------------------------------------------------------------------------------------------------- :)
 element p:declare-step {$pipeline/@*,
   parse:explicit-bindings($pipeline,'!1')
 }
 };

 (: make all p:input and p:output ports explicit :)
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:explicit-bindings($pipeline,$unique_id){
 (: --------------------------------------------------------------------------------------------------------- :)
  for $node at $count in $pipeline/*
  let $unique_before  := fn:concat($unique_id,'.',$count - 2)
  let $unique_current := fn:concat($unique_id,'.',$count)
  let $unique_after   := fn:concat($unique_id,'.',$count + 2)
  return   
    if(fn:contains($node/@xproc:type,'step')) then
      element {node-name($node)} {$node/@*,
       for $input in $node/p:input
         return
           element p:input {$input/@*,
           if ($input/p:pipe) then
               element p:pipe {
                 $input/p:pipe/@port,
                 $input/p:pipe/@step,
                 attribute xproc:default-step-name {($pipeline[@name eq $input/p:pipe/@step]/@xproc:default-name,$pipeline//*[@name eq $input/p:pipe/@step]/@xproc:default-name)[1]}
                 }
           else if ($input/p:inline) then
             $input/*
           else
               element p:pipe {
                 attribute port {"result"},
                 attribute step {$unique_before},
                 attribute xproc:default-step-name {$unique_before}
               }
               ,$node/*[name(.) ne 'p:input']
           }
     }
    else
      $node
};

 (: parse input bindings:)  
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:input-port($node as element(p:input)*, $step-definition){
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

 (: parse output bindings:)  
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:output-port($node as element(p:output)*, $step-definition){
 (: --------------------------------------------------------------------------------------------------------- :)
  for $output in $step-definition/p:output
  let $name as xs:string := fn:string($output/@port)  
  let $s := $node[@port eq $name]
  return
    if ($output/@required eq 'true' and fn:empty($s)) then
       fn:error(xs:QName('err:XS0027'),'output required')   (: error XS0027:)
    else
      element p:outport {
        attribute xproc:type {'comp'},
        $output/@*[name(.) ne 'select'],
        ($s/@select,  $output/@select)[1],
        $s/*
      }
 };

 (: parse options :)  
 (: --------------------------------------------------------------------------------------------------------- :)
 declare function parse:options($node as element(p:with-option)*, $step-definition){
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
     }
   else
     element p:with-option {
       attribute xproc:type {'comp'},
       ($option/@name)[1],
       ($option/@select)[1]
     }
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
                     $node/@*,
                     element ext:pre {attribute xproc:default-name {fn:concat($node/@xproc:default-name,'.0')},
                       parse:input-port($node/p:input, $step-definition),
                       parse:output-port($node/p:output, $step-definition),
                       parse:options($node/p:with-option,$step-definition) 
                     },
                     parse:AST($node/*[@xproc:type ne 'comp'])
                   }
            default 
                   return element {node-name($node)}{
                     $node/@*,
                     parse:input-port($node/p:input, $step-definition),
                     parse:output-port($node/p:output, $step-definition),
                     parse:options($node/p:with-option,$step-definition), 
                     parse:AST($node/*[@xproc:type ne 'comp'])
                   }
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
            case element(p:documentation)
                   return $node
            case element(p:inline)
                   return $node
            case element(p:pipeinfo)
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
