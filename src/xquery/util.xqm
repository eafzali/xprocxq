(: ------------------------------------------------------------------------------------- 
 
	util.xqm - contains most of the XQuery processor specific functions, including all
	helper functions.
	
---------------------------------------------------------------------------------------- :)
xquery version "3.0" encoding "UTF-8";

module namespace u = "http://xproc.net/xproc/util";

(: declare namespaces :)
declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";
declare namespace xsl="http://www.w3.org/1999/XSL/Transform";
declare namespace xproc = "http://xproc.net/xproc";
declare namespace std = "http://xproc.net/xproc/std";
declare namespace opt = "http://xproc.net/xproc/opt";
declare namespace ext = "http://xproc.net/xproc/ext";
declare namespace xxq-error = "http://xproc.net/xproc/error";


(: Module Imports :)
import module namespace const = "http://xproc.net/xproc/const" at "const.xqm";


(: set to 1 to enable debugging :)
declare variable $u:NDEBUG :=$const:NDEBUG;


(: -------------------------------------------------------------------------- :)
(: Processor Specific                                                         :)
(: -------------------------------------------------------------------------- :)

declare function u:strip-whitespace($xml){
let $template := <xsl:stylesheet version="2.0">
<xsl:strip-space elements="*"/> 
<xsl:template match=".">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="@*|node()">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>
</xsl:stylesheet>
return
  u:transform($template,$xml)
};


(: -------------------------------------------------------------------------- :)
declare function u:store($href as xs:string,$data as item()){
(: -------------------------------------------------------------------------- :)
let $result := saxon:result-document($href, $data, <xsl:output method="xml"/>)
return
  $href
};

(: -------------------------------------------------------------------------- :)
declare function u:parse($data as xs:string) as item(){
(: -------------------------------------------------------------------------- :)
saxon:parse($data) 
};


(: -------------------------------------------------------------------------- :)
declare function u:serialize($xml) as xs:string{
(: -------------------------------------------------------------------------- :)
saxon:serialize($xml, <xsl:output method="xml" 
                             omit-xml-declaration="yes" 
                             indent="yes" 
                             saxon:indent-spaces="1"/>) 
};


(: -------------------------------------------------------------------------- :)
declare function u:dirlist($path){
(: -------------------------------------------------------------------------- :)
collection(concat($path,"?select=*.*;recurse=yes;on-error=ignore"))
};

(: -------------------------------------------------------------------------- :)
declare function u:result-document($href as xs:string, $doc as item()){
(: -------------------------------------------------------------------------- :)
let $writelog :=  saxon:result-document($href, $doc, <xsl:output method="xml" indent="yes"/>)
return
  $href
};

declare function u:binary-doc($uri){
()
};

declare function u:binary-to-string($data){
()
};

(: -------------------------------------------------------------------------- :)
declare function u:serialize($xml,$options){
(: -------------------------------------------------------------------------- :)
$xml
};


(: -------------------------------------------------------------------------- :)
(: EVAL UTILITIES                                                             :)
(: -------------------------------------------------------------------------- :)

(: -------------------------------------------------------------------------- :)
declare function u:evalXPATH($xpath, $xml){
(: -------------------------------------------------------------------------- :)
  if ($xpath eq '/' or $xpath eq '' or empty($xml)) then
    $xml
  else
    ($xml/.)/saxon:evaluate($xpath)
};

(: -------------------------------------------------------------------------- :)
declare function u:transform($stylesheet,$xml){
(: -------------------------------------------------------------------------- :)
  let $rendition := saxon:compile-stylesheet(document{$stylesheet})
  return
    saxon:transform($rendition, $xml)
};


(: -------------------------------------------------------------------------- :)
(: STEP UTILITIES                                                             :)
(: -------------------------------------------------------------------------- :)


(: -------------------------------------------------------------------------- :)
declare function u:outputResultElement($exp){
(: -------------------------------------------------------------------------- :)
    <c:result>{$exp}</c:result>
};

(: -------------------------------------------------------------------------- :)
declare function u:get-secondary($name as xs:string,$secondary as element(xproc:input)*) as item()*{
(: -------------------------------------------------------------------------- :)
    $secondary[@port eq $name]/node() 
};


