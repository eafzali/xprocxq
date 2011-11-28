<?xml version="1.0"?>
<p:declare-step version="1.0" xmlns:p="http://www.w3.org/ns/xproc">
<p:input port="source"/>
<p:output port="result"/>

<p:identity/>
<p:filter select="/c/a"/>
<p:wrap match="/" wrapper="newwrapper"/>
<p:unwrap match="b"/>
<p:rename match="//@id" new-name="new-id"/>
<p:string-replace match="@new-id" replace="'this is new text'"/>

</p:declare-step>
