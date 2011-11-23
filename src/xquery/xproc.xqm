xquery version "3.0"  encoding "UTF-8";
(:
: Module Name: xproc
: Module Version: 1.0
: Date: Nov 20, 2011
: Copyright: James Fuller
: Proprietary
: Extensions: None
:
: Specification : XQuery v3.0
: Module Overview: core xqm contains entry points, primary eval-step function and control functions.
:)

module namespace xproc = "http://xproc.net/xproc";

 declare boundary-space preserve;

 (: declare namespaces :)
 declare namespace p="http://www.w3.org/ns/xproc";
 declare namespace c="http://www.w3.org/ns/xproc-step";
 declare namespace err="http://www.w3.org/ns/xproc-error";

 (: module imports :)
 import module namespace const = "http://xproc.net/xproc/const" at "const.xqm";
 import module namespace parse = "http://xproc.net/xproc/parse" at "parse.xqm";
 import module namespace     u = "http://xproc.net/xproc/util"  at "util.xqm";
 import module namespace   std = "http://xproc.net/xproc/std"   at "std.xqm";
 import module namespace   opt = "http://xproc.net/xproc/opt"   at "opt.xqm";
 import module namespace   ext = "http://xproc.net/xproc/ext"   at "ext.xqm";

 (: declare variables :)
 declare variable $xproc:eval-step       := xproc:evalstep#5;

 (: declare steps :)
 declare variable $xproc:run-step       := xproc:run#7;
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

 (: declare options :)
 declare option saxon:output "indent=yes";

 (: --------------------------------------------------------------------------- :)
 declare function xproc:resolve-external-bindings($a,$b) {
 (: -------------------------------------------------------------------------- :)
() 
 };

 (: --------------------------------------------------------------------------- :)
 declare function xproc:genstepnames($element) as xs:string* {
 (: -------------------------------------------------------------------------- :)
      for $name in  $element/*[@xproc:step eq "true"]
        return
          $name/@xproc:default-name
 
 };


 (: ------------------------------------------------------------------------------------------------------------- :)
 declare function xproc:generate_output($step,$port,$port-type,$primary,$content) as element(xproc:output){
 (: ------------------------------------------------------------------------------------------------------------- :)
 <xproc:output
  step="{$step}"
  port="{$port}"
  port-type="{$port-type}"
  primary="{$primary}"
  func="">{$content}</xproc:output>
 };


 (: -------------------------------------------------------------------------- :)
 declare function xproc:resolve-document-binding($href as xs:string){
 (: -------------------------------------------------------------------------- :)
    if (doc-available($href)) then
        doc($href)
    else
        u:dynamicError('err:XD0002',concat(" cannot access document ",$href))
 };


 (: -------------------------------------------------------------------------- :)
 declare function xproc:resolve-data-binding($href as xs:string,$wrapper as xs:string){
 (: -------------------------------------------------------------------------- :)
<c:data
  content-type =""
  charset = ""
  encoding = "">
    string
</c:data>
(:
    u:dynamicError('err:XD0002',concat("cannot access file:  ",$href))
:)
 };


 (: -------------------------------------------------------------------------- :)
 declare function xproc:resolve-port-binding($input,$result,$ast,$currentstep){
 (: -------------------------------------------------------------------------- :)
   typeswitch($input)
     case element(p:empty)
       return <empty/>
     case element(p:inline)
       return $input/node()
     case element(p:document)
       return xproc:resolve-document-binding($input/@href)
     case element(p:data)
       return xproc:resolve-data-binding($input/@href,'')
     case element(p:pipe)
       return $result[@xproc:default-name eq $input/@xproc:default-step-name][@port eq $input/@port]/node()
     default 
       return
         u:dynamicError('err:XD0001',concat("cannot bind to port: ",$input/@port," step: ",$input/@step,' ',u:serialize($currentstep,$const:TRACE_SERIALIZE)))
 };


 (: -------------------------------------------------------------------------- :)
 declare function xproc:eval-options($pipeline,$step){
 (: -------------------------------------------------------------------------- :)
     <xproc:options>
         {$pipeline/*[@xproc:default-name=$step]/p:with-option}
     </xproc:options>
 };


 (: -------------------------------------------------------------------------- :)
 declare function xproc:eval-outputs($pipeline,$step){
 (: -------------------------------------------------------------------------- :)
     <xproc:outputs>
         {$pipeline/*[@xproc:default-name=$step]/p:output}
     </xproc:outputs>
 };


 (: -------------------------------------------------------------------------- :)
 declare function xproc:eval-secondary($pipeline,$step,$currentstep,$primaryinput,$result){
 (: -------------------------------------------------------------------------- :)
     <xproc:inputs>{
         for $input in $currentstep/p:input[@primary eq 'false']
             return
             <xproc:input port="{$input/@port}" select="{$input/@select}">
             {
                 let $primaryresult := document{
                     for $child in $input/node()
                     return
                         xproc:resolve-port-binding($child,$result,$pipeline,$currentstep)
                        }

                 let $select := string(
                            if ($input/@select eq '/' or empty($input/@select) or $input/@select eq ' ') then
                                 '/'
                            else
                                 string($input/@select)
                             )

                 let $selectval := if ($select eq '/' or empty($select)) then
                                        $primaryresult
                                 else
                                        let $namespaces :=  xproc:enum-namespaces ($primaryresult)
                                            return
                                                u:evalXPATH(string($select),$primaryresult)
                    return
                         if (empty($selectval)) then

         (: TODO: investigate empty bindings :)
          u:dynamicError('err:XD0016',concat(string($pipeline/*[@name=$step]/p:input[@primary='true'][@select]/@select)," did not select anything at ",$step," ",name($pipeline/*[@name=$step])))
                         else
                             $selectval
             }
             </xproc:input>

     }</xproc:inputs>
 };


 (:~ evaluates primary input to a step
  :
  : a) checks to see if there are multiple children to p:input and uses xproc:resolve-port-binding to resolve them
  : b) applies xpath select processesing (if did not select anything this is an error)
  : c) 
  :
  :
  :
  : @param $ast - we require ast to refer to stuff
  : @param $step - 
  : @param $currentstep - actual current step
  : @param $primaryinput - primary input
  : @param $outputs - all of the previously processed steps outputs, including in scope variables and options
  :
  : @returns item()*
 :)
 (:---------------------------------------------------------------------------:)
 declare function xproc:eval-primary($ast as element(p:declare-step),$currentstep,$primaryinput as item()*,$outputs as item()*){
 (: -------------------------------------------------------------------------- :)
 let $step-name as xs:string := string(($currentstep/@name|$currentstep/@xproc:default-name)[1])
 let $pinput as element(p:input) := $currentstep/p:input[@primary eq 'true']
 let $data :=  if($pinput/node()) then
   (: resolve each nested port binding :)
   for $input in $pinput/*
   return
     xproc:resolve-port-binding($input,$outputs,$ast,$currentstep)
   else
     if(name($primaryinput) eq 'xproc:output') then $primaryinput/node() else $primaryinput
 let $result :=  u:evalXPATH(string($pinput/@select),$data)
 return
   if ($result) then
     $result
   else
     <empty/>
     (: TEMPORARILY DISABLED
     u:dynamicError('err:XD0016',concat("xproc step ",$step-name, "did not select anything from p:input")) :)
};


 (:~ evaluates an xproc step
  :
  : @param $step - step's xproc:default-name
  : @param $namespaces - namespaces in use 
  : @param $primaryinput - standard input into the step
  : @param $ast - full abstract syntax tree of the pipeline being processed
  : @param $outputs - all of the previously processed steps outputs, including in scope variables and options
  :
  : @returns item()*
 :)
 (: -------------------------------------------------------------------------- :)
 declare function xproc:evalstep ($step,$namespaces,$primaryinput,$ast,$outputs) {
 (: -------------------------------------------------------------------------- :)
     let $declarens :=  u:declare-ns($namespaces)
     let $variables :=  $outputs/xproc:variable
     let $currentstep := $ast/*[@xproc:default-name eq $step][1]
     let $stepfunc := name($currentstep)
     let $stepfunction := xproc:getstep($stepfunc)
     let $primary :=  xproc:eval-primary($ast,$currentstep,$primaryinput,$outputs)
     let $secondary := xproc:eval-secondary($ast,$step,$currentstep,$primaryinput,$outputs)

     let $options := xproc:eval-options($ast,$step)
     let $output := xproc:eval-outputs($ast,$step)

     let $log-href := $currentstep/p:log/@href
     let $log-port := $currentstep/p:log/@port

     return

         if(name($currentstep) = "p:declare-step") then
            (: TODO: refactor p:pipeline and p:declare-step :)
            ()
         else
           (
             (: primary input port :)
             <xproc:output step="{$step}"
             xproc:default-name="{$step}"
             port-type="input"
             href="{if ($log-port eq $currentstep/p:input[1][@primary='true']/@port) then $log-href else ()}"
             primary="true"
             select="{$currentstep/p:input[1][@primary='true']/@select}"
             port="{$currentstep/p:input[1][@primary='true']/@port}"
             func="{$stepfunc}">{$primary}</xproc:output>
             ,
             (: all other input ports :)
             (  for $child in $secondary/xproc:input
             return
             <xproc:output step="{$step}"
             xproc:default-name="{$step}"
             port-type="input"
             href="{if ($log-port eq $child/@port) then $log-href else ()}"
             primary="false"
             select="{$child/@select}"
             port="{$child/@port}"
             func="{$stepfunc}">{$child/node()}</xproc:output>
             )
             ,
             (: primary output port :)
             if($currentstep/p:output[@primary='true']) then
             <xproc:output step="{$step}"
             port-type="output"
             href="{if ($log-port eq $currentstep/p:output[1][@primary='true']/@port) then $log-href else ()}"
             primary="true"
             xproc:default-name="{$step}"
             select="{$currentstep/p:output[@primary='true']/@select}"
             port="{$currentstep/p:output[@primary='true']/@port}"
             func="{$stepfunc}">{$stepfunction($primary,$secondary,$options,$variables)}</xproc:output>
           else
             (: all other primary output ports @TODO - needs to be handled :)
             <xproc:output step="{$step}"
             port-type="output"
             href="{if ($log-port eq $currentstep/p:output[1][@primary='false']/@port) then $log-href else ()}"
             primary="false"
             xproc:default-name="{$step}"
             select="{$currentstep/p:output[@primary='false']/@select}"
             port="{$currentstep/p:output[@primary='false']/@port}"
             func="{$stepfunc}"/>
         )
 };


 (:~
  : lists all namespaces which are declared and in use within pipeline 
  : @TODO possibly move to util.xqm and delineate between declared and in use
  :
  : @param $pipeline - returns all in use namespaces

  : @returns <namespace/> element
  :)
 (: ------------------------------------------------------------------------------------------------------------- :)
 declare function xproc:enum-namespaces($pipeline) as element(namespace){
 (: ------------------------------------------------------------------------------------------------------------- :)
    <namespace name="{$pipeline/@name}">{u:enum-ns(<dummy>{$pipeline}</dummy>)}</namespace>
 };


 (:~
  : prepares the output from for xproc:stepFoldEngine
  :
  : This is a preprocess before serialization and actual output to standard output
  : or wherever externally from xprocxq
  :
  : @param $result - all outputs from the result of processing pipeline
  : @param $dflag - if true will output full processing trace
  :
  : @returns item()* 
  :)
 (: -------------------------------------------------------------------------- :)
 declare function xproc:output($result,$dflag as xs:integer) as item()*{
 (: -------------------------------------------------------------------------- :)
 let $pipeline :=subsequence($result,1,1)
 let $output := <xproc:outputs>{ subsequence($result,2) } </xproc:outputs>
 return
   if($dflag eq 1) then
   <xproc:debug
   xmlns:p="http://www.w3.org/ns/xproc"
   xmlns:ext="http://xproc.net/xproc/ext"
   xmlns:c="http://www.w3.org/ns/xproc-step"
   xmlns:err="http://www.w3.org/ns/xproc-error"
   xmlns:xxq-error="http://xproc.net/xproc/error"
   xmlns:opt="http://xproc.net/xproc/opt"
   >
     <xproc:pipeline>{$pipeline}</xproc:pipeline>
     {$output}
   </xproc:debug>
 else
   (: TODO - define default p:serialization options here:)
   subsequence($result,count($result) - 3,1)/node()
(:
   let $stdout := $output//*[@port eq 'stdout']/node()
   let $count := count ($result)
   return
     if (empty($stdout)) then
       subsequence($result,$count - 2,1)/node()
     else
       $stdout
:)
 };


 (:~
  : runtime processing wrapper for xproc:stepFoldEngine 
  : @TODO - may push this down back to xproc:run
  :
  : This level of abstraction is probably temporary
  :
  : @param $ast - abstract syntax tree representing pipeline
  : @param $evalstep - function for evaluating each step (allows for flexible processing)
  : @param $namespaces - all namespaces that are used within pipeline
  : @param $stdin - standard input into the pipeline
  : @param $bindings - declared port bindings
  : @param $outputs - starting outputs, used for ext:xproc and branching pipelines
  :
  : @returns 
  :)
 (: ------------------------------------------------------------------------------------------------------------- :)
 declare function xproc:evalAST($ast as element(p:declare-step),
   $evalstep,$namespaces as element(namespace),$stdin as item()* ,$bindings,$outputs as item()*) as item()* {
 (: ------------------------------------------------------------------------------------------------------------- :)

     let $steps := xproc:genstepnames($ast)
     let $pipeline-name := $ast/@xproc:default-name
     return
         xproc:stepFoldEngine($ast,
         $namespaces,
         $steps,
         $evalstep,
         $stdin,
         ($outputs,
         <xproc:variable/>, 
         xproc:resolve-external-bindings($bindings,$pipeline-name),
         xproc:generate_output($pipeline-name,'stdin','external','false',$stdin)
          )
         )
 };


 (:~
  : xproc pipeline is processed using a recursive step fold function
  : 
  :
  : This is the central mechanism by which xprocxq works. By using a step-fold
  : function we have a flexible method of working with xproc branches, ext:xproc
  : invokes, as well as opening up all sorts of possibilities to work Map/Reduce
  : style.
  :
  :
  : 
  :
  :
  :
  :
  :  
  : @param $ast - abstract syntax tree representing pipeline
  : @param $namespaces - all namespaces that are used within pipeline
  : @param $steps - 
  : @param $evalstep-function - 
  : @param $primary - starting input
  : @param $outputs - starting outputs, used for ext:xproc and branching pipelines
  :
  : @returns ($ast, $outputs)
  :)
 (: -------------------------------------------------------------------------- :)
 declare function xproc:stepFoldEngine( $ast as element(p:declare-step),
                              $namespaces as element(namespace),
                              $steps as xs:string*,
                              $evalstep-function,
                              $primary as node(),
                              $outputs as element()*  ) {
 (: -------------------------------------------------------------------------- :)

    if (empty($steps)) then
      ($ast,$outputs)                       
    else
      let $result :=  $evalstep-function(   
        $steps[1],
        $namespaces,
        $primary,
        $ast,
        $outputs)
        return
          xproc:stepFoldEngine($ast,                 
          $namespaces,         
          remove($steps, 1),
          $evalstep-function,
          $result[last()],
          ($outputs,$result))
};


 (:~
  : entry point into xprocxq returning the final serialized output of pipeline processing
  :
  : @param $pipeline - xproc pipeline
  : @param $stdin - externally defined standard input
  : @param $bindings - externally declared port bindings
  : @param $options - externally declared options
  : @param $outputs - externally declared output
  : @param $dflag - debug flag
  : @param $tflag - timing flag
  :
  : @returns item()*
  :)
 (: ------------------------------------------------------------------------------------------------------------- :)
 declare function xproc:run($pipeline,$stdin,$bindings,$options,$outputs,$dflag as xs:integer ,$tflag as xs:integer) as item()*{
 (: ------------------------------------------------------------------------------------------------------------- :)

 (:~ STEP I: preprocess :)
 let $validate   := () (: validation:jing($pipeline,fn:doc($const:xproc-rng-schema)) :)
 let $namespaces := xproc:enum-namespaces($pipeline)
 let $parse      := parse:explicit-bindings( parse:AST(parse:explicit-name(parse:explicit-type($pipeline))))
 let $ast        := element p:declare-step {$parse/@*,
   namespace p {"http://www.w3.org/ns/xproc"},
   namespace xproc {"http://xproc.net/xproc"},
   namespace ext {"http://xproc.net/xproc/ext"},
   namespace opt {"http://xproc.net/xproc/opt"},
   namespace c {"http://www.w3.org/ns/xproc-step"},
   namespace err {"http://www.w3.org/ns/xproc-error"},
   namespace xxq-error {"http://xproc.net/xproc/error"},
   parse:pipeline-step-sort( $parse/*, () )
 }

 let $checkAST   :=  u:assert(not(empty($ast)),"AST is empty")

 (:~ STEP II: eval AST :)
 let $eval_result := xproc:evalAST($ast,$xproc:eval-step,$namespaces,$stdin,$bindings,$outputs)

 (:~ STEP III: serialize and return results :)
 let $serialized_result := xproc:output($eval_result,$dflag)

 return 
   $serialized_result
 };




(:~ waiting for fn:function-lookup() 
 :
 : This is a temporary function as a dynamic function constructor
 : it eventually will be replaced by the new fn:function-lookup() 
 : function which will make its way into the final xquery/xpath 3.0
 : specs
 :
 : @param $stepname - string containing name of element
 :
 : @returns function
 :
 :)
(: -------------------------------------------------------------------------- :)
declare function xproc:getstep($stepname as xs:string){
(: -------------------------------------------------------------------------- :)
if ($stepname eq 'p:identity') then
  $std:identity
else if($stepname eq 'p:count') then
  $std:count
else if($stepname eq 'ext:pre') then
  $ext:pre
else if($stepname eq 'ext:post') then
  $ext:post
else
 $std:identity
};
