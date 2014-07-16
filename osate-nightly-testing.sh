#!/bin/sh

BUILDDIR=/tmp/osate

VERSION=2.0.8-snapshot
DATE=`date '+%Y%m%d'`

PLATFORM_URL="http://ftp.ussg.iu.edu/eclipse/eclipse/downloads/drops4/R-4.4-201406061215/org.eclipse.platform-4.4.zip"
PLATFORM_FILE="org.eclipse.platform-4.4.zip"
mkdir -p ${BUILDDIR}


if [ ! -f $PLATFORM_FILE ]; then
	wget -c $PLATFORM_URL
fi
(cd ${BUILDDIR} && rm -rf core)
(cd ${BUILDDIR} && rm -rf plugins)
(cd ${BUILDDIR} && rm -rf error-model1)
(cd ${BUILDDIR} && rm -rf error-model2)
(cd ${BUILDDIR} && rm -rf osate-ge)
(cd ${BUILDDIR} && rm -rf osate2-ba)

(cp -f $PLATFORM_FILE /tmp)
(cd /tmp && unzip -f $PLATFORM_FILE )
(cd ${BUILDDIR} && git clone -b develop https://github.com/osate/osate2-core.git core)
(cd ${BUILDDIR} && git clone -b develop https://github.com/osate/osate2-plugins.git plugins)
(cd ${BUILDDIR} && git clone -b develop https://github.com/osate/osate-ge.git osate-ge)
(cd ${BUILDDIR} && git clone -b develop https://github.com/osate/ErrorModelV1.git error-model1)
(cd ${BUILDDIR} && git clone -b develop https://github.com/osate/ErrorModelV2.git error-model2)

(cd ${BUILDDIR} && git clone -b develop https://github.com/osate/osate2-ba.git aadlba)

(cd ${BUILDDIR} && sed -i "s/RELEASE_VERSION/$VERSION/g" "core/org.osate.branding/plugin.properties" )
(cd ${BUILDDIR} && sed -i "s/RELEASE_VERSION/$VERSION/g" "core/org.osate.branding/about.mappings" )

(cd ${BUILDDIR} && sed -i "s/RELEASE_DATE/$DATE/g" "core/org.osate.branding/plugin.properties" )
(cd ${BUILDDIR} && sed -i "s/RELEASE_DATE/$DATE/g" "core/org.osate.branding/about.mappings" )

(cp -f luna.target ${BUILDDIR}/core/org.osate.build.target/luna.target )
(cd ${BUILDDIR}/core/org.osate.build.main && mvn clean install) || exit 1
exit 0
