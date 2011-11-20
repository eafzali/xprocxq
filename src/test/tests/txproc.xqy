xquery version "3.0";

module namespace txproc ="txproc";

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
    
declare function (:TEST:) txproc:loadModuleTest() { 
  let $actual := <test/>
  return
    test:assertXMLEqual($actual,<test/>) 
};


declare function (:TEST:) txproc:enumNSTest() { 
  let $pipeline := fn:doc('data/submit-test-report.xpl')
  let $result := xproc:enum-namespaces($pipeline)

  return
    $result
};


declare function (:TEST:) txproc:stepNamesTest() { 
  let $pipeline := fn:doc('data/test2.xpl')
  let $parse      := parse:explicit-bindings( parse:AST(parse:explicit-name(parse:explicit-type($pipeline))))
  let $ast        := element p:declare-step {$parse/@*,
   namespace xproc {"http://xproc.net/xproc"},
   namespace ext {"http://xproc.net/xproc/ext"},
   namespace c {"http://www.w3.org/ns/xproc-step"},
   namespace err {"http://www.w3.org/ns/xproc-error"},
   namespace xxq-error {"http://xproc.net/xproc/error"},
   parse:pipeline-step-sort( $parse/*, () )
 }

  let $result := xproc:genstepnames($ast)
  return
   $result
};

declare function (:TEST:) txproc:runEntryPointTest() { 
  let $pipeline := fn:doc('data/test2.xpl')
  let $stdin    := <test/>
  let $dflag    := 1
  let $tflag    := 1
  let $bindings := ()
  let $options  := ()
  let $result   := xproc:run($pipeline,$stdin,$dflag,$tflag,$bindings,$options,())
  return
    $result
};

declare function (:TEST:) txproc:runEntryPointTest2() { 
  let $pipeline := fn:doc('data/test.xpl')
  let $stdin    := <test/>
  let $dflag    := 1
  let $tflag    := 1
  let $bindings := ()
  let $options  := ()
  return
   $xproc:run-step($pipeline,$stdin,$dflag,$tflag,$bindings,$options,())
};

