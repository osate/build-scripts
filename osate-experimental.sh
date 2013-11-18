#!/bin/sh

BUILDDIR=/tmp/osate

VERSION=experimental
DATE=`date '+%Y%m%d'`

KEPLER_PLATFORM_URL="http://ftp.ussg.iu.edu/eclipse/eclipse/downloads/drops4/R-4.3-201306052000/org.eclipse.platform-4.3.zip"
KEPLER_PLATFORM_FILE="org.eclipse.platform-4.3.zip"
RDALTE_SRC=/home/julien/tmp/rdalte.zip

mkdir -p ${BUILDDIR}


if [ ! -f $KEPLER_PLATFORM_FILE ]; then
	wget -c $KEPLER_PLATFORM_URL
fi

(cd ${BUILDDIR} && rm -rf temp)
(cd ${BUILDDIR} && rm -rf core)
(cd ${BUILDDIR} && rm -rf agree)
(cd ${BUILDDIR} && rm -rf resolute)
(cd ${BUILDDIR} && rm -rf plugins)
(cd ${BUILDDIR} && rm -rf error-model1)
(cd ${BUILDDIR} && rm -rf error-model2)
(cp -f $KEPLER_PLATFORM_FILE /tmp)
(cd /tmp && unzip -f $KEPLER_PLATFORM_FILE )

(cd ${BUILDDIR} && git clone -b develop https://github.com/osate/osate2-core.git core)
(cd ${BUILDDIR} && git clone -b develop https://github.com/osate/osate2-plugins.git plugins)
(cd ${BUILDDIR} && git clone -b develop https://github.com/osate/ErrorModelV1.git error-model1)
(cd ${BUILDDIR} && git clone -b develop https://github.com/osate/ErrorModelV2.git error-model2)

(cd ${BUILDDIR} && git clone -b develop https://github.com/osate/osate2-ba.git aadlba)



#Prepare RDALTE
cp ${RDALTE_SRC} ${BUILDDIR}/rdalte.zip
(cd ${BUILDDIR} && unzip rdalte.zip)

for v in `find  ${BUILDDIR}/rdalte/  -mindepth 1 -maxdepth 1 -type d`; do
name=`echo $v|awk -F'/' '{print $5}'`  
echo  $name
if [ -d ${BUILDDIR}/rdalte/$name ]; then
	sed -e "s/ARTIFACT_NAME/$name/g" misc/pom.xml.template > ${BUILDDIR}/rdalte/$name/pom.xml
fi

if [ -f ${BUILDDIR}/rdalte/$name/META-INF/MANIFEST.MF ]; then
	sed -e 's/1.0.0.201310032002/1.0.0.qualifier/g' ${BUILDDIR}/rdalte/$name/META-INF/MANIFEST.MF > /tmp/MANIFEST.tmp
	cp -f /tmp/MANIFEST.tmp ${BUILDDIR}/rdalte/$name/META-INF/MANIFEST.MF
fi
done
#end of RDALTE-specific work



#Prepare agree and resolute
(cd ${BUILDDIR} && git clone -b master https://github.com/smaccm/smaccm.git smaccm)
(cd ${BUILDDIR} && cp -rf smaccm/fm-workbench/agree .)
(cd ${BUILDDIR} && cp -rf smaccm/fm-workbench/resolute .)


for v in com.rockwellcollins.atc.agree com.rockwellcollins.atc.agree.analysis com.rockwellcollins.atc.agree.ui; do
	sed -e "s/ARTIFACT_NAME/$v/g" misc/pom.xml.template > ${BUILDDIR}/agree/$v/pom.xml
	sed -e 's/1.0.0/1.0.0.qualifier/g' ${BUILDDIR}/agree/$v/META-INF/MANIFEST.MF > /tmp/MANIFEST.tmp
	sed -e 's/;bundle-version=\"1.0.0.qualifier\"//g' /tmp/MANIFEST.tmp > /tmp/MANIFEST.tmp2
	cp -f /tmp/MANIFEST.tmp2 ${BUILDDIR}/agree/$v/META-INF/MANIFEST.MF
done

for v in com.rockwellcollins.atc.resolute com.rockwellcollins.atc.resolute.analysis com.rockwellcollins.atc.resolute.schedule.analysis com.rockwellcollins.atc.resolute.ui; do
	sed -e "s/ARTIFACT_NAME/$v/g" misc/pom.xml.template > ${BUILDDIR}/resolute/$v/pom.xml
	sed -e 's/1.0.0/1.0.0.qualifier/g' ${BUILDDIR}/resolute/$v/META-INF/MANIFEST.MF > /tmp/MANIFEST.tmp
	sed -e 's/;bundle-version=\"1.0.0.qualifier\"//g' /tmp/MANIFEST.tmp > /tmp/MANIFEST.tmp2
	cp -f /tmp/MANIFEST.tmp2 ${BUILDDIR}/resolute/$v/META-INF/MANIFEST.MF
done

cp -f misc/plugins.experimental.feature.xml ${BUILDDIR}/plugins/org.osate.plugins.feature/feature.xml
cp -f misc/plugins.experimental.feature.source.xml ${BUILDDIR}/plugins/org.osate.plugins.source.feature/feature.xml
cp -f misc/core-experimental-build-pom.xml ${BUILDDIR}/core/org.osate.build.main/pom.xml
#end of agree/resolute specific hack

(cd ${BUILDDIR} && sed -i "s/RELEASE_VERSION/$VERSION/g" "core/org.osate.branding/plugin.properties" )
(cd ${BUILDDIR} && sed -i "s/RELEASE_VERSION/$VERSION/g" "core/org.osate.branding/about.mappings" )

(cd ${BUILDDIR} && sed -i "s/RELEASE_DATE/$DATE/g" "core/org.osate.branding/plugin.properties" )
(cd ${BUILDDIR} && sed -i "s/RELEASE_DATE/$DATE/g" "core/org.osate.branding/about.mappings" )

(cp -f kepler.target ${BUILDDIR}/core/org.osate.build.target/kepler.target )
(cd ${BUILDDIR}/core/org.osate.build.main && mvn clean install) || exit 1
exit 0
