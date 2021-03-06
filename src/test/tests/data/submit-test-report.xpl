<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
		xmlns:c="http://www.w3.org/ns/xproc-step"
		xmlns:cx="http://xmlcalabash.com/ns/extensions"
		exclude-inline-prefixes="c cx"
		name="main" version="1.0">
<p:output port="result"/>
<p:option name="host" select="'tests.xproc.org'"/>
<p:option name="username" select="'calabash'"/>
<p:option name="password" select="''"/>

<p:documentation xmlns="http://www.w3.org/1999/xhtml">
<div>
  <p>This pipeline runs the XProc test suite and reports the results.</p>
  <p>It has three options: <code>host</code>, <code>username</code>, and
  <code>password</code>.</p>
  <p>The <code>host</code> option is used to specify the host to use
  in the URIs of test suite documents. (Because Norm has a local copy of
  <a href="http://tests.xproc.org/">http://tests.xproc.org/</a>.)</p>
  <p>The <code>username</code> and <code>password</code> are used to submit
  the test results to <a href="http://tests.xproc.org/">http://tests.xproc.org</a>.
  If run without a password, it simply outputs the report document.</p>
</div>
</p:documentation>

<p:string-replace match="uri/text()" name="patch-test-uris">
  <p:input port="source">
    <p:inline>
      <test-suites>
	<uri>/tests/required/test-suite.xml</uri>
	<uri>/tests/serialization/test-suite.xml</uri>
	<uri>/tests/optional/test-suite.xml</uri>
	<uri>/tests/extension/test-suite.xml</uri>
      </test-suites>
    </p:inline>
  </p:input>
  <p:with-option name="replace"
		 select="concat('concat(&quot;http://',$host,'&quot;,.)')">
    <p:empty/>
  </p:with-option>
</p:string-replace>

<p:identity name="extract-uri">
  <p:input port="source" select="/*/uri">
    <p:pipe step="patch-test-uris" port="result"/>
  </p:input>
</p:identity>

<p:choose>
  <p:xpath-context>
    <p:empty/>
  </p:xpath-context>
  <p:when test="$host = 'tests.xproc.org'">
    <p:wrap-sequence wrapper="test-suites">
      <p:input port="source">
	<p:pipe step="extract-uri" port="result"/>
	<!--
	<p:inline>
	  <uri>http://xmlcalabash.com/tests/test-suite.xml</uri>
	</p:inline>
	-->
      </p:input>
    </p:wrap-sequence>
  </p:when>
  <p:otherwise>
    <p:wrap-sequence wrapper="test-suites">
      <p:input port="source">
	<p:pipe step="extract-uri" port="result"/>
	<p:inline>
	  <uri>http://localhost:8130/tests/test-suite.xml</uri>
	</p:inline>
      </p:input>
    </p:wrap-sequence>
  </p:otherwise>
</p:choose>

<p:exec command="/projects/src/calabash/generate-test-report">
  <p:input port="source">
    <p:empty/>
  </p:input>
  <p:with-option name="args" select="string-join(//uri,' ')"/>
</p:exec>

<p:choose>
  <p:when test="$password = ''">
    <p:identity/>
  </p:when>
  <p:otherwise>
    <p:wrap wrapper="c:body" match="/">
      <p:input port="source" select="/c:result/*"/>
    </p:wrap>

    <p:add-attribute match="c:body"
		     attribute-name="content-type"
		     attribute-value="application/xml"/>

    <p:wrap wrapper="c:request" match="/"/>

    <p:add-attribute attribute-name="password" match="/c:request">
      <p:with-option name="attribute-value" select="$password"/>
    </p:add-attribute>

    <p:add-attribute attribute-name="username" match="/c:request">
      <p:with-option name="attribute-value" select="$username"/>
    </p:add-attribute>

    <p:add-attribute attribute-name="href" match="/c:request">
      <p:with-option name="attribute-value"
		     select="concat('http://',$host,'/results/submit/report')"/>
    </p:add-attribute>

    <p:set-attributes match="c:request">
      <p:input port="attributes">
	<p:inline>
	  <c:request method="post" auth-method="Basic"
		     send-authorization="true"/>
	</p:inline>
      </p:input>
    </p:set-attributes>

    <p:http-request/>
  </p:otherwise>
</p:choose>

</p:declare-step>
