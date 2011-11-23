xquery version "3.0";

module namespace tparse ="tparse";

declare boundary-space strip;

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
    
declare function (:TEST:) tparse:loadModuleTest() { 
  let $actual := <test/>
  return
    test:assertXMLEqual($actual,<test/>) 
};


declare function (:TEST:) tparse:parseExplicitNames() { 
  let $pipeline := fn:doc('data/test.xpl')
  let $result   := parse:explicit-type($pipeline)
  return
    $result
};

declare function (:TEST:) tparse:parseExplicitNames1() { 
  let $pipeline := fn:doc('data/submit-test-report.xpl')
  let $result   := parse:explicit-type($pipeline)
  return
    $result
};

declare function (:TEST:) tparse:parseExplicitNames2() { 
  let $pipeline := fn:doc('data/submit-test-report.xpl')
  let $result   := parse:explicit-type($pipeline)
  return
    $result
};

declare function (:TEST:) tparse:addParseNamespace() { 
  let $pipeline := fn:doc('data/test1.xpl')
  let $result   := parse:explicit-type($pipeline)
  return
    test:assertStringContain( fn:string-join(distinct-values($result/descendant-or-self::*/(.|@*)/namespace-uri(.)),' '),'http://xproc.net/xproc')
};

declare function (:TEST:) tparse:addParseNamespace1() { 
  let $pipeline := fn:doc('data/test1.xpl')
  let $result   := parse:explicit-type($pipeline)
  return
    test:assertStringContain( fn:string-join(distinct-values($result/descendant-or-self::*/(.|@*)/namespace-uri(.)),' '),'http://www.w3.org/ns/xproc')

};

declare function (:TEST:) tparse:testParseType1() { 
  let $result   := parse:type(<p:identity/>)
  return
    test:assertStringContain( $result, 'std')
};
declare function (:TEST:) tparse:testParseType2() { 
  let $result   := parse:type(<p:exec/>)
  return
    $result
};
declare function (:TEST:) tparse:testParseType3() { 
  let $result   := parse:type(<ext:pre/>)
  return
    test:assertStringContain( $result, 'ext')
};
declare function (:TEST:) tparse:testParseType4() { 
  let $result   := parse:type(<p:input/>)
  return
    test:assertStringContain( $result, 'comp')
};
declare function (:TEST:) tparse:testParseType5() { 
  let $result   := ''
  return
    test:assertStringContain( $result, '')
};
declare function (:TEST:) tparse:testParseType6() { 
  let $result   := parse:type(<p:adsfadsfasdfadsf/>)
  return
    (test:assertStringContain( $result, 'error'))
};

declare function (:TEST:) tparse:testExplicitName() { 
  let $pipeline := fn:doc('data/submit-test-report.xpl')
  let $result   := parse:explicit-type($pipeline)
  return 
    document{$result} 
};

declare function (:TEST:) tparse:testExplicitName1() { 
  let $pipeline := fn:doc('data/test.xpl')
  let $result   := parse:explicit-name(parse:explicit-type($pipeline))
  return 
    document{$result} 
};

declare function (:TEST:) tparse:testAST() { 
  let $pipeline := fn:doc('data/test.xpl')
  let $result   := parse:AST(parse:explicit-name(parse:explicit-type($pipeline)))
  return 
    document{$result} 
};

declare function (:TEST:) tparse:testAST1() { 
  let $pipeline := fn:doc('data/submit-test-report.xpl')
  let $result   := parse:AST(parse:explicit-name(parse:explicit-type($pipeline)))
  return 
    document{$result} 
};

declare function (:TEST:) tparse:testExplicitBindings1() { 
  let $pipeline := fn:doc('data/test1.xpl')
  let $result   := parse:explicit-bindings( parse:AST(parse:explicit-name(parse:explicit-type($pipeline))))
  return 
    document{$result} 
};

declare function (:TEST:) tparse:testExplicitBindings2() { 
  let $pipeline := fn:doc('data/submit-test-report.xpl')
  let $result   := parse:explicit-bindings( parse:AST(parse:explicit-name(parse:explicit-type($pipeline))))
  return 
    document{$result} 
};

declare function (:TEST:) tparse:testExplicitBindings3() { 
  let $pipeline := fn:doc('data/test.xpl')
  let $result   := parse:explicit-bindings(parse:AST(parse:explicit-name(parse:explicit-type($pipeline))))
  return 
    document{$result} 
};

declare function (:TEST:) tparse:testExplicitBindings4() { 
  let $pipeline := fn:doc('data/test2.xpl')
  let $result   := parse:explicit-bindings( parse:AST(parse:explicit-name(parse:explicit-type($pipeline))))
  return 
    document{$result} 
};

declare function (:TEST:) tparse:testStepSort1() { 
  let $pipeline := fn:doc('data/test2.xpl')
  let $parse   := parse:explicit-bindings( parse:AST(parse:explicit-name(parse:explicit-type($pipeline))))
  let $result   := element p:declare-step {$parse/@*,
    namespace xproc {"http://xproc.net/xproc"},
    namespace ext {"http://xproc.net/xproc/ext"},
    namespace c {"http://www.w3.org/ns/xproc-step"},
    namespace err {"http://www.w3.org/ns/xproc-error"},
    namespace xxq-error {"http://xproc.net/xproc/error"},
    parse:pipeline-step-sort( $parse/*, () )
    }
  return 
    $result
};
