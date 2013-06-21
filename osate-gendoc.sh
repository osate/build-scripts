#!/bin/sh

BUILDDIR=/tmp/osate

(rm -rf ${BUILDDIR})
mkdir -p ${BUILDDIR}

(cd ${BUILDDIR} && rm -rf core)
(cd ${BUILDDIR} && mkdir -p osate-doc)
(cd ${BUILDDIR} && mkdir -p osate-doc/metamodel)
(cd ${BUILDDIR} && git clone -b develop https://github.com/osate/osate2-core.git core)

(cd ${BUILDDIR}/core/org.osate.help/ && cp -rf api ${BUILDDIR}/osate-doc/osate-javadoc)
(cd ${BUILDDIR}/core/org.osate.help/ && cp -rf html/std ${BUILDDIR}/osate-doc/aadl-std)
(cd ${BUILDDIR}/osate-doc/aadl-std && cp -f section-1.html index.html)
(cp -f index-doc.html ${BUILDDIR}/osate-doc/index.html)
(cd ${BUILDDIR}/core/org.osate.help/ && cp -rf html/*.html ${BUILDDIR}/osate-doc/)
(cd ${BUILDDIR}/core/org.osate.help/ && cp -rf html/*.png ${BUILDDIR}/osate-doc/)
(cd ${BUILDDIR}/core/org.osate.help/ && cp -rf html/plugins ${BUILDDIR}/osate-doc/osate-plugins)
(cd ${BUILDDIR}/core/org.osate.help/ && cp -rf html/emv2 ${BUILDDIR}/osate-doc/osate-emv2)
(cd ${BUILDDIR}/core/org.osate.help/ && cp -rf html/plugindev ${BUILDDIR}/osate-doc/osate-plugindev)
(cd ${BUILDDIR}/core/org.osate.help/ && cp -rf html/start ${BUILDDIR}/osate-doc/osate-introduction)
(cd ${BUILDDIR}/core/ && find . -name '*.xmi' -exec cp "{}" ${BUILDDIR}/osate-doc/metamodel/ \; )
(cd ${BUILDDIR}/core/ && find . -name '*.ecore' -exec cp "{}" ${BUILDDIR}/osate-doc/metamodel/ \; )

exit 0
