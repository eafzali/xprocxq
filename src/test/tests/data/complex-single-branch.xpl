<?xml version="1.0"?>
<p:declare-step version="1.0" xmlns:p="http://www.w3.org/ns/xproc">
<p:input port="source"/>
<p:output port="result"/>
<p:identity name="a"/>
<p:filter select="/c/a"/>
<p:wrap match="/" wrapper="newwrapper"/>
<p:rename match="@id" new-name="new-id"/>
<p:pack wrapper="packed">
     <p:input port="alternate">
       <p:inline>
         <a>test</a>
       </p:inline>
     </p:input>
</p:pack>
</p:declare-step>
