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
  <test name="xproc2a" desc="test explicit naming parsing">
    <expected>true</expected>
    <result>{txproc:parseExplicitNames()}</result>
  </test>
  <test name="xproc2b" desc="test explicit naming parsing">
    <expected>true</expected>
    <result>{txproc:parseExplicitNames1()}</result>
  </test>
  <test name="xproc2c" desc="test explicit naming parsing">
    <expected>true</expected>
    <result>{txproc:parseExplicitNames2()}</result>
  </test>
  <test name="xproc3a" desc="test explicit naming parsing adds xproc: namespace">
    <expected>true</expected>
    <result>{txproc:addXprocNamespace()}</result>
  </test>
  <test name="xproc3b" desc="test explicit naming parsing adds p: namespace">
    <expected>true</expected>
    <result>{txproc:addXprocNamespace1()}</result>
  </test>

  <test name="xproc4a" desc="test parse:type returns correct type">
    <expected>true</expected>
    <result>{txproc:testParseType1()}</result>
  </test>
  <test name="xproc4b" desc="test parse:type returns correct type">
    <expected>true</expected>
    <result>{txproc:testParseType2()}</result>
  </test>
  <test name="xproc4c" desc="test parse:type returns correct type">
    <expected>true</expected>
    <result>{txproc:testParseType3()}</result>
  </test>
  <test name="xproc4d" desc="test parse:type returns correct type">
    <expected>true</expected>
    <result>{txproc:testParseType4()}</result>
  </test>
  <test name="xproc5" desc="test parse:type returns correct type">
    <expected>true</expected>
    <result>{txproc:testParseType5()}</result>
  </test>
  <test name="xproc6" desc="test parse:type returns correct error type">
    <expected>true</expected>
    <result>{txproc:testParseType6()}</result>
  </test>
  <test name="xproc7a" desc="test parse:explicit-name with p:choose">
    <expected>true</expected>
    <result>{txproc:testExplicitName()}</result>
  </test>
  <test name="xproc7b" desc="test parse:explicit-name with p:group">
    <expected>true</expected>
    <result>{txproc:testExplicitName()}</result>
  </test>
  <test name="xproc7b" desc="test parse:explicit-name with p:viewport">
    <expected>true</expected>
    <result>{txproc:testExplicitName()}</result>
  </test>

</testsuite>
)


