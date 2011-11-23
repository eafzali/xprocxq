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

</testsuite>
)

(:
-- Local Variables:
-- compile-command: "../../../bin/test.sh all-std.xqy > ../../../report/all-std.html"
-- End:
:)

