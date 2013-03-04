#!/bin/sh

RAMSES_DISTRIBUTION=/tmp/osate-ramses/distribution-1.0.0-SNAPSHOT/
export RAMSES_DIR=${RAMSES_DISTRIBUTION}


`which java` \
-Djavax.xml.parsers.SAXParserFactory=com.sun.org.apache.xerces.internal.jaxp.SAXParserFactoryImpl \
-Djavax.xml.parsers.DocumentBuilderFactory=com.sun.org.apache.xerces.internal.jaxp.DocumentBuilderFactoryImpl \
-Djavax.xml.transform.TransformerFactory=com.sun.org.apache.xalan.internal.xsltc.trax.TransformerFactoryImpl \
-classpath .:/tmp/osate/build_and_test/distribution/target/distribution-1.0.0-SNAPSHOT/ \
-jar ${RAMSES_DISTRIBUTION}/ramses-exe.jar $@
