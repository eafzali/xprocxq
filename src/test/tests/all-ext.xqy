xquery version "3.0";

import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";

import module namespace textensions = "textensions"
    at "textensions.xqy";
    
test:html(
<testsuite>
  <test name="general1" desc="demonstrates unit test system">
    <expected>true</expected>
    <result>{textensions:exampleTest()}</result>
  </test>
</testsuite>
)


