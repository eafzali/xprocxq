<?xml version="1.0"?>
<p:declare-step version="1.0" xmlns:p="http://www.w3.org/ns/xproc">
<p:input port="source"/>
<p:output port="result"/>
<p:identity name="a"/>
<p:filter select="/c/a">
<p:input port="source">
  <p:pipe port="result" step="a"/>
</p:input>
</p:filter>
<p:wrap match="/" wrapper="newwrapper"/>
<p:rename match="@id" new-name="new-id"/>
<p:string-replace match="@new-id" replace="&quot;this is a new string&quot;"/>
<p:delete match="b"/>
<p:pack wrapper="packed">
     <p:input port="alternate">
       <p:inline>
         <a>test</a>
       </p:inline>
     </p:input>
</p:pack>
</p:declare-step>
