xquery version "3.0";

module namespace textensions ="textensions";

import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";
              
import module namespace ext = "http://xproc.net/xproc/ext"
    at "../../xquery/ext.xqm";
    
declare function (:TEST:) textensions:exampleTest() { 
  let $actual := <test/>
  return
    test:assertXMLEqual($actual,<test/>) 
};
