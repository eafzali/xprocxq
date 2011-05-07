xquery version "3.0";

module namespace tconst ="tconst";

import module namespace test = "http://www.marklogic.com/test"
    at "../lib/test.xqm";

import module namespace const = "http://xproc.net/xproc/const" at "../../xquery/const.xqm";

declare function (:TEST:) tconst:loadConstantModule() { 
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




