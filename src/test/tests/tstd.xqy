xquery version "3.0";

module namespace tstd ="tstd";

(: declare namespaces :)
declare namespace xproc = "http://xproc.net/xproc";
declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";

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

