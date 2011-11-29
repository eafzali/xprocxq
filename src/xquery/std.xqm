(: ------------------------------------------------------------------------------------- 

	std.xqm - Implements all standard xproc steps.
	
---------------------------------------------------------------------------------------- :)
xquery version "3.0" encoding "UTF-8";

module namespace std = "http://xproc.net/xproc/std";

(: declare namespaces :)
declare namespace xproc = "http://xproc.net/xproc";
declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";
declare namespace xsl="http://www.w3.org/1999/XSL/Transform";

(: module imports :)
import module namespace const = "http://xproc.net/xproc/const" at "const.xqm";
import module namespace u = "http://xproc.net/xproc/util" at "util.xqm";

(: declare functions :)
declare variable $std:add-attribute      := std:add-attribute#4;
declare variable $std:add-xml-base       := std:add-xml-base#4;
declare variable $std:count              := std:count#4;
declare variable $std:compare            := std:compare#4;
declare variable $std:delete             := std:delete#4;
declare variable $std:error              := std:error#4;
declare variable $std:filter             := std:filter#4;
declare variable $std:directory-list     := std:directory-list#4;
declare variable $std:escape-markup      := std:escape-markup#4;
declare variable $std:http-request       := ();
declare variable $std:identity           := std:identity#4;
declare variable $std:insert             := ();
declare variable $std:label-elements     := std:label-elements#4;
declare variable $std:load               := std:load#4;
declare variable $std:make-absolute-uris := ();
declare variable $std:namespace-rename   := ();
declare variable $std:pack               := ();
declare variable $std:parameters         := ();
declare variable $std:rename             := std:rename#4;
declare variable $std:replace            := ();
declare variable $std:set-attributes     := ();
declare variable $std:sink               := ();
declare variable $std:split-sequence     := std:split-sequence#4;
declare variable $std:store              := ();
declare variable $std:string-replace     := std:string-replace#4;
declare variable $std:unescape-markup    := std:unescape-markup#4;
declare variable $std:xinclude           := ();
declare variable $std:wrap               := std:wrap#4;
declare variable $std:wrap-sequence      := std:wrap-sequence#4;
declare variable $std:unwrap             := std:unwrap#4;
declare variable $std:xslt               := std:xslt#4;


(: -------------------------------------------------------------------------- :)
declare function std:add-attribute($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $match  := u:get-option('match',$options,$primary)
let $attribute-name as xs:string := u:get-option('attribute-name',$options,$primary)
let $attribute-value := u:get-option('attribute-value',$options,$primary)
let $attribute-prefix := u:get-option('attribute-prefix',$options,$primary)
let $attribute-namespace := u:get-option('attribute-namespace',$options,$primary)
let $template := <xsl:stylesheet version="2.0">
<xsl:template match=".">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="@*|node()">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

<xsl:template match="{$match}">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="{$attribute-name}" select="'{$attribute-value}'"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>
</xsl:stylesheet>      
return
  u:transform($template,$primary)
};


(: -------------------------------------------------------------------------- :)
declare function std:add-xml-base($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $all as xs:string := u:get-option('add',$options,$primary)
let $relative as xs:string := u:get-option('relative',$options,$primary)
let $template := <xsl:stylesheet version="2.0">
<xsl:template match=".">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="@*">
    <xsl:copy/>
</xsl:template>

<xsl:template match="node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="xml:base" select="''"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>
</xsl:stylesheet>      
return
  u:transform($template,$primary)
};


(: -------------------------------------------------------------------------- :)
declare function std:compare($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $alternate := u:get-secondary('alternate',$secondary)
(: let $strict := u:get-option('xproc:strict',$options,$v)  ext attribute xproc:strict:) 
let $fail-if-not-equal as xs:string := u:get-option('fail-if-not-equal',$options,$primary)
let $result := deep-equal($primary,$alternate)
return
  if($fail-if-not-equal eq "true") then
    if ($result) then          
      u:outputResultElement('true')
    else
      u:stepError('err:XC0019','p:compare fail-if-not-equal option is enabled and documents were not equal')
    else
      u:outputResultElement($result)
};


(: --------------------------------------------------------------------------------------- :)
declare function std:count($primary,$secondary,$options,$variables) as element(c:result){
(: --------------------------------------------------------------------------------------- :)
let $limit as xs:integer := xs:integer(replace(u:get-option('limit',$options,$primary),"'",""))
let $count as xs:integer := count($primary)
return
    if ($limit eq 0 or $count lt $limit ) then
      u:outputResultElement($count)
    else
      u:outputResultElement($limit)
};


