xquery version "3.0";

import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";

import module namespace tstd = "tstd"
    at "tstd.xqy";
    
test:html(
<testsuite test="std step module">
  <test name="std1" desc="std module loading">
    <expected>true</expected>
    <result>{tstd:loadModuleTest()}</result>
  </test>
</testsuite>
)


