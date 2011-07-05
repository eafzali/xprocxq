xquery version "3.0";

import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";

import module namespace txproc = "txproc"
    at "txproc.xqy";

declare boundary-space preserve;
    
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
    <expected>{fn:doc('data/xproc2aresult.xml')}</expected>
    <result>{txproc:parseExplicitNames()}</result>
  </test>
 <test name="xproc2b" desc="test explicit naming parsing">
    <expected>{fn:doc('data/xproc2bresult.xml')}</expected>
    <result>{txproc:parseExplicitNames1()}</result>
  </test>
  <test name="xproc2c" desc="test explicit naming parsing">
    <expected>{fn:doc('data/xproc2cresult.xml')}</expected>
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
    <expected>error</expected>
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
  <test name="xproc7a" desc="test parse:explicit-name">
    <expected>{fn:doc('data/xproc7aresult.xml')}</expected>
    <result>{txproc:testExplicitName1()}</result>
  </test>
  <test name="xproc7b" desc="test parse:explicit-name with p:choose">
    <expected>{fn:doc('data/xproc7bresult.xml')}</expected>
    <result>{txproc:testExplicitName()}</result>
  </test>
  <test name="xproc7c" desc="test parse:explicit-name with p:group">
    <expected>{fn:doc('data/xproc7cresult.xml')}</expected>
    <result>{txproc:testExplicitName()}</result>
  </test>
  <test name="xproc7d" desc="test parse:explicit-name with p:viewport">
    <expected>{fn:doc('data/xproc7dresult.xml')}</expected>
    <result>{txproc:testExplicitName()}</result>
  </test>

  <test name="xproc8a" desc="test parse:AST">
    <expected>{fn:doc('data/xproc8aresult.xml')}</expected>
    <result>{txproc:testAST()}</result>
  </test>

  <test name="xproc8b" desc="test parse:AST1">
    <expected>{fn:doc('data/xproc8aresult.xml')}</expected>
    <result>{txproc:testAST1()}</result>
  </test>

  <test name="xproc9a" desc="test parse:explicit-bindings">
    <expected>{fn:doc('data/xproc9aresult.xml')}</expected>
    <result>{txproc:testExplicitBindings1()}</result>
  </test>

  <test name="xproc9b" desc="test parse:explicit-bindings">
    <expected>{fn:doc('data/9bresult.xml')}</expected>
    <result>{txproc:testExplicitBindings2()}</result>
  </test>

  <test name="xproc9c" desc="test parse:explicit-bindings">
    <expected>{fn:doc('data/xproc9cresult.xml')}</expected>
    <result>{txproc:testExplicitBindings3()}</result>
  </test>

</testsuite>
)

(:
-- Local Variables:
-- compile-command: "../../../bin/test.sh all-xproc.xqy > ../../../report/all-xproc.html"
-- End:
:)
