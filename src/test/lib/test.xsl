<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="saxon"
                version="2.0">
<xsl:strip-space elements="result expected"/> 
  <xsl:output omit-xml-declaration="yes" method="html" encoding="utf-8" indent="yes" />
  <xsl:output name="default" indent="yes" omit-xml-declaration="yes"/>
  <xsl:param name="title"/>
  <xsl:variable name="total" select="count(//*:test)"/>
  <xsl:variable name="pass" select="count(//*:test[deep-equal(result/node(),expected/node())])"/>
  <xsl:variable name="fail" select="count(//*:test[not(deep-equal(result/node(),expected/node()))])"/>
  <xsl:template match="/">
    <html>
      <head>
        <meta http-equiv="Pragma" content="No-cache"/>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <title><xsl:value-of select="$title"/></title> 
        <style type="text/css">
          body {
          font-family: Helvetica;
          padding: 0.5em  1em;
          }
          pre {
          font-family: Inconsolata, Consolas, monospace;
          }
          ol.results {
          padding-left: 0;
          }
          .result {
          border-top: solid 4px;
          padding: 0.25em 0.5em;
          font-size: 85%;
          }
          .footer {
          border-top: solid 4px;
          padding: 0.25em 0.5em;
          font-size: 85%;
          color: #999;
          }
          li.result {
          list-style-position: inside;
          list-style: none;
          height:340;
          }
          .result h3 {
          font-weight: normal;
          font-size: inherit;
          margin: 0;
          }
          .result.fail h3 {
          color: red;
          }
          .pass {
          border-color: green;
          }
          .fail {
          border-color: red;
          }
          h2 {
          display: inline-block;
          margin: 0;
          }
          h2+div.stats {
          display: inline-block;
          margin-left: 1em;
          }
          strong.fail, 
          h2.fail {
          border: none;
          color: red;
          }
          h2.fail:before {
          content: "✘ ";
          }
          h2.pass:before {
          content: "✔ ";
          }
          h2 a,
          .result h3 a {
          text-decoration: inherit;
          color: inherit;
          }
          .fail .message {
          font-weight: bold;
          }
          .namespace {
          margin-left: 1em;
          color: #999;
          }
          .namespace:before {
          content: "(";
          }
          .namespace:after {
          content: ")";
          }
          table{
          width:75%;
          float:right;
          }
          td {
          height:100px;
          width:50%;
          vertical-align:text-top;
          }
        </style>
        <link href="resource/prettify/prettify.css" type="text/css" rel="stylesheet" />
        <script type="text/javascript" src="resource/prettify/prettify.js">&#160;</script>
      </head>
      <body onload="prettyPrint()">
        
        <p> <strong><xsl:value-of select="round((1 - (xs:integer($fail) div
        xs:integer($pass + $fail))) * 100)"/>% pass rate: </strong><strong class="fail"><xsl:value-of select="$fail"/></strong> failed tests and <strong><xsl:value-of select="$pass"/></strong> passed tests.</p>
          <xsl:apply-templates/>
        <br/><br/>
        <div class="footer"><p style="text-align:right"><i><xsl:value-of select="current-dateTime()"/></i></p></div>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="*:testsuite">
    <h2><xsl:value-of select="(@name|@title)"/></h2>
    <ol class="results">
      <xsl:apply-templates/>
    </ol>
  </xsl:template>

  <xsl:template match="*:test">
    <li class="result {if (expected eq result) then 'pass' else 'fail'}">
      <h3><input name="test" value="" type="checkbox" checked="checked"></input>
      <a href="?test="><xsl:value-of select="@name"/> <span class="namespace"><xsl:value-of select="@desc"/></span></a>
      <table>
        <tbody><tr>
          <td>
            <pre style="border: 1px solid #888;padding: 2px"
><textarea rows="20" cols="60"><xsl:copy-of
                                               select="expected"/></textarea></pre>
          </td>
          <td>
            <pre style="border: 1px solid #888;padding: 2px"
><textarea rows="20" cols="60"><xsl:copy-of
                                               select="result"/></textarea></pre>
          </td>
        </tr>
        </tbody>
      </table>
      </h3><br/>
    </li>
  </xsl:template>
  <xsl:template match="*:test[not(deep-equal(expected/node(),result/node()))]">
    <li class="result fail">
      <h3 ><input name="test" value="" type="checkbox" checked="checked"></input>
      <a href="?test="><xsl:value-of select="@name"/><br/> <span
      > <xsl:value-of select="@desc"/></span></a>
      <table>
        <tbody>
          <tr>
          <td>
            <pre style="border: 1px solid #888;padding: 2px"
><textarea rows="20" cols="60"><xsl:copy-of
                                               select="expected"/></textarea></pre>
          </td>
          <td>
            <pre style="border: 1px solid #888;padding: 2px"
><textarea rows="20" cols="60"><xsl:copy-of
                                               select="result"/></textarea></pre>
          </td>
        </tr>
        </tbody>
      </table>
      </h3><br/>
    </li>
  </xsl:template>
  <xsl:template match="*:test[deep-equal(expected/node(),result/node())]">
    <li class="result pass">
      <h3><input name="test" value="" type="checkbox" checked="checked"></input>
      <a href="?test="><xsl:value-of select="@name"/> <span class="namespace"><xsl:value-of select="@desc"/></span></a>
      <table>
        <tbody><tr>
          <td>
            <pre style="border: 1px solid #888;padding: 2px"
><textarea rows="20" cols="60"><xsl:copy-of
                                               select="expected"/></textarea></pre>
          </td>
          <td>
            <pre style="border: 1px solid #888;padding: 2px"
><textarea rows="20" cols="60"><xsl:copy-of
                                               select="result"/></textarea></pre>
          </td>
        </tr>
        </tbody>
      </table>
      </h3><br/>
    </li>
  </xsl:template>

<xsl:template match="text()"/>
</xsl:stylesheet>
