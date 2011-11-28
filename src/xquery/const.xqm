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
(: Error Dictionary lookup :) (:~ @TODO - obviously need to remove these absolute paths :)
(: -------------------------------------------------------------------------- :)
declare variable $const:error          := fn:doc("/Users/jfuller/Source/Webcomposite/xprocxq/src/xquery/etc/error-codes.xml");
declare variable  $const:xprocxq-error := fn:doc("/Users/jfuller/Source/Webcomposite/xprocxq/src/xquery/etc/xproc-error-codes.xml");

(: -------------------------------------------------------------------------- :)
(: Step Definition lookup :) (:~ @TODO - obviously need to remove these absolute paths :)
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
(:  :)
(: -------------------------------------------------------------------------- :)
declare variable $const:NDEBUG :=1;

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
