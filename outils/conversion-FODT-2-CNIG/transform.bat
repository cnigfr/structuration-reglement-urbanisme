SET SAXON_HOME=C:\Java\SaxonHE10-1J
SET JAVA_BIN_HOME=C:\Java\8.181\bin
"%JAVA_BIN_HOME%\java" -cp "%SAXON_HOME%\saxon-he-10.1.jar" net.sf.saxon.Transform PLU_Jaleyrac.fodt fodt2CNIG-1.xsl > "XSL Output-1.xml"

"%JAVA_BIN_HOME%\java" -cp "%SAXON_HOME%\saxon-he-10.1.jar" net.sf.saxon.Transform "XSL Output-1.xml" fodt2CNIG-2.xsl > "XSL Output-2.xml"

"%JAVA_BIN_HOME%\java" -cp "%SAXON_HOME%\saxon-he-10.1.jar" net.sf.saxon.Transform "XSL Output-2.xml" fodt2CNIG-3.xsl > "XSL Output-3.xml"

COPY "XSL Output-3.xml" "C:\Program Files\Tomcat9\webapps\jaleyrac\15079_reglement_20190128.xml"

PAUSE