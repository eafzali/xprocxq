xquery version "1.0";

import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";


import module namespace tconst = "tconst"
    at "tconst.xqy";

test:html(
<testsuite title="const module">
  <test name="const1" desc="load constant module">
    <expected>true</expected>
    <result>{tconst:loadModuleTest()}</result>
  </test>
  <test name="const2" desc="check version">
    <expected>true</expected>
    <result>{tconst:checkVersion()}</result>
  </test>
  <test name="const3" desc="check product version">
    <expected>true</expected>
    <result>{tconst:checkProductVersion()}</result>
  </test>
  <test name="const4" desc="check product name">
    <expected>true</expected>
    <result>{tconst:checkProductVersioName()}</result>
  </test>
  <test name="const5" desc="check vendor">
    <expected>true</expected>
    <result>{tconst:checkVendor()}</result>
  </test>
  <test name="const6" desc="check language">
    <expected>true</expected>
    <result>{tconst:checkLanguage()}</result>
  </test>
  <test name="const7" desc="check vendor uri">
    <expected>true</expected>
    <result>{tconst:checkVendorURI()}</result>
  </test>
  <test name="const8" desc="check supported xpath version">
    <expected>true</expected>
    <result>{tconst:checkXpathVersion()}</result>
  </test>
  <test name="const9" desc="check if psvi is supported">
    <expected>true</expected>

    <result>{tconst:checkPsviSupported()}</result>
  </test>
  <test name="const10" desc="check error codes">
    <expected>true</expected>
    <result>{tconst:checkXprocErrorCodes()}</result>
  </test>
  <test name="const11" desc="check xprocxq error codes">
    <expected>true</expected>
    <result>{tconst:checkXprocXQErrorCodes()}</result>
  </test>

</testsuite>
)


