xquery version "3.0";

module namespace txproc ="txproc";

declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";
declare namespace ext ="http://xproc.net/xproc/ext";
                    
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
  let $result   := document{parse:explicit-type($pipeline)}
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
  let $result   := parse:explicit-type($pipeline)
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

declare function (:TEST:) txproc:parseExplicitNames2() { 
  let $pipeline := fn:doc('data/submit-test-report.xpl')
  let $result   := parse:explicit-type($pipeline)
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

declare function (:TEST:) txproc:addXprocNamespace() { 
  let $pipeline := fn:doc('data/test1.xpl')
  let $result   := parse:explicit-type($pipeline)
  return
    test:assertStringContain( fn:string-join(distinct-values($result/descendant-or-self::*/(.|@*)/namespace-uri(.)),' '),'http://xproc.net/xproc')
};

declare function (:TEST:) txproc:addXprocNamespace1() { 
  let $pipeline := fn:doc('data/test1.xpl')
  let $result   := parse:explicit-type($pipeline)
  return
    test:assertStringContain( fn:string-join(distinct-values($result/descendant-or-self::*/(.|@*)/namespace-uri(.)),' '),'http://www.w3.org/ns/xproc')

};

declare function (:TEST:) txproc:testParseType1() { 
  let $result   := parse:type(<p:identity/>)
  return
    test:assertStringContain( $result, 'std')
};
declare function (:TEST:) txproc:testParseType2() { 
  let $result   := parse:type(<p:exec/>)
  return
    test:assertStringContain( $result, 'opt')
};
declare function (:TEST:) txproc:testParseType3() { 
  let $result   := parse:type(<ext:pre/>)
  return
    test:assertStringContain( $result, 'ext')
};
declare function (:TEST:) txproc:testParseType4() { 
  let $result   := parse:type(<p:input/>)
  return
    test:assertStringContain( $result, 'comp')
};
declare function (:TEST:) txproc:testParseType5() { 
  let $result   := ''
  return
    test:assertStringContain( $result, '')
};

declare function (:TEST:) txproc:testParseType6() { 
  let $result   := parse:type(<p:adsfadsfasdfadsf/>)
  return
    (test:assertStringContain( $result, 'error'),$result)
};

declare function (:TEST:) txproc:testExplicitName() { 
  let $pipeline := fn:doc('data/submit-test-report.xpl')
  let $result   := parse:explicit-name(parse:explicit-type($pipeline))
  return 
    (test:assertXMLEqual( $result, <test/>),$result)
};

declare function (:TEST:) txproc:testExplicitName1() { 
  let $pipeline := fn:doc('data/test.xpl')
  let $result   := parse:explicit-name(parse:explicit-type($pipeline))
  return 
    (test:assertXMLEqual( $result, <p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:xproc="http://xproc.net/xproc" version="1.0" xproc:type="comp-step" xproc:default-name="!1"><p:input port="source" xproc:type="comp">
  
<p:inline xproc:type="comp"><doc>
Congratulations! You've run your first pipeline!
</doc></p:inline></p:input><p:output port="result" xproc:type="comp"/><p:identity xproc:step="true" xproc:type="std-step" xproc:defaultname="!1.1"/></p:declare-step>),$result)
};

declare function (:TEST:) txproc:testAST() { 
  let $pipeline := fn:doc('data/test.xpl')
  let $result   := parse:AST(parse:explicit-name(parse:explicit-type($pipeline)))
  return 
    (test:assertXMLEqual( $result, <test/>),$result)
};

declare function (:TEST:) txproc:testAST1() { 
  let $pipeline := fn:doc('data/submit-test-report.xpl')
  let $result   := parse:AST(parse:explicit-name(parse:explicit-type($pipeline)))
  return 
    (test:assertXMLEqual( $result, <test/>),$result)
};

declare function (:TEST:) txproc:testExplicitBindings1() { 
  let $pipeline := fn:doc('data/test.xpl')
  let $result   := parse:explicit-bindings( parse:AST(parse:explicit-name(parse:explicit-type($pipeline))))
  return 
    (test:assertXMLEqual( $result, <test/>),$result)
};

declare function (:TEST:) txproc:testExplicitBindings2() { 
  let $pipeline := fn:doc('data/submit-test-report.xpl')
  let $result   := parse:explicit-bindings( parse:AST(parse:explicit-name(parse:explicit-type($pipeline))))
  return 
    (test:assertXMLEqual( $result, <test/>),$result)
};