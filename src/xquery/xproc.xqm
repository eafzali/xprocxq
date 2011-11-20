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
 import module namespace u = "http://xproc.net/xproc/util" at "util.xqm";

 (: declare functions :)
 declare variable $xproc:run-step       := xproc:run#7;
 declare variable $xproc:eval-step       := xproc:evalstep#5;

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
 declare function xproc:resolve-external-bindings($bindings,$pipeline-name) {
 (: -------------------------------------------------------------------------- :)
 () 
 };


 (: --------------------------------------------------------------------------- :)
 declare function xproc:genstepnames($element) as xs:string* {
 (: -------------------------------------------------------------------------- :)
      for $name in  $element/*[@xproc:step eq "true"]
        return
          name($name)
 
 };


 (: ------------------------------------------------------------------------------------------------------------- :)
 declare function xproc:generate_output($step,$port,$port-type,$primary,$content) as element(xproc:output){
 (: ------------------------------------------------------------------------------------------------------------- :)
 <xproc:output
  step="{$step}"
  port="{$port}"
  port-type="{$port-type}"
  primary="{$primary}"
  func="example">{$content}</xproc:output>
 };


 (: -------------------------------------------------------------------------- :)
 declare function xproc:resolve-empty-binding(){
 (: -------------------------------------------------------------------------- :)
    ()
 };


 (: -------------------------------------------------------------------------- :)
 declare function xproc:resolve-inline-binding($child){
 (: -------------------------------------------------------------------------- :)
    $child/node()
 };


 (: -------------------------------------------------------------------------- :)
 declare function xproc:resolve-document-binding($child){
 (: -------------------------------------------------------------------------- :)
    if (doc-available(string($child/@href))) then
        doc(string($child/@href))
    else
        u:dynamicError('err:XD0002',concat(" cannot access document ",$child/@href))
 };


 (: -------------------------------------------------------------------------- :)
 declare function xproc:resolve-data-binding($child){
 (: -------------------------------------------------------------------------- :)
    if ($child/@href) then
    element {
    if ($child/@wrapper) then
        string($child/@wrapper)
    else
        'c:data'
    } {
    
        if ($child/@xproc:escape eq 'true') then
            attribute xproc:escape{'true'}
        else
            (),
        if (starts-with($child/@href,'file:')) then
              u:binary-doc($child/@href)
        else if (ends-with($child/@href,'.xml')) then
        let $result :=  doc($child/@href)
        let $namespaces := u:declare-ns(xproc:enum-namespaces($result))
        return
          $result
        
        else
	        u:binary-to-string(u:binary-doc($child/@href))


(:          u:unparsed-data($child/@href,'text/plain')
:)
    }
  else
     u:dynamicError('err:XD0002',concat("cannot access document:  ",$child/@href))
 };


 (: -------------------------------------------------------------------------- :)
 declare function xproc:resolve-stdin-binding($result,$current-step-name){
 (: -------------------------------------------------------------------------- :)
    $result/xproc:output[@port eq 'stdin'][@step eq $current-step-name]/node()
 };


 (: -------------------------------------------------------------------------- :)
 declare function xproc:resolve-primary-input-binding($result,$pipeline-name){
 (: -------------------------------------------------------------------------- :)
    $result/xproc:output[@step eq concat('!',$pipeline-name)][@port eq '' or @port eq 'result']/node()
 };


 (: -------------------------------------------------------------------------- :)
 declare function xproc:resolve-non-primary-input-binding($result,$child,$pipeline-name){
 (: -------------------------------------------------------------------------- :)
    $result/xproc:output[@port eq $child/@port][@step eq concat('!',$pipeline-name)]/node()
 };


 (: -------------------------------------------------------------------------- :)
 declare function xproc:resolve-pipe-binding($result,$child){
 (: -------------------------------------------------------------------------- :)

    if ($result/xproc:output[@port=$child/@port][@step eq $child/@step]) then
        $result/xproc:output[@port=$child/@port][@step eq $child/@step]/node()
    else if ($result/xproc:output[@port=$child/@port][@xproc:defaultname eq $child/@step]) then 
        $result/xproc:output[@port=$child/@port][@xproc:defaultname eq $child/@step]/node()
    else
        $result/xproc:output[last()]/node()
 };


 (: -------------------------------------------------------------------------- :)
 declare function xproc:resolve-port-binding($child,$result,$pipeline,$currentstep){
 (: -------------------------------------------------------------------------- :)
    if(name($child)='p:empty') then
          xproc:resolve-empty-binding()

     else if(name($child) eq 'p:inline') then
         xproc:resolve-inline-binding($child)

     else if(name($child)='p:document') then
         xproc:resolve-document-binding($child)

     else if(name($child)='p:data') then
         xproc:resolve-data-binding($child)

     else if ($child/@port eq 'stdin' and $child/@step eq $pipeline/@name) then
         xproc:resolve-stdin-binding($result,$currentstep/@name)

     else if ($child/@primary eq 'true' and $child/@step eq $pipeline/@name) then
        xproc:resolve-primary-input-binding($result,$pipeline/@name)

     else if ($child/@step eq $pipeline/@name) then
        xproc:resolve-non-primary-input-binding($result,$child,$pipeline/@name)

     else if ($child/@port and $child/@step) then
        xproc:resolve-pipe-binding($result,$child)

    else
        u:dynamicError('err:XD0001',concat(" cannot bind to port: ",$child/@port," step: ",$child/@step,' ',u:serialize($currentstep,$const:TRACE_SERIALIZE)))

 };


 (: -------------------------------------------------------------------------- :)
 declare function xproc:eval-options($pipeline,$step){
 (: -------------------------------------------------------------------------- :)
     <xproc:options>
         {$pipeline/*[@name=$step]/p:with-option}
     </xproc:options>
 };


 (: -------------------------------------------------------------------------- :)
 declare function xproc:eval-outputs($pipeline,$step){
 (: -------------------------------------------------------------------------- :)
     <xproc:outputs>
         {$pipeline/*[@name=$step]/p:output}
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


 (:---------------------------------------------------------------------------:)
 declare function xproc:eval-primary($pipeline,$step,$currentstep,$primaryinput,$result){
 (: -------------------------------------------------------------------------- :)
 let $primaryresult := document{
     if($currentstep/p:input[@primary eq 'true']/node()) then
        (: resolve each nested port binding :)
         for $child in $currentstep/p:input[@primary eq 'true']/node()
             return
                xproc:resolve-port-binding($child,$result,$pipeline,$currentstep)
     else
            $primaryinput/node() (: prev step is an atomic step output:)
     }

    let $select := string($currentstep/p:input[@primary='true']/@select)
    let $selectval := if ($select eq '/' or $select eq '') then
                        $primaryresult
                     else
                        u:evalXPATH(string($select),$primaryresult)
        return

             if (empty($selectval)) then
                u:dynamicError('err:XD0016',concat(string($pipeline/*[@name=$step]/p:input[@primary='true'][@select]/@select)," did not select anything at ",$step," ",name($pipeline/*[@name=$step])))
             else
                 $selectval
 };

 (: -------------------------------------------------------------------------- :)
 declare function xproc:evalstep ($step,$namespaces,$primaryinput,$pipeline,$outputs) {
 (: -------------------------------------------------------------------------- :)
     let $outputs := document{$outputs}
     let $variables :=  $outputs//xproc:variable
     let $declarens :=  u:declare-ns($namespaces)
     let $currentstep := $pipeline/*[@name=$step][1]
     let $stepfuncname := $currentstep/@xproc:step
     let $stepfunc := concat($const:default-imports,$stepfuncname)
     let $primary := xproc:eval-primary($pipeline,$step,$currentstep,$primaryinput,$outputs)
     let $secondary := xproc:eval-secondary($pipeline,$step,$currentstep,$primaryinput,$outputs)

     let $options := xproc:eval-options($pipeline,$step)
     let $output := xproc:eval-outputs($pipeline,$step)

     let $log-href := $currentstep/p:log/@href
     let $log-port := $currentstep/p:log/@port

     return

         if(name($currentstep) = "p:declare-step") then
            (: TODO: refactor p:pipeline and p:declare-step :)
             ()
         else
            let $primaryinput:= <xproc:output step="{$step}"
                           port-type="input"
                           primary="true"
                           select="{$currentstep/p:input[1][@primary='true']/@select}"
                           port="{$currentstep/p:input[1][@primary='true']/@port}"
                           func="{$stepfuncname}">{
                                      $primary/node()
                          }
                     </xproc:output>
            let $secondaryinput := (  for $child in $secondary/xproc:input
                 return
                     <xproc:output step="{$step}"
                           port-type="input"
                           primary="false"
                           select="{$child/@select}"
                           port="{$child/@port}"
                           func="{$stepfuncname}">{
                             $child/node()
                           }
                     </xproc:output>
                    )
            return
                ($primaryinput,
                $secondaryinput,
                if($currentstep/p:output[@primary='true']) then
                      <xproc:output step="{$step}"
                                       port-type="output"
                                       primary="true"
                                       xproc:defaultname="{$currentstep/@xproc:defaultname}"
                                       select="{$currentstep/p:output[@primary='true']/@select}"
                                       port="{$currentstep/p:output[@primary='true']/@port}"
                                       func="{$stepfuncname}">
                                       
                      </xproc:output>
                else
                      <xproc:output step="{$step}"
                                       port-type="output"
                                       primary="false"
                                       xproc:defaultname="{$currentstep/@xproc:defaultname}"
                                       select="{$currentstep/p:output[@primary='false']/@select}"
                                       port="{if (empty($currentstep/p:output[@primary='false']/@port)) then 'result' else $currentstep/p:output[@primary='false']/@port}"
                                       func="{$stepfuncname}">
                                       
                                       
                      </xproc:output>
             )

 };


 (:~
  : lists all namespaces in use within pipeline
  : @returns <namespace/> element
  :)
 (: ------------------------------------------------------------------------------------------------------------- :)
 declare function xproc:enum-namespaces($pipeline) as element(namespace){
 (: ------------------------------------------------------------------------------------------------------------- :)
    <namespace name="{$pipeline/@name}">{u:enum-ns(<dummy>{$pipeline}</dummy>)}</namespace>
 };

 (: -------------------------------------------------------------------------- :)
 declare function xproc:output($result,$dflag){
 (: -------------------------------------------------------------------------- :)
 let $pipeline :=subsequence($result,1,1)
 let $output := <xproc:outputs>{ subsequence($result,2) } </xproc:outputs>
     return
         if($dflag eq "1") then
             <xproc:debug>
                 <xproc:pipeline>{$pipeline}</xproc:pipeline>
                {$output}
             </xproc:debug>
         else
            (: TODO - define default p:serialization options here:)
            let $stdout := $output//*[@port eq 'stdout']/node()
            let $count := count ($result)
         return
               if (empty($stdout)) then
                subsequence($result,$count - 2,1)/node()
               else
                  $stdout
 };

 (: ------------------------------------------------------------------------------------------------------------- :)
 declare function xproc:evalAST($ast,$namespaces,$stdin,$bindings,$outputs) {
 (: ------------------------------------------------------------------------------------------------------------- :)

     let $steps := xproc:genstepnames($ast/*)
     let $pipeline-name := $ast/@name  
     return
         u:step-fold($ast,
         $namespaces,
         $steps,
         xproc:evalstep#5,
         $stdin,
          ($outputs,
          <xproc:variable/>, 
          xproc:resolve-external-bindings($bindings,$pipeline-name),
          xproc:generate_output(concat('!',$pipeline-name),'stdin','external','false',$stdin)
          )
         )
 };


 (:~
  : entry point into xprocxq
  : @returns resultant xml
  :)
 (: ------------------------------------------------------------------------------------------------------------- :)
 declare function xproc:run($pipeline,$stdin,$dflag,$tflag,$bindings,$options,$outputs){
 (: ------------------------------------------------------------------------------------------------------------- :)

 (:~ STEP I: preprocess :)
 let $validate   := () (: validation:jing($pipeline,fn:doc($const:xproc-rng-schema)) :)
 let $namespaces := xproc:enum-namespaces($pipeline)
 let $parse      := parse:explicit-bindings( parse:AST(parse:explicit-name(parse:explicit-type($pipeline))))
 let $ast        := element p:declare-step {$parse/@*,
   namespace xproc {"http://xproc.net/xproc"},
   namespace ext {"http://xproc.net/xproc/ext"},
   namespace c {"http://www.w3.org/ns/xproc-step"},
   namespace err {"http://www.w3.org/ns/xproc-error"},
   namespace xxq-error {"http://xproc.net/xproc/error"},
   parse:pipeline-step-sort( $parse/*, () )
 }

 (:~ STEP II: eval AST :)
 let $eval_result := xproc:evalAST($ast,$namespaces,$stdin,$bindings,$outputs)

 (:~ STEP III: serialize and return results :)
 let $serialized_result := xproc:output($eval_result,"1")

 return 
   $serialized_result
 };

