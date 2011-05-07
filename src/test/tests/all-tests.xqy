xquery version "3.0";

import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";

import module namespace tgeneral = "tgeneral"
    at "tgeneral.xqy";
    
test:html(
<testsuite>
  <test name="general1" desc="demonstrates unit test system">
    <expected>true</expected>
    <result>{tgeneral:exampleTest()}</result>
  </test>

  <test name="general2" desc="test entry point">
    <expected>true</expected>
    <result>{tgeneral:runEntryPointTest()}</result>
  </test>

</testsuite>
)


