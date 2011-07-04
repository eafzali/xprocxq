xquery version "3.0";

import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";

import module namespace topt = "topt"
    at "topt.xqy";
    
test:html(
<testsuite title="opt step module">
  <test name="opt1" desc="opt module loading">
    <expected>true</expected>
    <result>{topt:loadModuleTest()}</result>
  </test>
</testsuite>
)

(:
-- Local Variables:
-- compile-command: "../../../bin/test.sh all-opt.xqy > ../../../report/all-opt.html"
-- End:
:)