(: -------------------------------------------------------------------------- :)
declare function u:get-option($option-name as xs:string,$options as element(xproc:options),$primary) as xs:string*{
(: -------------------------------------------------------------------------- :)
let $value as xs:string := replace(string($options//p:with-option[@name eq $option-name]/@select),'&quot;','')
return
  $value
};





(: -------------------------------------------------------------------------- :)
(: ERROR HANDLING                                                             :)
(: -------------------------------------------------------------------------- :)


(: -------------------------------------------------------------------------- :)
declare function u:xprocxqError($error,$string) {
(: -------------------------------------------------------------------------- :)
let $info := $const:xprocxq-error//xxq-error:error[@code=substring-after($error,':')]
    return
        error(QName('http://xproc.net/xproc/error',$error),concat($error,": xprocxq error - ",$string," ",$info/text(),'&#10;'))};




(: -------------------------------------------------------------------------- :)
declare function u:dynamicError($error,$string) {
(: -------------------------------------------------------------------------- :)
    let $info := $const:error//err:error[@code=substring-after($error,':')]
    return
        error(QName('http://www.w3.org/ns/xproc-error',$error),concat($error,": XProc Dynamic Error - ",$string," ",$info/text(),'&#10;'))
};

(: -------------------------------------------------------------------------- :)
declare function u:stepError($error,$string) {
(: -------------------------------------------------------------------------- :)
let $info := $const:error//err:error[@code=substring-after($error,':')]
    return
        error(QName('http://www.w3.org/ns/xproc-error',$error),concat($error,": XProc Step Error - ",$string," ",$info/text(),'&#10;'))
};




(: -------------------------------------------------------------------------- :)
(: ASSERTIONS, DEBUG TOOLS                                                    :)
(: -------------------------------------------------------------------------- :)

(: -------------------------------------------------------------------------- :)
declare function u:trace($value as item()*, $what as xs:string)  {
if(boolean($const:NDEBUG)) then
    trace($value,$what)
else
    ()
};


(: -------------------------------------------------------------------------- :)
declare function u:asserterror($errortype as xs:string, $booleanexp as item(), $why as xs:string)  {
if(not($booleanexp) and boolean($const:NDEBUG)) then
    u:dynamicError(fn:QName('http://www.w3.org/ns/xproc-error',$errortype),$why)
else
    ()
};


(: -------------------------------------------------------------------------- :)
declare function u:assert($booleanexp as item(), $why as xs:string)  {
if(not($booleanexp) and boolean($const:NDEBUG)) then 
    u:dynamicError('err:XC0020',$why)
else
    ()
};


(: -------------------------------------------------------------------------- :)
declare function u:assert($booleanexp as item(), $why as xs:string,$error)  {
(: -------------------------------------------------------------------------- :)
if(not($booleanexp) and boolean($u:NDEBUG)) then 
    error(QName('http://www.w3.org/ns/xproc-error',$error),concat("XProc Assert Error: ",$why))
else
    ()
};


(: -------------------------------------------------------------------------- :)
(: manage namespaces                                                          :)
(: -------------------------------------------------------------------------- :)

declare function u:declarens($element){
    u:declare-ns(u:enum-ns($element))
};


declare function u:declare-ns($namespaces){
    for $ns in $namespaces//ns
    return
        ()
};


declare function u:namespaces-in-use( $root as node()? )  {
       
for $ns in distinct-values(
      $root/descendant-or-self::*/(.)/in-scope-prefixes(.))

return
  <ns prefix="{$ns}" URI="{namespace-uri-for-prefix($ns,$root)}"/>

 } ;

declare function u:enum-ns($element){
       for $child in $element/node()
            return
              if ($child instance of element() or $child instance of document-node()) then
               	 u:namespaces-in-use($child)
                else
                  <ns/>

};


(:
declare function u:xquery($query as xs:string){
    let $qry := if (starts-with($query,'/') or starts-with($query,'//')) then
                concat('.',$query)
			  else if(contains($query,'(/')) then
				replace($query,'\(/','(./')
              else if($query eq '') then
			    u:dynamicError('err:XD0001','query is empty and/or XProc step is not supported')
              else
                  $query
    let $result := util:eval($qry)   
    return
        $result
};


:)
