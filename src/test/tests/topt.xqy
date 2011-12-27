xquery version "3.0";

module namespace topt ="topt";

import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";
              
import module namespace opt = "http://xproc.net/xproc/opt"
    at "../../xquery/opt.xqm";
    
declare function (:TEST:) topt:loadModuleTest() { 
  let $actual := <test/>
  return
    test:assertXMLEqual($actual,<test/>) 
};

