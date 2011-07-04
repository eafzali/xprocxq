xquery version "3.0";

import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";

import module namespace textensions = "textensions"
    at "textensions.xqy";
    
test:html(
<testsuite title="extension step module">
  <test name="ext1" desc="load extension module">
    <expected>true</expected>
    <result>{textensions:loadModuleTest()}</result>
  </test>
</testsuite>
)


(:
-- Local Variables:
-- compile-command: "../../../bin/test.sh all-ext.xqy > ../../../report/all-ext.html"
-- End:
:)
