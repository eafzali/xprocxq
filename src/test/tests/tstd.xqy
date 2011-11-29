xquery version "3.0";

module namespace tstd ="tstd";

(: declare namespaces :)
declare namespace xproc = "http://xproc.net/xproc";
declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";
declare namespace xsl="http://www.w3.org/1999/XSL/Transform";

import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";
              
import module namespace std = "http://xproc.net/xproc/std"
    at "../../xquery/std.xqm";
    
declare function (:TEST:) tstd:loadModuleTest() { 
  let $actual := <test/>
  return
    test:assertXMLEqual($actual,<test/>) 
};

declare function (:TEST:) tstd:testIdentity() { 
  let $actual := $std:identity(<test/>,(),(),())
  return
    $actual
};

declare function (:TEST:) tstd:testCount() { 
  let $actual := $std:count(<test/>,(),<xproc:options><p:with-option name='limit' select='0'/></xproc:options>,())
  return
    $actual
};

declare function (:TEST:) tstd:testCount2() { 
  let $input  := (<test/>,<test/>,<test/>,<test/>)
  let $actual := $std:count($input,(),<xproc:options><p:with-option name='limit' select='5'/></xproc:options>,())
  return
    $actual
};

declare function (:TEST:) tstd:testCount3() { 
  let $input  := (<test/>,<test/>,<test/>,<test/>)
  let $actual := $std:count($input,(),<xproc:options><p:with-option name='limit' select='4'/></xproc:options>,())
  return
    $actual
};

declare function (:TEST:) tstd:testCount4() { 
  let $input  := (<test/>,<test/>,<test/>,<test/>)
  let $actual := $std:count($input,(),<xproc:options><p:with-option name='limit' select='2'/></xproc:options>,())
  return
    $actual
};

declare function (:TEST:) tstd:testError() { 
  let $input  := <test/>
  let $actual := $std:error($input,(),<xproc:options><p:with-option name='code' select='9999'/></xproc:options>,())
  return
    $actual
};

declare function (:TEST:) tstd:testFilter() { 
  let $input  := <c>aaa<a id="1"><b id="2">test</b></a></c>
  let $actual := $std:filter($input,(),<xproc:options><p:with-option name='select' select='/c/a'/></xproc:options>,())
  return
    $actual
};

declare function (:TEST:) tstd:testDelete() { 
  let $input  := <c>aaa<a id="1"><b id="2">test</b></a></c>
  let $actual := $std:delete($input,(),<xproc:options><p:with-option name='match' select='a'/></xproc:options>,())
  return
    $actual
};

declare function (:TEST:) tstd:testDelete1() { 
  let $input  := <c>aaa<a id="1"><b id="2">test</b></a></c>
  let $actual := $std:delete($input,(),<xproc:options><p:with-option name='match' select='b'/></xproc:options>,())
  return
    $actual
};

declare function (:TEST:) tstd:testDelete2() { 
  let $input  := <c>aaa<a id="1"><b id="2">test</b></a></c>
  let $actual := $std:delete($input,(),<xproc:options><p:with-option name='match' select='@*'/></xproc:options>,())
  return
    $actual
};


declare function (:TEST:) tstd:testAddAttr() { 
  let $input  := <c>aaa<a id="1"><b id="2">test</b></a></c>
  let $actual := $std:add-attribute($input,(),<xproc:options><p:with-option name='match' select='b'/><p:with-option name='attribute-name' select='test'/><p:with-option name='attribute-value' select='"test"'/></xproc:options>,())
  return
    $actual
};


declare function (:TEST:) tstd:testStringReplace() { 
  let $input  := <c>aaa<a id="1"><b id="2">test</b></a></c>
  let $actual := $std:string-replace($input,(),<xproc:options><p:with-option name='match' select='b'/><p:with-option name='replace' select='aaaa'/></xproc:options>,())
  return
    $actual
};


declare function (:TEST:) tstd:testWrap() { 
  let $input  := <c>aaa<a id="1"><b id="2">test</b></a></c>
  let $actual := $std:wrap($input,(),<xproc:options><p:with-option name='match' select='b'/><p:with-option name='wrapper' select='"aaaa"'/></xproc:options>,())
  return
    $actual
};

declare function (:TEST:) tstd:testWrapSequence() { 
  let $input  := (<c>aaa<a id="1"><b id="2">test</b></a></c>,<a><b>aaa</b></a>)
  let $actual := $std:wrap-sequence($input,(),<xproc:options><p:with-option name='match' select='b'/><p:with-option name='wrapper' select='"aaaa"'/></xproc:options>,())
  return
    $actual
};

declare function (:TEST:) tstd:testUnwrap() { 
  let $input  := <c>aaa<a id="1"><b id="2">test</b></a></c>
  let $actual := $std:unwrap($input,(),<xproc:options><p:with-option name='match' select='b'/></xproc:options>,())
  return
    $actual
};

declare function (:TEST:) tstd:testUnwrap1() { 
  let $input  := <c>aaa<a id="1"><b id="2">test</b><b>alternate</b></a></c>
  let $actual := $std:unwrap($input,(),<xproc:options><p:with-option name='match' select='b'/></xproc:options>,())
  return
    $actual
};

declare function (:TEST:) tstd:testRename() { 
  let $input  := <c>aaa<a id="1"><b id="2">test</b><b>alternate</b></a></c>
  let $actual := $std:rename($input,(),<xproc:options><p:with-option name='match' select='b'/><p:with-option name='new-name' select='newname'/></xproc:options>,())
  return
    $actual
};

declare function (:TEST:) tstd:testRename1() { 
  let $input  := <c>aaa<a id="1"><b id="2">test</b><b>alternate</b></a></c>
  let $actual := $std:rename($input,(),<xproc:options><p:with-option name='match' select='@id'/><p:with-option name='new-name' select='newid'/></xproc:options>,())
  return
    $actual
};

declare function (:TEST:) tstd:testLabelElements() { 
  let $input  := <c>aaa<a id="1"><b id="2">test</b><b>alternate</b></a></c>
  let $actual := $std:label-elements($input,(),<xproc:options><p:with-option name='match' select='b'/><p:with-option name='attribute' select='"xml:id"'/><p:with-option name='replace' select='"true"'/><p:with-option name='label' select='"somevalue"'/></xproc:options>,())
  return
    $actual
};

declare function (:TEST:) tstd:testXSLT() { 
  let $input  := <c>aaa<a id="1"><b id="2">test</b><b>alternate</b></a></c>
  let $secondary := <xproc:input step=""
             xproc:default-name=""
             port-type="input"
             href=""
             primary="false"
             select="/"
             port="stylesheet"
             func="">
<xsl:stylesheet version="2.0">
<xsl:template match="c">
    <processed>processed correctly</processed>
</xsl:template>
</xsl:stylesheet>
</xproc:input>

let $actual := $std:xslt($input,$secondary,<xproc:options>
<p:with-option name='initial-mode' select=''/>
<p:with-option name='template-name' select=''/>
<p:with-option name='output-base-uri' select=''/>
<p:with-option name='version' select='2.0'/></xproc:options>,())
  return
    $actual
};
