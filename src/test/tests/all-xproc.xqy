xquery version "3.0";

import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";

import module namespace txproc = "txproc"
    at "txproc.xqy";
    
test:html(
<testsuite title="xprocxq main module">
  <test name="xproc1" desc="xproc module load">
    <expected>true</expected>
    <result>{txproc:loadModuleTest()}</result>
  </test>
  <test name="xproc1a" desc="test entry point">
    <expected>true</expected>
    <result>{txproc:runEntryPointTest()}</result>
  </test>
  <test name="xproc1b" desc="test entry point via HOX invoke">
    <expected>true</expected>
    <result>{txproc:runEntryPointTest2()}</result>
  </test>
</testsuite>
)


