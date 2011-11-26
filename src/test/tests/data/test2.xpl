<?xml version="1.0"?>
<p:declare-step version="1.0" name="main" xmlns:p="http://www.w3.org/ns/xproc">
<p:input port="source">
  <p:inline><doc>
Congratulations! You've run your first pipeline!
</doc></p:inline>
</p:input>
<p:output port="result">
  <p:pipe step="step3" port="result"/>
</p:output>

<p:identity name="step1"/>

<p:identity name="step3">
  <p:input port="source">
    <p:pipe port="result" step="step2"/>
  </p:input>
</p:identity>

<!--p:sink/-->

<p:count limit="20" name="step2">
<p:input port="source">
  <p:pipe step="step1" port="result"/>
</p:input>
</p:count>

</p:declare-step>
