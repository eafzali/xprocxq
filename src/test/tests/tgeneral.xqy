xquery version "3.0";

module namespace tgeneral ="tgeneral";

import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";
              
import module namespace xproc = "http://xproc.net/xproc"
    at "../../xquery/xproc.xqm";
    
declare function (:TEST:) tgeneral:exampleTest() { 
  let $actual := <test/>
  return
    test:assertXMLEqual($actual,<test/>) 
};


declare function (:TEST:) tgeneral:runEntryPointTest() { 
  let $pipeline := fn:doc('data/test.xpl')
  let $stdin    := <test/>
  let $dflag    := 1
  let $tflag    := 1
  let $bindings := ()
  let $options  := ()
  return
    test:assertXMLEqual( xproc:run($pipeline,$stdin,$dflag,$tflag,$bindings,$options), $pipeline)
};






