xquery version "3.0";

 declare namespace p="http://www.w3.org/ns/xproc";
 declare namespace c="http://www.w3.org/ns/xproc-step";
 declare namespace err="http://www.w3.org/ns/xproc-error";


import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";

import module namespace txproc = "txproc"
    at "txproc.xqy";

declare boundary-space preserve;
    
test:html(
<testsuite title="xproc module">
  <test name="xproc1" desc="xproc.xqm module load">
    <expected>true</expected>
    <result>{txproc:loadModuleTest()}</result>
  </test>
  <test name="xproc2" desc="enum in-use namespaces">
    <expected><namespace name=""><ns prefix="xml" URI="http://www.w3.org/XML/1998/namespace"></ns><ns prefix="p" URI="http://www.w3.org/ns/xproc"></ns><ns prefix="c" URI="http://www.w3.org/ns/xproc-step"></ns><ns prefix="cx" URI="http://xmlcalabash.com/ns/extensions"></ns><ns prefix="" URI=""></ns></namespace></expected>
    <result>{txproc:enumNSTest()}</result>
  </test>
  <test name="xproc3" desc="test getting step names of a pipe, in order">
    <expected>!1.0 !1.1 !1.3 !1.2 !1.0!</expected>
    <result>{txproc:stepNamesTest()}</result>
  </test>
  <test name="xproc4a" desc="test entry point with simple xproc pipeline">
    <expected><c:result xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:xproc="http://xproc.net/xproc">1</c:result></expected>
    <result>{txproc:runEntryPointTest()}</result>
  </test>
  <test name="xproc4b" desc="test entry point via HOX invoke xproc:run-step">
    <expected><c:result xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:xproc="http://xproc.net/xproc">1</c:result></expected>
    <result>{txproc:runEntryPointTest2()}</result>
  </test>
  <test name="xproc5" desc="test">
    <expected><c:result xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:xproc="http://xproc.net/xproc">1</c:result></expected>
    <result>{txproc:runEntryPointTest3()}</result>
  </test>
  <!--test name="xproc6" desc="test throwing dynamic error">
    <expected></expected>
    <result>{txproc:runDynamicError()}</result>
  </test-->
  <test name="xproc7" desc="run more complex single branch pipeline (complex-single-branch.xpl)">
    <expected><packed><newwrapper></newwrapper>
             <a>test</a>
             </packed></expected>
    <result>{txproc:runComplexSingleBranch()}</result>
  </test>
</testsuite>
)

(:
-- Local Variables:
-- compile-command: "../../../bin/test.sh all-xproc.xqy > ../../../report/all-xproc.html"
-- End:
:)
