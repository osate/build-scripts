#!/bin/sh

BUILDDIR=/tmp/osate

(rm -rf ${BUILDDIR})
mkdir -p ${BUILDDIR}

(cd ${BUILDDIR} && rm -rf core)
(cd ${BUILDDIR} && mkdir -p osate-doc)
(cd ${BUILDDIR} && git clone -b develop https://github.com/osate/osate2-core.git core)

(cd ${BUILDDIR}/core/org.osate.help/ && cp -rf api ${BUILDDIR}/osate-doc/osate-javadoc)
(cd ${BUILDDIR}/core/org.osate.help/ && cp -rf html/std ${BUILDDIR}/osate-doc/aadl-std)
(cd ${BUILDDIR}/osate-doc/aadl-std && cp -f section-1.html index.html)
(cd ${BUILDDIR}/core/org.osate.help/ && cp -rf html/plugins ${BUILDDIR}/osate-doc/osate-plugins)
(cd ${BUILDDIR}/core/org.osate.help/ && cp -rf html/plugindev ${BUILDDIR}/osate-doc/osate-plugindev)

exit 0
