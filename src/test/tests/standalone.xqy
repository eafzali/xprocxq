xquery version "3.0";

declare namespace map="http://ns.saxonica.com/map";

let $map := map:new()
let $dummy := map:put($map,'test','aaaaaaaaaaa')
return
map:keys($dummy)

