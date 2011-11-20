xquery version "3.0";

import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";

import module namespace tparse = "tparse"
    at "tparse.xqy";

declare boundary-space preserve;
    
test:html(
<testsuite title="parse module">
  <test name="parse1" desc="parse module load">
    <expected>true</expected>
    <result>{tparse:loadModuleTest()}</result>
  </test>
  <test name="parse1a" desc="test entry point">
    <expected>true</expected>
    <result>{tparse:runEntryPointTest()}</result>
  </test>
  <test name="parse1b" desc="test entry point via HOX invoke">
    <expected>true</expected>
    <result>{tparse:runEntryPointTest2()}</result>
  </test>
  <test name="parse2a" desc="test explicit naming parsing">
    <expected>{fn:doc('data/parse2aresult.xml')}</expected>
    <result>{tparse:parseExplicitNames()}</result>
  </test>
 <test name="parse2b" desc="test explicit naming parsing">
    <expected>{fn:doc('data/parse2bresult.xml')}</expected>
    <result>{tparse:parseExplicitNames1()}</result>
  </test>
  <test name="parse2c" desc="test explicit naming parsing">
    <expected>{fn:doc('data/parse2cresult.xml')}</expected>
    <result>{tparse:parseExplicitNames2()}</result>
  </test>
  <test name="parse3a" desc="test explicit naming parsing adds parse: namespace">
    <expected>true</expected>
    <result>{tparse:addParseNamespace()}</result>
  </test>
  <test name="parse3b" desc="test explicit naming parsing adds p: namespace">
    <expected>true</expected>
    <result>{tparse:addParseNamespace1()}</result>
  </test>
  <test name="parse4a" desc="test parse:type returns correct type">
    <expected>true</expected>
    <result>{tparse:testParseType1()}</result>
  </test>
  <test name="parse4b" desc="test parse:type returns correct type">
    <expected>error</expected>
    <result>{tparse:testParseType2()}</result>
  </test>
  <test name="parse4c" desc="test parse:type returns correct type">
    <expected>true</expected>
    <result>{tparse:testParseType3()}</result>
  </test>
  <test name="parse4d" desc="test parse:type returns correct type">
    <expected>true</expected>
    <result>{tparse:testParseType4()}</result>
  </test>
  <test name="parse5" desc="test parse:type returns correct type">
    <expected>true</expected>
    <result>{tparse:testParseType5()}</result>
  </test>
  <test name="parse6" desc="test parse:type returns correct error type">
    <expected>true</expected>
    <result>{tparse:testParseType6()}</result>
  </test>
  <test name="parse7" desc="test parse:explicit-type">
    <expected>{fn:doc('data/parse7result.xml')}</expected>
    <result>{tparse:parseExplicitNames()}</result>2
  </test>
  <test name="parse7a" desc="test parse:explicit-type">
    <expected>{fn:doc('data/parse7aresult.xml')}</expected>
    <result>{tparse:testExplicitName1()}</result>
  </test>
  <test name="parse7b" desc="test parse:explicit-type with p:choose">
    <expected>{fn:doc('data/parse7bresult.xml')}</expected>
    <result>{tparse:testExplicitName()}</result>
  </test>

  <!--test name="parse7c" desc="test parse:explicit-name with p:group">
    <expected>{fn:doc('data/parse7cresult.xml')}</expected>
    <result>{tparse:testExplicitName()}</result>
  </test>

  <test name="parse7d" desc="test parse:explicit-name with p:viewport">
    <expected>{fn:doc('data/parse7dresult.xml')}</expected>
    <result>{tparse:testExplicitName()}</result>
  </test-->

  <test name="parse8a" desc="test parse:AST">
    <expected>{fn:doc('data/parse8aresult.xml')}</expected>
    <result>{tparse:testAST()}</result>
  </test>

  <test name="parse8b" desc="test parse:AST1">
    <expected>{fn:doc('data/parse8bresult.xml')}</expected>
    <result>{tparse:testAST1()}</result>
  </test>

  <test name="parse9a" desc="test parse:explicit-bindings">
    <expected>{fn:doc('data/parse9aresult.xml')}</expected>
    <result>{tparse:testExplicitBindings1()}</result>
  </test>

  <test name="parse9b" desc="test parse:explicit-bindings with nested group">
    <expected>{fn:doc('data/parse9bresult.xml')}</expected>
    <result>{tparse:testExplicitBindings2()}</result>
  </test>

  <test name="parse9c" desc="test parse:explicit-bindings with nested group">
    <expected>{fn:doc('data/parse9cresult.xml')}</expected>
    <result>{tparse:testExplicitBindings3()}</result>
  </test>

  <test name="parse9d" desc="test parse:explicit-bindings with explicit ports">
    <expected>{fn:doc('data/parse9dresult.xml')}</expected>
    <result>{tparse:testExplicitBindings4()}</result>
  </test>

  <test name="parse10a" desc="test step sorting">
    <expected>{fn:doc('data/parse10aresult.xml')}</expected>
    <result>{tparse:testStepSort1()}</result>
  </test>

</testsuite>
)

(:
-- Local Variables:
-- compile-command: "../../../bin/test.sh all-parse.xqy > ../../../report/all-parse.html"
-- End:
:)
