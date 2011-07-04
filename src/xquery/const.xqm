(: ------------------------------------------------------------------------------------- 
 
	const.xqm - contains all constants used by xprocxq.
	
---------------------------------------------------------------------------------------- :)
xquery version "3.0" encoding "UTF-8";

module namespace const = "http://xproc.net/xproc/const";

(: -------------------------------------------------------------------------- :)
(: XProc Namespace Declaration :)
(: -------------------------------------------------------------------------- :)
declare namespace xproc = "http://xproc.net/xproc";
declare namespace p="http://www.w3.org/ns/xproc";
declare namespace c="http://www.w3.org/ns/xproc-step";
declare namespace err="http://www.w3.org/ns/xproc-error";
declare namespace xsl="http://www.w3.org/1999/XSL/Transform";


(: -------------------------------------------------------------------------- :)
(: XProc Namespace Constants :)
(: -------------------------------------------------------------------------- :)
declare variable $const:NS_XPROC      := "http://www.w3.org/ns/xproc";
declare variable $const:NS_XPROC_STEP := "http://www.w3.org/ns/xproc-step";
declare variable $const:NS_XPROC_ERR  := "http://www.w3.org/ns/xproc-error";


(: -------------------------------------------------------------------------- :)
(: Serialization Constants :)
(: -------------------------------------------------------------------------- :)
declare variable $const:DEFAULT_SERIALIZE := 'method=xml indent=yes';
declare variable $const:TRACE_SERIALIZE := 'method=xml';
declare variable $const:XINCLUDE_SERIALIZE := 'expand-xincludes=yes';
declare variable $const:TEXT_SERIALIZE := 'method=text';
declare variable $const:ESCAPE_SERIALIZE := 'method=xml indent=no';


(: -------------------------------------------------------------------------- :)
(: XProc Extension Namespaces :)
(: -------------------------------------------------------------------------- :)
declare variable $const:NS_XPROC_EXT := "http://xproc.net/ns/xproc/ex";
declare variable $const:NS_XPROC_ERR_EXT := "http://xproc.net/ns/errors";


(: -------------------------------------------------------------------------- :)
(: Error Dictionary lookup :)
(: -------------------------------------------------------------------------- :)
declare variable $const:error          := fn:doc("/Users/jfuller/Source/Webcomposite/xprocxq/src/xquery/etc/error-codes.xml");
declare variable  $const:xprocxq-error := fn:doc("/Users/jfuller/Source/Webcomposite/xprocxq/src/xquery/etc/xproc-error-codes.xml");

(: -------------------------------------------------------------------------- :)
(: Step Definition lookup :)
(: -------------------------------------------------------------------------- :)
declare variable $const:ext-steps  := fn:doc("/Users/jfuller/Source/Webcomposite/xprocxq/src/xquery/etc/pipeline-extension.xml")/p:library;
declare variable $const:std-steps  := fn:doc("/Users/jfuller/Source/Webcomposite/xprocxq/src/xquery/etc/pipeline-standard.xml")/p:library;
declare variable $const:opt-steps  := fn:doc("/Users/jfuller/Source/Webcomposite/xprocxq/src/xquery/etc/pipeline-optional.xml")/p:library;
declare variable $const:comp-steps := fn:doc("/Users/jfuller/Source/Webcomposite/xprocxq/src/xquery/etc/xproc-component.xml")/xproc:components;


(: -------------------------------------------------------------------------- :)
(: System Property :)
(: -------------------------------------------------------------------------- :)
declare variable $const:version :="0.9";
declare variable $const:product-version :="0.9";
declare variable $const:product-name :="xprocxq";
declare variable $const:vendor :="James Fuller";
declare variable $const:language :="en";
declare variable $const:vendor-uri :="http://www.xproc.net";
declare variable $const:xpath-version :="2.0";
declare variable $const:psvi-supported :="false";
declare variable $const:episode :="somerandomnumber";


(: -------------------------------------------------------------------------- :)
(: XProc default naming prefix :)
(: -------------------------------------------------------------------------- :)
declare variable $const:init_unique_id :="!1";

(: -------------------------------------------------------------------------- :)
(: Mime types :)
(: -------------------------------------------------------------------------- :)
declare variable $const:pdf-mimetype := 'application/pdf';

(: -------------------------------------------------------------------------- :)
(: XSLT to transform eXist specific file listing :)
(: -------------------------------------------------------------------------- :)
declare variable $const:directory-list-xslt := 'resource:net/xproc/xprocxq/etc/directory-list.xsl';

(: -------------------------------------------------------------------------- :)
(: RELAXNG Schema for XPROC :)
(: -------------------------------------------------------------------------- :)
declare variable $const:xproc-rng-schema := 'resource:net/xproc/xprocxq/etc/xproc.rng';









(: -------------------------------------------------------------------------- :)
(: DEPRECATION LIKELY :)
(: -------------------------------------------------------------------------- :)
declare variable $const:default-ns-imports :='
    declare namespace p="http://www.w3.org/ns/xproc";
    declare namespace c="http://www.w3.org/ns/xproc-step";
    declare namespace err="http://www.w3.org/ns/xproc-error";
    declare namespace xsl="http://www.w3.org/1999/XSL/Transform";
    declare namespace t="http://xproc.org/ns/testsuite";

    import module namespace func   = "http://xproc.net/xproc/functions" at "resource:net/xproc/xprocxq/src/xquery/functions.xqm";

';

declare variable $const:default-imports :='

    import module namespace xproc = "http://xproc.net/xproc";
    import module namespace const = "http://xproc.net/xproc/const" at "resource:net/xproc/xprocxq/src/xquery/const.xqm";
    import module namespace u     = "http://xproc.net/xproc/util" at "resource:net/xproc/xprocxq/src/xquery/util.xqm";
    import module namespace opt   = "http://xproc.net/xproc/opt" at "resource:net/xproc/xprocxq/src/xquery/opt.xqm";
    import module namespace std   = "http://xproc.net/xproc/std" at "resource:net/xproc/xprocxq/src/xquery/std.xqm";
    import module namespace ext   = "http://xproc.net/xproc/ext" at "resource:net/xproc/xprocxq/src/xquery/ext.xqm";
    import module namespace func   = "http://xproc.net/xproc/functions" at "resource:net/xproc/xprocxq/src/xquery/functions.xqm";

    declare namespace xsl="http://www.w3.org/1999/XSL/Transform";
    declare option exist:serialize "expand-xincludes=no";

';

declare variable $const:xpath-imports :='
    declare copy-namespaces preserve, inherit;
';

declare variable $const:alt-imports :=' declare copy-namespaces no-preserve, no-inherit; import module namespace p = "http://xproc.net/xproc/functions";';

