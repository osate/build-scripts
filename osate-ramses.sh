#!/bin/sh

BUILDDIR=/tmp/osate
TARGETDIR=/tmp/osate-ramses

VERSION=2.0.4-snapshot
DATE=`date '+%Y%m%d'`

ECLIPSE_PLATFORM_URL="http://ftp.ussg.iu.edu/eclipse/eclipse/downloads/drops4/R-4.3-201306052000/org.eclipse.platform-4.3.zip"
ECLIPSE_PLATFORM_FILE="org.eclipse.platform-4.3.zip"


rm -rf ${BUILDDIR}
mkdir -p ${BUILDDIR}
mkdir -p ${TARGETDIR}


if [ ! -f $ECLIPSE_PLATFORM_FILE ]; then
wget -c $ECLIPSE_PLATFORM_URL
fi
(cd ${BUILDDIR} && rm -rf core)
(cd ${BUILDDIR} && rm -rf plugins)
(cd ${BUILDDIR} && rm -rf error-model1)
(cd ${BUILDDIR} && rm -rf error-model2)
(cp -f $ECLIPSE_PLATFORM_FILE /tmp)
(cd /tmp && unzip -f $ECLIPSE_PLATFORM_FILE )

(cd ${BUILDDIR} && svn --username ramses_readers --password ramses co https://eve.enst.fr/svn/aadl-eclipse-dev/aadlmt/trunk aadlmt )

(cd ${BUILDDIR} && svn --username ramses_readers --password ramses co https://eve.enst.fr/svn/aadl-eclipse-dev/update-site update-site)

(cd ${BUILDDIR} && git clone -b develop https://github.com/osate/osate2-core.git core)
(cd ${BUILDDIR} && git clone -b develop https://github.com/osate/osate2-plugins.git plugins)
(cd ${BUILDDIR} && git clone -b develop https://github.com/osate/ErrorModelV1.git error-model1)
(cd ${BUILDDIR} && git clone -b develop https://github.com/osate/ErrorModelV2.git error-model2)

(cd ${BUILDDIR} && git clone -b develop https://github.com/osate/osate2-ba.git aadlba)



#(cd ${BUILDDIR} && sed -i "s/RELEASE_VERSION/$VERSION/g" "core/org.osate.branding/plugin.properties" )
#(cd ${BUILDDIR} && sed -i "s/RELEASE_VERSION/$VERSION/g" "core/org.osate.branding/about.mappings" )

#(cd ${BUILDDIR} && sed -i "s/RELEASE_DATE/$DATE/g" "core/org.osate.branding/plugin.properties" )
#(cd ${BUILDDIR} && sed -i "s/RELEASE_DATE/$DATE/g" "core/org.osate.branding/about.mappings" )

(cp -f indigo.target ${BUILDDIR}/core/org.osate.build.target/indigo.target )
(cp -f juno.target ${BUILDDIR}/core/org.osate.build.target/juno.target )
(cp -f kepler.target ${BUILDDIR}/core/org.osate.build.target/kepler.target )


(cd ${BUILDDIR}/aadlmt/build_and_test/fr.tpt.aadl.ramses.build.main/ && mvn clean install)

cp -f ${BUILDDIR}/aadlmt/build_and_test/fr.tpt.aadl.ramses.build.distribution/target/*.zip ${TARGETDIR}/
