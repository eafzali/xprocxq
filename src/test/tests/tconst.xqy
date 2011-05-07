xquery version "3.0";

module namespace tconst ="tconst";

import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";

import module namespace const = "http://xproc.net/xproc/const" at "../../xquery/const.xqm";

declare function (:TEST:) tconst:loadModuleTest() { 
  test:assertStringEqual($const:init_unique_id, '!1')
};

declare function (:TEST:) tconst:checkVersion() { 
  test:assertStringEqual($const:version, '0.9')
};

declare function (:TEST:) tconst:checkProductVersion() { 
  test:assertStringEqual($const:product-version, '0.9')
};

declare function (:TEST:) tconst:checkProductVersioName() { 
  test:assertStringEqual($const:product-name, 'xprocxq')
};

declare function (:TEST:) tconst:checkVendor() { 
  test:assertStringEqual($const:vendor, 'James Fuller')
};

declare function (:TEST:) tconst:checkLanguage() { 
  test:assertStringEqual($const:language, 'en')
};

declare function (:TEST:) tconst:checkVendorURI() { 
  test:assertStringEqual($const:vendor-uri, 'http://www.xproc.net')
};

declare function (:TEST:) tconst:checkXpathVersion() { 
  test:assertStringEqual($const:xpath-version, '2.0')
};

declare function (:TEST:) tconst:checkPsviSupported() { 
  test:assertStringEqual($const:psvi-supported, 'false')
};