(: -------------------------------------------------------------------------- :)
declare function std:delete($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
let $match  as xs:string := u:get-option('match',$options,$primary)
let $template := <xsl:stylesheet version="2.0">
<xsl:template match=".">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="@*|node()">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

<xsl:template match="{$match}"/>

</xsl:stylesheet>
return
  u:transform($template,$primary)
};


(: -------------------------------------------------------------------------- :)
declare function std:directory-list($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $path := u:get-option('path',$options,$primary)
let $include-filter := u:get-option('include-filter',$options,$primary)
let $exclude-filter := u:get-option('exclude-filter',$options,$primary)

let $segment := substring-after($path,'file://')
let $dirname := tokenize($path, '/')[last()]
let $result :=
                     let $files :=  u:dirlist($path)
                     return
                     <c:directory name="{$dirname}">
                     {for $file in $files return <c:file name="{document-uri($file)}"/>}
                     </c:directory>
  return
    u:outputResultElement($result)
};


(: -------------------------------------------------------------------------- :)
declare function std:escape-markup($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $cdata-section-elements := u:get-option('limit',$options,$primary)
let $doctype-public         := u:get-option('doctype-public',$options,$primary)
let $doctype-system         := u:get-option('doctype-system',$options,$primary)
let $escape-uri-attributes  := u:get-option('escape-uri-attributes',$options,$primary)
let $include-content-type   := u:get-option('include-content-type',$options,$primary)
let $indent                 := u:get-option('indent',$options,$primary)
let $media-type             := u:get-option('media-type',$options,$primary)
let $method                 := u:get-option('method',$options,$primary)
let $omit-xml-declaration   := u:get-option('omit-xml-declaration',$options,$primary)
let $standalone             := u:get-option('standalone',$options,$primary)
let $undeclare-prefixes     := u:get-option('undeclare-prefixes',$options,$primary)
let $version                := u:get-option('version',$options,$primary)
return
  element{name($primary)}{
    u:serialize($primary/*)
  }
};


(: -------------------------------------------------------------------------- :)
declare function std:error($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $code := u:get-option('code',$options,$primary)
let $err := <c:errors>
<c:error href="" column="" offset="" name="step-name" type="p:error" code="{$code}">
  <message>{$primary}</message>
</c:error>
</c:errors>
return
  u:dynamicError('err:XD0030',concat(": p:error throw custom error code - ",$code))
};


(: -------------------------------------------------------------------------- :)
declare function std:filter($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $select := u:get-option('select',$options,$primary)
return
  try {
    u:evalXPATH($select,document{$primary})
  }
  catch * {
    u:dynamicError('err:XD0016',": p:filter did not select anything - ")
  }
};


(: -------------------------------------------------------------------------- :)
declare function std:http-request($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:identity($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
$primary
};


(: -------------------------------------------------------------------------- :)
declare function std:insert($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:label-elements($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $match  := u:get-option('match',$options,$primary)
let $attribute  := u:get-option('attribute',$options,$primary)
let $label  := u:get-option('label',$options,$primary)
let $replace  := u:get-option('replace',$options,$primary)
let $attribute-prefix  := u:get-option('attribute-prefix',$options,$primary)
let $attribute-namespace  := u:get-option('attribute-namespace',$options,$primary)

let $template := <xsl:stylesheet version="2.0">
<xsl:template match=".">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="@*|node()">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

<xsl:template match="{$match}">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:choose>
      <xsl:when test="not(@{$attribute}) or 'true' = '{$replace}'">
        <xsl:attribute name="{$attribute}"><xsl:value-of select="'{$label}'"/></xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>      

return
  u:transform($template,$primary)
};


(: -------------------------------------------------------------------------- :)
declare function std:load($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $href := u:get-option('href',$options,$primary)
let $dtd-validate := u:get-option('dtd-validate',$options,$primary)
let $xproc:output-uri := u:get-option('xproc:output-uri',$options,$primary)
return
try {
    if ($xproc:output-uri eq 'true') then
      u:outputResultElement(doc($href))
    else
      doc($href)
}catch * {
  u:dynamicError('err:XC0026',"p:load option href is empty or could not load document.")
}
};


(: -------------------------------------------------------------------------- :)
declare function std:make-absolute-uris($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:namespace-rename($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};



(: -------------------------------------------------------------------------- :)
declare function std:pack($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:parameters($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:rename($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)

let $match  := u:get-option('match',$options,$primary)
let $new-name  := u:get-option('new-name',$options,$primary)
let $new-prefix  := u:get-option('new-prefix',$options,$primary)
let $new-namespace  := u:get-option('new-namespace',$options,$primary)

let $template := <xsl:stylesheet version="2.0">
<xsl:template match=".">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="{$match}">
  <xsl:choose>
    <xsl:when test=". instance of element()">
      <xsl:element name="{$new-name}">
        <xsl:apply-templates select="@*"/>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:when>
    <xsl:when test=". instance of attribute()">
      <xsl:attribute name="{$new-name}" select="."/>
    </xsl:when>
    <xsl:when test=". instance of processing-instruction()">
      <xsl:processing-instruction name="{$new-name}" select="."/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="." />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="@*|node()">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

</xsl:stylesheet>      

return
  u:transform($template,$primary)
};


(: -------------------------------------------------------------------------- :)
declare function std:replace($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:set-attributes($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:sink($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:split-sequence($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $test := u:get-option('test',$options,$primary)
let $initial-only := u:get-option('initial-only',$options,$primary)
return
    for $child at $count in $primary
    return
      try {
        if(u:evalXPATH($test,document{$primary})) then
          $child
        else
          ()
      }
      catch * {
        u:dynamicError('err:XD0016',": p:filter did not select anything - ")
      }

};


(: -------------------------------------------------------------------------- :)
declare function std:store($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:string-replace($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $match  := u:get-option('match',$options,$primary)
let $replace as xs:string := concat("'",u:get-option('replace',$options,$primary),"'")
let $template := <xsl:stylesheet version="2.0">
<xsl:template match=".">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="@*|node()">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

<xsl:template match="{$match}">
  <xsl:choose>
    <xsl:when test=". instance of element()">
      <xsl:element name="{$match}">
      <xsl:copy-of select="@*"/>
        <xsl:value-of select="{$replace}"/>
      </xsl:element>
    </xsl:when>
    <xsl:when test=". instance of attribute()">
      <xsl:attribute name="{$match}">
        <xsl:value-of select="{$replace}"/>
      </xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="{$replace}"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
</xsl:stylesheet>      

return
  u:transform($template,$primary)
};


(: -------------------------------------------------------------------------- :)
declare function std:unescape-markup($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
let $content-type := u:get-option('content-type',$options,$primary)
let $encoding     := u:get-option('encoding',$options,$primary)
let $charset      := u:get-option('charset',$options,$primary)
return
  element{name($primary)}{
    u:parse($primary)
  }

};


(: -------------------------------------------------------------------------- :)
declare function std:xinclude($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
()
};


(: -------------------------------------------------------------------------- :)
declare function std:wrap($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $match  := u:get-option('match',$options,$primary)
let $wrapper as xs:string := u:get-option('wrapper',$options,$primary)
let $wrapper-prefix as xs:string := u:get-option('wrapper-prefix',$options,$primary)
let $wrapper-namespace as xs:string := u:get-option('wrapper-namespace',$options,$primary)
let $group-adjacent as xs:string := u:get-option('group-adjacent',$options,$primary)

let $template := <xsl:stylesheet version="2.0">
<xsl:template match=".">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="{$match}">
  <xsl:element name="{$wrapper}">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:element>
</xsl:template>

<xsl:template match="@*|node()">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

</xsl:stylesheet>      

return
  u:transform($template,$primary)
};


(: -------------------------------------------------------------------------- :)
declare function std:wrap-sequence($primary,$secondary,$options,$variables) as item()*{
(: -------------------------------------------------------------------------- :)
for $v in $primary
return
  std:wrap($v,$secondary,$options,$variables)
};


(: -------------------------------------------------------------------------- :)
declare function std:unwrap($primary,$secondary,$options,$variables) {
(: -------------------------------------------------------------------------- :)
let $match  := u:get-option('match',$options,$primary)
let $template := <xsl:stylesheet version="2.0">
<xsl:template match=".">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="{$match}">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="@*|node()">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

</xsl:stylesheet>      

return
  u:transform($template,$primary)
};

(: -------------------------------------------------------------------------- :)
declare function std:xslt($primary,$secondary,$options,$variables){
(: -------------------------------------------------------------------------- :)
let $stylesheet := u:get-secondary('stylesheet',$secondary)
return
  u:transform($stylesheet,$primary) 
};


