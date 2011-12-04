xquery version "3.0";

(: w3c test runner :)

declare boundary-space strip;
 declare copy-namespaces no-preserve,no-inherit;

declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";
declare namespace ext ="http://xproc.net/xproc/ext";
declare namespace t="http://xproc.org/ns/testsuite";
declare namespace test="http://xproc.org/ns/testsuite";

import module namespace xproc = "http://xproc.net/xproc" at "../../src/xquery/xproc.xqm";

import module namespace test1 = "http://www.marklogic.com/test"
    at "lib/test.xqm";

test1:html(
<testsuite title="w3c required and optional tests">
{
for $test in collection("tests.xproc.org/required?select=*.xml")
 let $pipeline := $test/t:test/t:pipeline/*
 let $stdin    := $test/t:test/t:input[@port eq 'source']/*
 let $expected := $test/t:test/t:output/*
 let $dflag    := 0
 let $tflag    := 0
 let $bindings := ()
 let $options  := ()
 let $outputs  := ()
return

<test name="" desc="{$test//t:title}">
<input port="source">
{$stdin}
</input>
<pipeline>
{$pipeline}
</pipeline>
<expected>
{$expected}
</expected>
<result>
{
try{
  $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
} catch * {
<error/>
}
}
</result>
</test>

}

{
for $test in collection("tests.xproc.org/optional?select=*.xml")
 let $pipeline := $test/t:test/t:pipeline/*
 let $stdin    := $test/t:test/t:input[@port eq 'source']/*
 let $expected := $test/t:test/t:output/*
 let $dflag    := 0
 let $tflag    := 0
 let $bindings := ()
 let $options  := ()
 let $outputs  := ()
return

<test name="" desc="{$test//t:title}">
<input port="source">
{$stdin}
</input>
<pipeline>
{$pipeline}
</pipeline>
<expected>
{$expected}
</expected>
<result>
{
try{
  $xproc:run-step($pipeline,$stdin,$bindings,$options,$outputs,$dflag,$tflag)
} catch * {
<error/>
}
}
</result>
</test>

}

</testsuite>
)
