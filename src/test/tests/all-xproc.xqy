xquery version "3.0";

import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";

import module namespace txproc = "txproc"
    at "txproc.xqy";

declare boundary-space preserve;
    
test:html(
<testsuite title="xproc module">
  <test name="xproc1" desc="parse module load">
    <expected>true</expected>
    <result>{txproc:loadModuleTest()}</result>
  </test>
  <test name="xproc2" desc="enum namespaces">
    <expected><namespace name=""><ns prefix="xml" URI="http://www.w3.org/XML/1998/namespace"></ns><ns prefix="p" URI="http://www.w3.org/ns/xproc"></ns><ns prefix="c" URI="http://www.w3.org/ns/xproc-step"></ns><ns prefix="cx" URI="http://xmlcalabash.com/ns/extensions"></ns><ns prefix="" URI=""></ns></namespace></expected>
    <result>{txproc:enumNSTest()}</result>
  </test>
  <test name="xproc3" desc="test getting step names">
    <expected>ext:pre p:identity p:count p:identity ext:post</expected>
    <result>{txproc:stepNamesTest()}</result>
  </test>
  <test name="xproc4a" desc="test entry point">
    <expected>true</expected>
    <result>{txproc:runEntryPointTest()}</result>
  </test>
  <!--test name="xproc4cb" desc="test entry point via HOX invoke">
    <expected>true</expected>
    <result>{txproc:runEntryPointTest2()}</result>
  </test-->
</testsuite>
)

(:
-- Local Variables:
-- compile-command: "../../../bin/test.sh all-xproc.xqy > ../../../report/all-xproc.html"
-- End:
:)
