xquery version "3.0";

module namespace tstd ="tstd";

import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";
              
import module namespace std = "http://xproc.net/xproc/std"
    at "../../xquery/std.xqm";
    
declare function (:TEST:) tstd:loadModuleTest() { 
  let $actual := <test/>
  return
    test:assertXMLEqual($actual,<test/>) 
};
