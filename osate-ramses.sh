#!/bin/sh

BUILDDIR=/tmp/osate

VERSION=2.0.0-snapshot
DATE=`date '+%Y%m%d'`
JUNO_PLATFORM_URL="http://mirrors.med.harvard.edu/eclipse/eclipse/downloads/drops4/R-4.2-201206081400/org.eclipse.platform-4.2.zip"
JUNO_PLATFORM_FILE="org.eclipse.platform-4.2.zip"


rm -rf ${BUILDDIR}
mkdir -p ${BUILDDIR}


if [ ! -f $JUNO_PLATFORM_FILE ]; then
	wget -c $JUNO_PLATFORM_URL
fi
(cd ${BUILDDIR} && rm -rf core)
(cd ${BUILDDIR} && rm -rf plugins)
(cd ${BUILDDIR} && rm -rf error-model1)
(cd ${BUILDDIR} && rm -rf error-model2)
(cp -f $JUNO_PLATFORM_FILE /tmp)
(cd /tmp && unzip -f $JUNO_PLATFORM_FILE )

(cd ${BUILDDIR} && svn --username ramses_readers --password ramses co https://eve.enst.fr/svn/aadl-eclipse-dev/aadlutils/trunk aadlutils )

(cd ${BUILDDIR} && svn --username ramses_readers --password ramses co https://eve.enst.fr/svn/aadl-eclipse-dev/aadlba/trunk aadlba )

(cd ${BUILDDIR} && svn --username ramses_readers --password ramses co https://eve.enst.fr/svn/aadl-eclipse-dev/aadlmt/trunk aadlmt )

(cd ${BUILDDIR} && svn --username ramses_readers --password ramses co https://eve.enst.fr/svn/aadl-eclipse-dev/update-site update-site)

(cd ${BUILDDIR} && svn --username ramses_readers --password ramses co https://eve.enst.fr/svn/aadl-eclipse-dev/build_and_test build_and_test)

(cd ${BUILDDIR} && git clone -b develop https://github.com/osate/osate2-core.git core)
(cd ${BUILDDIR} && git clone -b develop https://github.com/osate/osate2-plugins.git plugins)
(cd ${BUILDDIR} && git clone -b develop https://github.com/osate/ErrorModelV1.git error-model1)
(cd ${BUILDDIR} && git clone -b develop https://github.com/osate/ErrorModelV2.git error-model2)


(cd ${BUILDDIR} && sed -i "s/RELEASE_VERSION/$VERSION/g" "core/org.osate.branding/plugin.properties" )
(cd ${BUILDDIR} && sed -i "s/RELEASE_VERSION/$VERSION/g" "core/org.osate.branding/about.mappings" )

(cd ${BUILDDIR} && sed -i "s/RELEASE_DATE/$DATE/g" "core/org.osate.branding/plugin.properties" )
(cd ${BUILDDIR} && sed -i "s/RELEASE_DATE/$DATE/g" "core/org.osate.branding/about.mappings" )

(cp -f indigo.target ${BUILDDIR}/core/org.osate.build.target/indigo.target )
(cp -f juno.target ${BUILDDIR}/core/org.osate.build.target/juno.target )