declare function (:TEST:) tconst:checkXprocErrorCodes() { 
  test:assertXMLEqual($const:error, <error-list xmlns="http://www.w3.org/ns/xproc-error">
   <error code="XC0002">It is a dynamic error if the value starts with the string “--”.</error>
   <error code="XC0003">It is a dynamic error if a username or password is specified without specifying an auth-method, if the requested auth-method isn't supported, or the authentication challenge contains an authentication method that isn't supported.</error>
   <error code="XC0004">It is a dynamic error if the status-only attribute has the value true and the detailed attribute does not have the value true.</error>
   <error code="XC0005">It is a dynamic error if the request contains a c:body or c:multipart but the method does not allow for an entity body being sent with the request.</error>
   <error code="XC0006">It is a dynamic error if the method is not specified on a c:request.</error>

   <error code="XC0010">It is a dynamic error if an encoding of base64 is specified and the character set is not specified or if the specified character set is not supported by the implementation.</error>
   <error code="XC0012">It is a dynamic error if the contents of the directory path are not available to the step due to access restrictions in the environment in which the pipeline is run.</error>
   <error code="XC0013">It is a dynamic error if the pattern matches a processing instruction and the new name has a non-null namespace.</error>
   <error code="XC0014">It is a dynamic error if the XML namespace (http://www.w3.org/XML/1998/namespace) or the XMLNS namespace (http://www.w3.org/2000/xmlns/) is the value of either the from option or the to option.</error>
   <error code="XC0017">It is a dynamic error if the absolute path does not identify a directory.</error>
   <error code="XC0019">It is a dynamic error if the documents are not equal, and the value of the fail-if-not-equal option is true.</error>

   <error code="XC0020">It is a dynamic error if the the user specifies a value or values that are inconsistent with each other or with the requirements of the step or protocol.</error>
   <error code="XC0022">it is a dynamic error if the content of the c:body element does not consist of exactly one element, optionally preceded and/or followed by any number of processing instructions, comments or whitespace characters</error>
   <error code="XC0023">It is a dynamic error if a select expression or match pattern returns a node type that is not allowed by the step.</error>
   <error code="XC0025">It is a dynamic error if the match pattern matches anything other than an element node and the value of the position option is “first-child” or “last-child”.</error>
   <error code="XC0027">It is a dynamic error if the document is not valid or the step doesn't support DTD validation.</error>
   <error code="XC0028">it is a dynamic error if the content of the c:body element does not consist entirely of characters</error>

   <error code="XC0029">It is a dynamic error if an XInclude error occurs during processing.</error>
   <error code="XC0030">It is a dynamic error if the override-content-type value cannot be used (e.g. text/plain to override image/png).</error>
   <error code="XC0033">It is a dynamic error if the command cannot be run.</error>
   <error code="XC0034">It is a dynamic error if the current working directory cannot be changed to the value of the cwd option.</error>
   <error code="XC0035">It is a dynamic error to specify both result-is-xml and wrap-result-lines.</error>
   <error code="XC0036">It is a dynamic error if the requested hash algorithm is not one that the processor understands or if the value or parameters are not appropriate for that algorithm.</error>

   <error code="XC0037">It is a dynamic error if the value provided is not a properly x-www-form-urlencoded value.</error>
   <error code="XC0038">It is a dynamic error if the specified version of XSLT is not available.</error>
   <error code="XC0039">It is a dynamic error if a sequence of documents (including an empty sequence) is provided to an XSLT 1.0 step.</error>
   <error code="XC0040">It is a dynamic error if the document element of the document that arrives on the source port is not c:request.</error>
   <error code="XC0050">It is a dynamic error if the URI scheme is not supported or the step cannot store to the specified location.</error>
   <error code="XC0051">It is a dynamic error if the content-type specified is not supported by the implementation.</error>

   <error code="XC0052">It is a dynamic error if the encoding specified is not supported by the implementation.</error>
   <error code="XC0053">It is a dynamic error if the assert-valid option is true and the input document is not valid.</error>
   <error code="XC0054">It is a dynamic error if the assert-valid option is true and any Schematron assertions fail.</error>
   <error code="XC0055">It is a dynamic error if the implementation does not support the specified mode.</error>
   <error code="XC0056">It is a dynamic error if the specified initial mode or named template cannot be applied to the specified stylesheet.</error>
   <error code="XC0057">It is a dynamic error if the sequence that results from evaluating the XQuery contains items other than documents and elements.</error>

   <error code="XC0058">It is a dynamic error if the all and relative options are bothtrue.</error>
   <error code="XC0059">It is a dynamic error if the QName value in the attribute-name option uses the prefix “xmlns” or any other prefix that resolves to the namespace name “http://www.w3.org/2000/xmlns/”.</error>
   <error code="XC0060">It is a dynamic error if the processor does not support the specified version of the UUID algorithm.</error>
   <error code="XC0061">It is a dynamic error if the name of any encoded parameter name is not a valid xs:NCName.</error>
   <error code="XC0062">It is a dynamic error if the match option matches a namespace node.</error>
   <error code="XC0063">It is a dynamic error if the path-separator option is specified and is not exactly one character long.</error>

   <error code="XC0064">It is a dynamic error if the exit code from the command is greater than the specified failure-threshold value.</error>
   <error code="XC0066">It is a dynamic error if the arg-separator option is specified and is not exactly one character long.</error>
   <error code="XD0001">It is a dynamic error if a non-XML resource is produced on a step output or arrives on a step input.</error>
   <error code="XD0003">It is a dynamic error if the viewport source does not provide exactly one document.</error>
   <error code="XD0004">It is a dynamic error if no subpipeline is selected by the p:choose and no default is provided.</error>
   <error code="XD0005">It is a dynamic error if more than one document appears on the connection for the xpath-context.</error>

   <error code="XD0006">If sequence is not specified, or has the value false, then it is a dynamic error unless exactly one document appears on the declared port.</error>
   <error code="XD0007">If sequence is not specified on p:output, or has the value false, then it is a dynamic error if the step does not produce exactly one document on the declared port.</error>
   <error code="XD0008">It is a dynamic error if a document sequence appears where a document to be used as the context node is expected.</error>
   <error code="XD0009">It is a dynamic error if the element attribute on p:namespaces is specified and it does not identify a single element node.</error>
   <error code="XD0010">It is a dynamic error if the match expression on p:viewport does not match an element or document.</error>
   <error code="XD0011">It is a dynamic error if the resource referenced by a p:document element does not exist, cannot be accessed, or is not a well-formed XML document.</error>

   <error code="XD0012">It is a dynamic error if any attempt is made to dereference a URI where the scheme of the URI reference is not supported.</error>
   <error code="XD0013">It is a dynamic error if the specified namespace bindings are inconsistent; that is, if the same prefix is bound to two different namespace names.</error>
   <error code="XD0014">It is a dynamic error for any unqualified attribute names other than “name”, “namespace”, or “value” to appear on a c:param element.</error>
   <error code="XD0015">It is a dynamic error if the specified QName cannot be resolved with the in-scope namespace declarations.</error>
   <error code="XD0016">It is a dynamic error if the select expression on a p:input returns atomic values or anything other than element or document nodes (or an empty sequence).</error>
   <error code="XD0017">It is a dynamic error if the running pipeline attempts to invoke a step which the processor does not know how to perform.</error>

   <error code="XD0018">It is a dynamic error if the parameter list contains any elements other than c:param.</error>
   <error code="XD0019">It is a dynamic error if any option value does not satisfy the type required for that option.</error>
   <error code="XD0020">It is a dynamic error if the combination of serialization options specified or defaulted is not allowed.</error>
   <error code="XD0021">It is a dynamic error for a pipeline to attempt to access a resource for which it has insufficient privileges or perform a step which is forbidden.</error>
   <error code="XD0022">It is a dynamic error if a processor that does not support PSVI annotations attempts to invoke a step which asserts that they are required.</error>

   <error code="XD0023">It is a dynamic error if an XPath expression is encountered which cannot be evaluated (because it is syntactically incorrect, contains references to unbound variables or unknown functions, or for any other reason).</error>
   <error code="XD0024">It is a dynamic error if a 2.0 processor encounters an XPath 1.0 expression and it does not support XPath 1.0 compatibility mode.</error>
   <error code="XD0025">It is a dynamic error if the namespace attribute is specified, the name contains a colon, and the specified namespace is not the same as the in-scope namespace binding for the specified prefix.</error>
   <error code="XD0026">It is a dynamic error if the select expression makes reference to the context node, size, or position when the context item is undefined.</error>
   <error code="XD0027">It is a dynamic error if the processor encounters an xpath-version that it does not support.</error>
   <error code="XD0028">It is a dynamic error if any attribute value does not satisfy the type required for that attribute.</error>

   <error code="XD0029">It is a dynamic error if the document referenced by a p:data element does not exist, cannot be accessed, or cannot be encoded as specified.</error>
   <error code="XD0030">It is a dynamic error if a step is unable or incapable of performing its function.</error>
   <error code="XD0031">It is a dynamic error to use the XProc namespace in the name of a parameter.</error>
   <error code="XD0033">It is a dynamic error if the name specified is not the name of an in-scope option or variable.</error>
   <error code="XD0034">It is a dynamic error to specify a new namespace or prefix if the lexical value of the specified name contains a colon (or if no wrapper is explicitly specified).</error>
   <error code="XS0001">It is a static error if there are any loops in the connections between steps: no step can be connected to itself nor can there be any sequence of connections through other steps that leads back to itself.</error>

   <error code="XS0002">All steps in the same scope must have unique names: it is a static error if two steps with the same name appear in the same scope.</error>
   <error code="XS0003">It is a static error if any declared input is not connected.</error>
   <error code="XS0004">It is a static error if an option or variable declaration duplicates the name of any other option or variable in the same environment.</error>
   <error code="XS0005">It is a static error if the primary output port of any step is not connected.</error>
   <error code="XS0006">It is a static error if the primary output port has no explicit connection and the last step in the subpipeline does not have a primary output port.</error>
   <error code="XS0007">It is a static error if two subpipelines in a p:choose declare different outputs.</error>

   <error code="XS0008">It is a static error if any element in the XProc namespace has attributes not defined by this specification unless they are extension attributes.</error>
   <error code="XS0009">It is a static error if the p:group and p:catch subpipelines declare different outputs.</error>
   <error code="XS0010">It is a static error if a pipeline contains a step whose specified inputs, outputs, and options do not match the signature for steps of that type.</error>
   <error code="XS0011">It is a static error to identify two ports with the same name on the same step.</error>
   <error code="XS0014">It is a static error to identify more than one output port as primary.</error>
   <error code="XS0015">It is a static error if a compound step has no contained steps.</error>

   <error code="XS0017">It is a static error to specify that an option is both requiredand has a default value.</error>
   <error code="XS0018">If an option is required, it is a static error to invoke the step without specifying a value for that option.</error>
   <error code="XS0019">it is a static error for a variable's document connection to refer to the output port of any step in the surrounding container's contained steps</error>
   <error code="XS0020">It is a static error if the binding attribute on p:namespaces is specified and its value is not the name of an in-scope binding.</error>
   <error code="XS0022">In all cases except the p:output of a compound step, it is a static error if the port identified by a p:pipe is not in the readable ports of the step that contains the p:pipe.</error>
   <error code="XS0024">It is a static error if the content of the p:inline element does not consist of exactly one element, optionally preceded and/or followed by any number of processing instructions, comments or whitespace characters.</error>

   <error code="XS0025">It is a static error if the expanded-QName value of the type attribute is in no namespace or in the XProc namespace.</error>
   <error code="XS0026">It is a static error if the port specified on the p:log is not the name of an output port on the step in which it appears or if more than one p:log element is applied to the same port.</error>
   <error code="XS0027">It is a static error if an option is specified with both the shortcut form and the long form.</error>
   <error code="XS0028">It is a static error to declare an option or variable in the XProc namespace.</error>
   <error code="XS0029">It is a static error to specify a connection for a p:output inside a p:declare-step for an atomic step.</error>
   <error code="XS0030">It is a static error to specify that more than one input port is the primary.</error>

   <error code="XS0031">It is a static error to use an option on an atomic step that is not declared on steps of that type.</error>
   <error code="XS0032">It is a static error if no connection is provided and the default readable port is undefined.</error>
   <error code="XS0033">It is a static error to specify any kind of input other than “document” or “parameter”.</error>
   <error code="XS0034">It is a static error if the specified port is not a parameter input port or if no port is specified and the step does not have a primary parameter input port.</error>
   <error code="XS0035">It is a static error if the declaration of a parameter input port contains a connection; parameter input port declarations must be empty.</error>
   <error code="XS0036">All the step types in a pipeline or library must have unique names: it is a static error if any step type name is built-in and/or declared or defined more than once in the same scope.</error>

   <error code="XS0037">It is a static error if any step directly contains text nodes that do not consist entirely of whitespace.</error>
   <error code="XS0038">It is a static error if any required attribute is not provided.</error>
   <error code="XS0039">It is a static error if the port specified on the p:serialization is not the name of an output port on the pipeline in which it appears or if more than one p:serialization element is applied to the same port.</error>
   <error code="XS0040">It is a static error to specify any value other than true.</error>
   <error code="XS0041">It is a static error to specify both binding and element on the same p:namespaces element.</error>
   <error code="XS0042">It is a static error to attempt to provide a connection for an input port on the declaration of an atomic step.</error>

   <error code="XS0044">It is a static error if any element in the XProc namespace or any step has element children other than those specified for it by this specification. In particular, the presence of atomic steps for which there is no visible declaration may raise this error.</error>
   <error code="XS0048">It is a static error to use a declared step as a compound step.</error>
   <error code="XS0051">It is a static error if the except-prefixes attribute on p:namespaces does not contain a list of tokens or if any of those tokens is not a prefix bound to a namespace in the in-scope namespaces of the p:namespaces element.</error>
   <error code="XS0052">It is a static error if the URI of a p:import cannot be retrieved or if, once retrieved, it does not point to a p:library, p:declare-step, or p:pipeline.</error>
   <error code="XS0053">It is a static error to import a single pipeline if that pipeline does not have a type.</error>
   <error code="XS0055">It is a static error if a primary parameter input port is unconnected and the pipeline that contains the step has no primary parameter input port unless at least one explicit p:with-param is provided for that port.</error>

   <error code="XS0057">It is a static error if the exclude-inline-prefixes attribute does not contain a list of tokens or if any of those tokens (except #all or #default) is not a prefix bound to a namespace in the in-scope namespaces of the element on which it occurs.</error>
   <error code="XS0058">It is a static error if the value #default is used within the exclude-inline-prefixes attribute and there is no default namespace in scope.</error>
   <error code="XS0059">It is a static error if the pipeline element is not p:pipeline, p:declare-step, or p:library.</error>
   <error code="XS0060">It is a static error if the processor encounters an explicit request for a previous version of the language and it is unable to process the pipeline using those semantics.</error>
   <error code="XS0061">It is a static error if a use-when expression refers to the context or attempts to refer to any documents or collections.</error>
   <error code="XS0062">It is a static error if a required version attribute is not present.</error>

   <error code="XS0063">It is a static error if the value of the version attribute is not a xs:decimal.</error>
</error-list>)
};

declare function (:TEST:) tconst:checkXprocXQErrorCodes() { 
  test:assertXMLEqual($const:xprocxq-error,<error-list xmlns="http://xproc.net/xproc/error">
   <error code="XXQ0001">This step is not yet supported by xprocxq.</error>
   <error code="XXQ0002">This component is not yet supported by xprocxq.</error>
   <error code="XXQ0003">XProc pipeline supplied is empty, non-existent, corrupted or invalid when checked against xproc schema.</error>	
   <error code="XXQ0004">This step requires has dependencies which have not loaded.</error>
</error-list>)

};




