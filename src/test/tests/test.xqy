xquery version "3.0";

declare function local:test($test){
$test
};
let $d := local:test#1
let $f := function(){1}
return
$d('adfafdadf')
