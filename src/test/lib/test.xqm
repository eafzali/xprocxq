xquery version "3.0";
                                              
(: Simple XQuery Unit Test Library - Jim Fuller 05/11/10 :)

module namespace test = "http://www.marklogic.com/test";

 (: declare options :)
 declare boundary-space strip;
 declare option saxon:output "method=html";
 declare option saxon:output "omit-xml-declaration=yes";


(: --------------------------------------------------------------------------------------------------- :)
declare function test:assertExists($a as item()*) as xs:boolean {
(: --------------------------------------------------------------------------------------------------- :)
    fn:exists($a)
};

(: --------------------------------------------------------------------------------------------------- :)
declare function test:assertXMLEqual($a, $b) as xs:boolean {
(: --------------------------------------------------------------------------------------------------- :)
    fn:deep-equal($a,$b,"http://www.w3.org/2005/xpath-functions/collation/codepoint")
};

(: --------------------------------------------------------------------------------------------------- :)
declare function test:assertXMLNotEqual($a as item()*, $b as item()*) as xs:boolean {
(: --------------------------------------------------------------------------------------------------- :)
    fn:not(test:assertXMLEqual($a,$b))
};

(: --------------------------------------------------------------------------------------------------- :)
declare function test:assertStringEqual($a as xs:string, $b as xs:string) as xs:boolean {  
(: --------------------------------------------------------------------------------------------------- :)
 fn:not(fn:boolean(fn:compare($a, $b)))
};

(: --------------------------------------------------------------------------------------------------- :)
declare function test:assertStringNotEqual($a as xs:string, $b as xs:string) as xs:boolean {  
(: --------------------------------------------------------------------------------------------------- :)
 fn:boolean(fn:compare($a, $b))
};

(: --------------------------------------------------------------------------------------------------- :)
declare function test:assertStringContain($a as xs:string, $b as xs:string) as xs:boolean {
(: --------------------------------------------------------------------------------------------------- :)
    fn:contains($a, $b)
};

(: --------------------------------------------------------------------------------------------------- :)
declare function test:assertStringNotContain($a as xs:string, $b as xs:string) as xs:boolean {
(: --------------------------------------------------------------------------------------------------- :)
    fn:not(fn:contains($a, $b))
};

(: --------------------------------------------------------------------------------------------------- :)
declare function test:assertIntegerEqual($a as xs:integer, $b as xs:integer) as xs:boolean {  
(: --------------------------------------------------------------------------------------------------- :)
  fn:boolean($a=$b) 
};

(: --------------------------------------------------------------------------------------------------- :)
declare function test:assertIntegerNotEqual($a as xs:integer, $b as xs:integer) as xs:boolean {  
(: --------------------------------------------------------------------------------------------------- :)
  fn:not(fn:boolean($a=$b)) 
};

(: --------------------------------------------------------------------------------------------------- :)
declare function test:html($results as element(testsuite)){
(: --------------------------------------------------------------------------------------------------- :)
let $xslt := saxon:compile-stylesheet(fn:doc('test.xsl'))
return
  saxon:transform($xslt, document{$results})
};

(: --------------------------------------------------------------------------------------------------- :)
(:                                                                                   Eval(evil) Tests  :)
(: --------------------------------------------------------------------------------------------------- :)
(: declare function test:assertEvalEqual($xpathstring, $expected){ :)
(:   let $actual := xdmp:eval($xpathstring) :)
(:   return  :)
(:     test:assertXMLEqual($actual, $expected) :)
(: }; :)

