xquery version "3.0";

import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";

import module namespace tstd = "tstd"
    at "tstd.xqy";


test:html(
<testsuite title="std step module">
  <test name="std1" desc="std module loading">
    <expected>true</expected>
    <result>{tstd:loadModuleTest()}</result>
  </test>
  <test name="std2" desc="std:identity step">
    <expected><test/></expected>
    <result>{tstd:testIdentity()}</result>
  </test>
  <test name="std3" desc="std:count step">
    <expected><c:result xmlns:c="http://www.w3.org/ns/xproc-step">1</c:result></expected>
    <result>{tstd:testCount()}</result>
  </test>
  <test name="std41" desc="std:count step with limit set">
    <expected><c:result xmlns:c="http://www.w3.org/ns/xproc-step">4</c:result></expected>
    <result>{tstd:testCount2()}</result>
  </test>
  <test name="std4b" desc="std:count step with limit set to 4">
    <expected><c:result xmlns:c="http://www.w3.org/ns/xproc-step">4</c:result></expected>
    <result>{tstd:testCount3()}</result>
  </test>
  <test name="std4c" desc="std:count step with limit set to 2">
    <expected><c:result xmlns:c="http://www.w3.org/ns/xproc-step">2</c:result></expected>
    <result>{tstd:testCount4()}</result>
  </test>
  <!--test name="std5" desc="std:error step, need to run on standalone">
    <expected></expected>
    <result>{tstd:testError()}</result>
  </test-->
  <test name="std6" desc="std:filter which uses p:input">
    <expected><a id="1"><b id="2">test</b></a></expected>
    <result>{tstd:testFilter()}</result>
  </test>
  <test name="std7" desc="std:delete, initial test of xsltmatchpattern">
    <expected><c>aaa</c></expected>
    <result>{tstd:testDelete()}</result>
  </test>
  <test name="std7a" desc="std:delete">
    <expected><c>aaa<a id="1"></a></c></expected>
    <result>{tstd:testDelete1()}</result>
  </test>
  <test name="std7b" desc="std:delete remove id attributes">
    <expected><c>aaa<a><b>test</b></a></c></expected>
    <result>{tstd:testDelete2()}</result>
  </test>
  <test name="std8" desc="std:add-attribute">
    <expected><c>aaa<a id="1"><b id="2" test="test">test</b></a></c></expected>
    <result>{tstd:testAddAttr()}</result>
  </test>
  <test name="std9" desc="std:string-replace">
    <expected><c>aaa<a id="1"><b id="2">aaaa</b></a></c></expected>
    <result>{tstd:testStringReplace()}</result>
  </test>
  <test name="std10" desc="std:wrap">
    <expected><c>aaa<a id="1"><aaaa><b id="2">test</b></aaaa></a></c></expected>
    <result>{tstd:testWrap()}</result>
  </test>
  <test name="std11" desc="std:wrap-sequence">
    <expected><c>aaa<a id="1"><aaaa><b id="2">test</b></aaaa></a></c><a><aaaa><b>aaa</b></aaaa></a></expected>
    <result>{tstd:testWrapSequence()}</result>
  </test>
  <test name="std12" desc="std:unwrap">
    <expected><c>aaa<a id="1">test</a></c></expected>
    <result>{tstd:testUnwrap()}</result>
  </test>
  <test name="std12a" desc="std:unwrap">
    <expected><c>aaa<a id="1">testalternate</a></c></expected>
    <result>{tstd:testUnwrap1()}</result>
  </test>
  <test name="std13" desc="std:rename renaming element b to newname">
    <expected><c>aaa<a id="1"><newname id="2">test</newname><newname>alternate</newname></a></c></expected>
    <result>{tstd:testRename()}</result>
  </test>
  <test name="std13a" desc="std:rename renaming attribute id to newid">
    <expected><c>aaa<a newid="1"><b newid="2">test</b><b>alternate</b></a></c></expected>
    <result>{tstd:testRename1()}</result>
  </test>
  <test name="std14" desc="std:label-elements">
    <expected><c>aaa<a newid="1"><b newid="2">test</b><b>alternate</b></a></c></expected>
    <result>{tstd:testLabelElements()}</result>
  </test>
</testsuite>
)

(:
-- Local Variables:
-- compile-command: "../../../bin/test.sh all-std.xqy > ../../../report/all-std.html"
-- End:
:)

