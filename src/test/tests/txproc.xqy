xquery version "3.0";

module namespace txproc ="txproc";

import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";
              
import module namespace xproc = "http://xproc.net/xproc"
    at "../../xquery/xproc.xqm";

import module namespace parse = "http://xproc.net/xproc/parse"
    at "../../xquery/parse.xqm";
    
declare function (:TEST:) txproc:loadModuleTest() { 
  let $actual := <test/>
  return
    test:assertXMLEqual($actual,<test/>) 
};


declare function (:TEST:) txproc:runEntryPointTest() { 
  let $pipeline := fn:doc('data/test.xpl')
  let $stdin    := <test/>
  let $dflag    := 1
  let $tflag    := 1
  let $bindings := ()
  let $options  := ()
  let $result   := xproc:run($pipeline,$stdin,$dflag,$tflag,$bindings,$options)
  return
    test:assertXMLEqual( $result, $pipeline)
};

declare function (:TEST:) txproc:runEntryPointTest2() { 
  let $pipeline := fn:doc('data/test.xpl')
  let $stdin    := <test/>
  let $dflag    := 1
  let $tflag    := 1
  let $bindings := ()
  let $options  := ()
  return
    test:assertXMLEqual( $xproc:run-step($pipeline,$stdin,$dflag,$tflag,$bindings,$options), $pipeline)
};

declare function (:TEST:) txproc:parseExplicitNames() { 
  let $pipeline := fn:doc('data/test.xpl')
  let $result   := document{parse:explicit-names($pipeline)}
  return
(    test:assertXMLEqual( $result,document{<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0" name="pipeline">
<p:input port="source">
  <p:inline><doc>
Congratulations! You've run your first pipeline!
</doc></p:inline>
</p:input>
<p:output port="result"/>

<p:identity/>
</p:declare-step>}),$result)
};

declare function (:TEST:) txproc:parseExplicitNames1() { 
  let $pipeline := fn:doc('data/test1.xpl')
  let $result   := parse:explicit-names($pipeline)
  return
    (test:assertXMLEqual( $result,<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0" name="pipeline">
<p:input port="source">
  <p:inline><doc>
Congratulations! You've run your first pipeline!
</doc></p:inline>
</p:input>
<p:output port="result"/>

<p:identity/>
</p:declare-step>), $result)
};






