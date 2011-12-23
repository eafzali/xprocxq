## running all tests under src/test/tests

echo "running all unit tests"

java  -Xmx1024m -cp /Users/jfuller/Source/FLOSS/saxonpe9-4-0-1j/saxon9pe.jar net.sf.saxon.Query -qversion:3.0 /Users/jfuller/Source/Webcomposite/xprocxq/src/test/tests/all-xproc.xqy > report/all-xproc.html

java  -Xmx1024m -cp /Users/jfuller/Source/FLOSS/saxonpe9-4-0-1j/saxon9pe.jar net.sf.saxon.Query -qversion:3.0 /Users/jfuller/Source/Webcomposite/xprocxq/src/test/tests/all-parse.xqy > report/all-parse.html

java  -Xmx1024m -cp /Users/jfuller/Source/FLOSS/saxonpe9-4-0-1j/saxon9pe.jar net.sf.saxon.Query -qversion:3.0 /Users/jfuller/Source/Webcomposite/xprocxq/src/test/tests/all-std.xqy > report/all-std.html

java  -Xmx1024m -cp /Users/jfuller/Source/FLOSS/saxonpe9-4-0-1j/saxon9pe.jar net.sf.saxon.Query -qversion:3.0 /Users/jfuller/Source/Webcomposite/xprocxq/src/test/tests/all-opt.xqy > report/all-opt.html

java  -Xmx1024m -cp /Users/jfuller/Source/FLOSS/saxonpe9-4-0-1j/saxon9pe.jar net.sf.saxon.Query -qversion:3.0 /Users/jfuller/Source/Webcomposite/xprocxq/src/test/tests/all-ext.xqy > report/all-ext.html

java  -Xmx1024m -cp /Users/jfuller/Source/FLOSS/saxonpe9-4-0-1j/saxon9pe.jar net.sf.saxon.Query -qversion:3.0 /Users/jfuller/Source/Webcomposite/xprocxq/src/test/tests/all-const.xqy > report/all-const.html

