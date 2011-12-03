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
  let $parse   :=  parse:explicit-bindings( parse:AST(parse:explicit-name(parse:explicit-type($pipeline))))
  let $b := $parse/*
  let $ast   := element p:declare-step {$parse/@*,
   namespace p {"http://www.w3.org/ns/xproc"},
   namespace xproc {"http://xproc.net/xproc"},
   namespace ext {"http://xproc.net/xproc/ext"},
   namespace opt {"http://xproc.net/xproc/opt"},
   namespace c {"http://www.w3.org/ns/xproc-step"},
   namespace err {"http://www.w3.org/ns/xproc-error"},
   namespace xxq-error {"http://xproc.net/xproc/error"},
   parse:pipeline-step-sort( $b, () )
 }
  
  let $result := xproc:genstepnames($ast)
  return  
    $result
};


declare function (:TEST:) txproc:runEntryPointTest() { 
  let $pipeline := fn:doc('data/test2.xpl')
  let $stdin    := <test/>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $result   := xproc:run($pipeline,$stdin,$bindings,$options,(),$dflag,$tflag)
  return
    $result
};


declare function (:TEST:) txproc:runEntryPointTest4() { 
  let $pipeline := <p:declare-step name="main">
<p:input port="source"/><p:output port="result"/>
<p:identity/><p:count/></p:declare-step>
  let $stdin    := <c>aaa<a id="1"><b id="2">test</b></a></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   := ()
  return
   $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
};

declare function (:TEST:) txproc:runEntryPointTest1() { 
  let $pipeline := fn:doc('data/simple.xpl')
  let $stdin    := <test/>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $result   := xproc:run($pipeline,$stdin,$bindings,$options,(),$dflag,$tflag)
  return
    $result
};

declare function (:TEST:) txproc:runEntryPointTest2() { 
  let $pipeline := fn:doc('data/test2.xpl')
  let $stdin    := <test/>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  return
   $xproc:run-step($pipeline,$stdin,$bindings,$options,(),$dflag,$tflag)
};

declare function (:
TEST:) txproc:runEntryPointTest3() { 
  let $pipeline := fn:doc('data/test2.xpl')
  let $stdin    := <test/>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  return
   $xproc:run-step($pipeline,$stdin,$bindings,$options,(),$dflag,$tflag)
};

declare function (:TEST:) txproc:runDynamicError() { 
  let $pipeline := fn:doc('data/error.xpl')
  let $stdin    := <test/>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $output   := ()
  return
   $xproc:run-step($pipeline,$stdin,$bindings,$options,$output,$dflag,$tflag)
};

declare function (:TEST:) txproc:runComplexSingleBranch() { 
  let $pipeline := fn:doc('data/complex-single-branch.xpl')
  let $stdin    := <c>aaa<a id="1"><b id="2">test</b></a></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $output   := ()
  return
   $xproc:run-step($pipeline,$stdin,$bindings,$options,$output,$dflag,$tflag)
};

declare function (:TEST:) txproc:runGroup() { 
  let $pipeline := <p:declare-step name="main">
<p:input port="source"/><p:output port="result"/>
<p:group><p:identity/><p:count/></p:group><p:identity/></p:declare-step>
  let $stdin    := <c>aaa<a id="1"><b id="2">test</b></a></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   := ()
  return
   $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
};
