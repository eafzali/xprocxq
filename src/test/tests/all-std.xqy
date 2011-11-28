xquery version "3.0";

import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";

import module namespace tstd = "tstd"
    at "tstd.xqy";


test:html(
<testsuite title="std step module">
  <test name="std1" desc="std module loading">
    <expected>true</expected>
    <result>{tstd:loadModuleTest()}</result>
  </test>
  <test name="std2" desc="std:identity step">
    <expected><test/></expected>
    <result>{tstd:testIdentity()}</result>
  </test>
  <test name="std3" desc="std:count step">
    <expected><c:result xmlns:c="http://www.w3.org/ns/xproc-step">1</c:result></expected>
    <result>{tstd:testCount()}</result>
  </test>
  <test name="std41" desc="std:count step with limit set">
    <expected><c:result xmlns:c="http://www.w3.org/ns/xproc-step">4</c:result></expected>
    <result>{tstd:testCount2()}</result>
  </test>
  <test name="std4b" desc="std:count step with limit set to 4">
    <expected><c:result xmlns:c="http://www.w3.org/ns/xproc-step">4</c:result></expected>
    <result>{tstd:testCount3()}</result>
  </test>
  <test name="std4c" desc="std:count step with limit set to 2">
    <expected><c:result xmlns:c="http://www.w3.org/ns/xproc-step">2</c:result></expected>
    <result>{tstd:testCount4()}</result>
  </test>
  <!--test name="std5" desc="std:error step, need to run on standalone">
    <expected></expected>
    <result>{tstd:testError()}</result>
  </test-->
  <test name="std6" desc="std:filter which uses p:input">
    <expected><a id="1"><b id="2">test</b></a></expected>
    <result>{tstd:testFilter()}</result>
  </test>
  <test name="std7" desc="std:delete, initial test of xsltmatchpattern">
    <expected><c>aaa</c></expected>
    <result>{tstd:testDelete()}</result>
  </test>
  <test name="std7a" desc="std:delete">
    <expected><c>aaa<a id="1"></a></c></expected>
    <result>{tstd:testDelete1()}</result>
  </test>
  <test name="std7b" desc="std:delete remove id attributes">
    <expected><c>aaa<a><b>test</b></a></c></expected>
    <result>{tstd:testDelete2()}</result>
  </test>
  <test name="std8" desc="std:add-attribute">
    <expected><c>aaa<a id="1"><b id="2" test=""test"">test</b></a></c></expected>
    <result>{tstd:testAddAttr()}</result>
  </test>
</testsuite>
)

(:
-- Local Variables:
-- compile-command: "../../../bin/test.sh all-std.xqy > ../../../report/all-std.html"
-- End:
:)

