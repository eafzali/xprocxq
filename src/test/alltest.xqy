xquery version "3.0";

(: w3c test runner :)

declare boundary-space strip;
declare copy-namespaces no-preserve,no-inherit;

declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace ext ="http://xproc.net/xproc/ext";
declare namespace t="http://xproc.org/ns/testsuite";
declare namespace test="http://xproc.org/ns/testsuite";

declare namespace err="http://www.w3.org/2005/xqt-errors";

import module namespace xproc = "http://xproc.net/xproc" at "../../src/xquery/xproc.xqm";
import module namespace u = "http://xproc.net/xproc/util" at "../../src/xquery/util.xqm";

import module namespace test1 = "http://www.marklogic.com/test"
    at "lib/test.xqm";

 test1:html(
<testsuite title="w3c required and optional tests" xmlns:xqyerr="http://www.w3.org/2005/xqt-errors">
{
for $test in collection("tests.xproc.org/required?select=*.xml")
 let $pipeline  := if($test/t:test/t:pipeline/@href) then doc(concat("tests.xproc.org/required/",$test/t:test/t:pipeline/@href)) else $test/t:test/t:pipeline/*
 let $stdin     := if($test/t:test/t:input[@port eq 'source']/t:document) then (for $doc in $test/t:test/t:input[@port eq 'source']/t:document/* return $doc) else ($test/t:test/t:input[@port eq 'source']/*)
 let $expected  := if($test/t:test/t:output/t:document) then (for $doc in $test/t:test/t:output/t:document return $doc/*) else $test/t:test/t:output/*
 let $error  as xs:string  := string($test//@*:error)
 let $err := if (starts-with($error,'err:') and $error ne 'test') then xs:QName($error) else '*'
 let $dflag     := 0
 let $tflag     := 0
 let $bindings  := ()
 let $options   := ()
 let $outputs   := (

for $output in $test/t:test/t:input[@port ne 'source']
return
<xproc:output port="{$output/@port}" primary="false" port-type="external" func="" xproc:default-name="!1" step="!1">{
if ($output/t:document) then for $doc in $output/t:document return $doc/node() else $output/node()
}</xproc:output>
)
return

if ($error) then
()
else
<test name="" desc="{$test//t:title}">
<input port="source">
{$stdin}
</input>
<pipeline>
{$pipeline}
</pipeline>
<error>{$error}</error>
<expected>{if ($expected) then try{u:strip-whitespace(document{$expected})} catch * {
<err/>
} else ()}</expected>
<result>{
let $result := try{ $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)} catch * {<error type="{$error}">{$outputs}</error>}
return
u:strip-whitespace(document{$result})
}
</result>
</test>

}

{

for $test in collection("tests.xproc.org/optional?select=*.xml1")
 let $pipeline := $test/t:test/t:pipeline/*
 let $stdin    := $test/t:test/t:input[@port eq 'source']/*
 let $expected := $test/t:test/t:output/*
 let $error    := string($test/@error)
 let $dflag    := 0
 let $tflag    := 0
 let $bindings := ()
 let $options  := ()
 let $outputs   := (

for $output in $test/t:test/t:input[@port ne 'source']
return
<xproc:output port="{$output/@port}" primary="false" port-type="external" func="" xproc:default-name="!1" step="!1">{
if ($output/t:document) then for $doc in $output/t:document return $doc/node() else $output/node()
}</xproc:output>

)


return
if ($error) then
()
else
<test name="" desc="{$test//t:title}">
<input port="source">
{$stdin}
</input>
<pipeline>
{$pipeline}
</pipeline>
<expected>{if ($expected) then try{u:strip-whitespace($expected)} catch * {<error/>} else ()}</expected>
<result>{
u:strip-whitespace(document{
try{
  $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
} catch * {<error/>
}

})

}</result>
</test>


}
</testsuite>
)
