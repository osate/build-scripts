#!/bin/sh

BUILDDIR=/tmp/osate
ZIPDIR=${BUILDDIR}/core/org.osate.build.product/target/products
for f in $ZIPDIR/*.zip; do
   VERSION=$(unzip -l $f | grep features/org.osate | head -n 1 | cut -d/ -f3 | cut -d_ -f2)
   f=$(basename $f)
   TARGETDIR=build-$VERSION
   mkdir $TARGETDIR 2>/dev/null
   TIMESTAMP=${VERSION##*.}
   VERSION=${VERSION%.*}
   echo Processing $f...
   mv $ZIPDIR/$f $TARGETDIR/osate2-$VERSION-SNAPSHOT-$TIMESTAMP-${f#*-}
done

