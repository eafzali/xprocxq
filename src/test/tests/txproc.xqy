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
   parse:pipeline-step-sort( $b, <p:declare-step xproc:default-name="!1"/> )
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


declare function (:TEST:) txproc:runEntryPointTest1() { 
  let $pipeline := fn:doc('data/simple.xpl')
  let $stdin    := ()
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


declare function (:TEST:) txproc:runTryCatch() { 
  let $pipeline := <p:declare-step name="main">
<p:input port="source"/><p:output port="result"/>
<p:try><p:wrap wrapper="wrapme" match="/"/></p:try><p:identity/></p:declare-step>
  let $stdin    := <c>aaa<a id="1"><b id="2">test</b></a></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   := ()
  return
   $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
};

declare function (:TEST:) txproc:runTryCatch1() { 
  let $pipeline := <p:declare-step name="main">
<p:input port="source"/><p:output port="result"/>
<p:try><p:wrap wrapper="2" match="/"/></p:try><p:identity/></p:declare-step>
  let $stdin    := <c>aaa<a id="1"><b id="2">test</b></a></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   := ()
  return
   $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
};


declare function (:TEST:) txproc:runForEach() { 
  let $pipeline := <p:declare-step name="main">
<p:input port="source"/><p:output port="result"/>
<p:for-each><p:iteration-source select="//a"/><p:wrap wrapper="d" match="/"/></p:for-each><p:identity/></p:declare-step>
  let $stdin    := <c><a>1</a><a>1</a><a>1</a><a>1</a><a>1</a><a>1</a><a>1</a><a>1</a><a>1</a><b>2</b></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   := ()
  return
   $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
};

declare function (:TEST:) txproc:runViewPort() { 
  let $pipeline := <p:declare-step name="main">
<p:input port="source"/><p:output port="result"/>
<p:viewport><p:viewport-source select="//a"/><p:wrap wrapper="z" match="/"/></p:viewport><p:identity/></p:declare-step>
  let $stdin    := <c><a>1</a><b><a><l>test</l></a></b><r><a><l>test</l></a></r></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   := ()
  return
   $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
};

declare function (:TEST:) txproc:runChoose() { 
  let $pipeline := <p:declare-step name="main">
<p:input port="source"/><p:output port="result"/>
<p:choose><p:xpath-context select="//a"/><p:when test="count(a) eq 2"><p:wrap wrapper="z" match="/"/></p:when><p:otherwise><p:count/></p:otherwise></p:choose><p:identity/></p:declare-step>
  let $stdin    := <c><a>test1</a><a>test2</a></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   := ()
  return
   $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
};

declare function (:TEST:) txproc:runChoose1() { 
  let $pipeline := <p:declare-step name="main">
<p:input port="source"/><p:output port="result"/>
<p:choose><p:xpath-context select="//a"/><p:when test="count(a) lt 1"><p:wrap wrapper="z" match="/"/></p:when><p:otherwise><p:count/></p:otherwise></p:choose><p:identity/></p:declare-step>
  let $stdin    := <c><a>test1</a><a>test2</a></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   := ()
  return
   $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
};


declare function (:TEST:) txproc:runCompare1() { 
  let $pipeline := <p:declare-step version='1.0' name="main"
	    xmlns:p="http://www.w3.org/ns/xproc">
  <p:input port="source" primary="true"/>
  <p:input port="alternate" primary="false">
    <p:inline>
      <c>here</c>
    </p:inline>
  </p:input>

  <p:output port="result" primary="true"/>

  <p:compare name="compare">
    <p:input port="source">
      <p:pipe step="main" port="source"/>
    </p:input>
    <p:input port="alternate">
      <p:pipe step="main" port="alternate"/>
    </p:input>
  </p:compare>
</p:declare-step>

  let $stdin    := <c><a>test1</a><a>test2</a></c>
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   :=  ()
  return
   $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
};

declare function (:TEST:) txproc:runCount1() { 
  let $pipeline :=   <p:declare-step version='1.0'>
    <p:input port="source" sequence="true"/>
    <p:output port="result"/>

    <p:count/>

  </p:declare-step>

  let $stdin    :=  (<document>
    <doc xmlns=""/>
  </document>,
  <document>
    <doc xmlns=""/>
  </document>,
  <document>
    <doc xmlns=""/>
  </document>)
  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   :=  ()
  return
   $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
};



declare function (:TEST:) txproc:runCount2() { 
  let $pipeline :=     <p:declare-step version='1.0'>
    <p:input port="source" sequence="true"/>
    <p:output port="result"/>
    <p:count>
        <p:input port="source" select="/node()"/>
    </p:count>
  </p:declare-step>

  let $stdin    :=  <doc>
    <p>This is a para</p>
    <p>This is a para</p>
    <p>This is a para</p>
    <p>This is a para</p>
    <p>This is a para</p>
</doc>

  let $dflag    := 0
  let $tflag    := 0
  let $bindings := ()
  let $options  := ()
  let $outputs   :=  ()
  return
   $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
};


