xquery version "3.0";

module namespace textensions ="textensions";

import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";
              
import module namespace ext = "http://xproc.net/xproc/ext"
    at "../../xquery/ext.xqm";
    
declare function (:TEST:) textensions:loadModuleTest() { 
  let $actual := <test/>
  return
    test:assertXMLEqual($actual,<test/>) 
};

declare function (:TEST:) textensions:testPre() { 
  let $actual := $ext:pre(<test/>,(),(),())
  return
    $actual
};

declare function (:TEST:) textensions:testPost() { 
  let $actual := $ext:post(<test/>,(),(),())
  return
    $actual

};

