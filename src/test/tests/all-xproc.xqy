xquery version "3.0";

 declare namespace p="http://www.w3.org/ns/xproc";
 declare namespace c="http://www.w3.org/ns/xproc-step";
 declare namespace err="http://www.w3.org/ns/xproc-error";

import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";

import module namespace txproc = "txproc"
    at "txproc.xqy";

    
test:html(
<testsuite title="xproc module">
  <test name="xproc1" desc="xproc.xqm module load">
    <expected>true</expected>
    <result>{txproc:loadModuleTest()}</result>
  </test>
  <test name="xproc2" desc="enum in-use namespaces">
    <expected><namespace name=""><ns prefix="xml" URI="http://www.w3.org/XML/1998/namespace"></ns><ns prefix="p" URI="http://www.w3.org/ns/xproc"></ns><ns prefix="c" URI=""></ns></namespace></expected>
    <result>{txproc:enumNSTest()}</result>
  </test>
  <test name="xproc3" desc="test getting step names of a pipe, in order">
    <expected>!1.0 !1.1 !1.3 !1.2 !1.0!</expected>
    <result>{txproc:stepNamesTest()}</result>
  </test>
  <test name="xproc4" desc="simple xproc pipeline">
    <expected><doc>
        Congratulations! You've run your first pipeline!
      </doc></expected>
    <result>{txproc:runEntryPointTest1()}</result>
  </test>
  <test name="xproc4" desc="simple xproc pipeline">
    <expected><c:result xmlns:c="http://www.w3.org/ns/xproc-step">1</c:result></expected>
    <result>{txproc:runEntryPointTest4()}</result>
  </test>
  <test name="xproc4a" desc="test entry point with simple xproc pipeline">
    <expected><c:result xmlns:c="http://www.w3.org/ns/xproc-step">1</c:result></expected>
    <result>{txproc:runEntryPointTest()}</result>
  </test>
  <test name="xproc4b" desc="test entry point via HOX invoke xproc:run-step">
    <expected><c:result xmlns:c="http://www.w3.org/ns/xproc-step">1</c:result></expected>
    <result>{txproc:runEntryPointTest2()}</result>
  </test>
  <test name="xproc5" desc="test">
    <expected><c:result xmlns:c="http://www.w3.org/ns/xproc-step">1</c:result></expected>
    <result>{txproc:runEntryPointTest3()}</result>
  </test>
  <test name="xproc7" desc="run more complex single branch pipeline (complex-single-branch.xpl)">
    <expected><packed><newwrapper><a new-id="this is a new string"></a></newwrapper>
   <a>test</a>
 </packed></expected>
    <result>{txproc:runComplexSingleBranch()}</result>
  </test>
  <test name="xproc8" desc="p:group">
    <expected><c:result xmlns:c="http://www.w3.org/ns/xproc-step">1</c:result></expected>
    <result>{txproc:runGroup()}</result>
  </test>
  <test name="xproc9a" desc="successful p:try">
    <expected><wrapme><c>aaa<a id="1"><b id="2">test</b></a></c></wrapme></expected>
    <result>{txproc:runTryCatch()}</result>
  </test>
  <test name="xproc9b" desc="p:try which fails and fallsback to catch">
    <expected><c>aaa<a id="1"><b id="2">test</b></a></c> </expected>
    <result>{txproc:runTryCatch1()}</result>
  </test>
  <test name="xproc10" desc="p:for-each">
    <expected><d><a>1</a></d><d><a>1</a></d><d><a>1</a></d><d><a>1</a></d><d><a>1</a></d><d><a>1</a></d><d><a>1</a></d><d><a>1</a></d><d><a>1</a></d></expected>
    <result>{txproc:runForEach()}</result>
  </test>
  <test name="xproc11" desc="p:viewport">
    <expected><z><a>1</a></z><z><a><l>test</l></a></z><z><a><l>test</l></a></z></expected>
    <result>{txproc:runViewPort()}</result>
  </test>
  <test name="xproc12a" desc="p:choose with p:when">
    <expected><z><c><a>test1</a><a>test2</a></c></z></expected>
    <result>{txproc:runChoose()}</result>
  </test>
  <test name="xproc12b" desc="p:choose with p:otherwise">
    <expected><c:result xmlns:c="http://www.w3.org/ns/xproc-step">1</c:result></expected>
    <result>{txproc:runChoose1()}</result>
  </test>
  <test name="xproc13" desc="p:compare">
    <expected><c:result xmlns:c="http://www.w3.org/ns/xproc-step">false</c:result></expected>
    <result>{txproc:runCompare1()}</result>
  </test>
  <test name="xproc14" desc="p:count">
    <expected><c:result xmlns:c="http://www.w3.org/ns/xproc-step">3</c:result></expected>
    <result>{txproc:runCount1()}</result>
  </test>
  <test name="xproc14a" desc="p:count">
    <expected><c:result xmlns:c="http://www.w3.org/ns/xproc-step">1</c:result></expected>
    <result>{txproc:runCount2()}</result>
  </test>
  <!--test name="xproc15" desc="p:delete">
    <expected><p:pipeline name="pipeline" xmlns:p="http://www.w3.org/ns/xproc">



</p:pipeline></expected>
    <result>{txproc:runDelete1()}</result>
  </test-->

  <!--test name="xproc6" desc="test throwing dynamic error">
    <expected></expected>
    <result>{txproc:runDynamicError()}</result>
  </test-->
</testsuite>
)

(:
-- Local Variables:
-- compile-command: "../../../bin/test.sh all-xproc.xqy > ../../../report/all-xproc.html"
-- End:
:)
