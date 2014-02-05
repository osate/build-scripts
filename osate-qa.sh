#!/bin/sh
RAMSES_URL=http://www.aadl.info/aadl/osate/misc/ramses/
rm -rf /tmp/osate-qa
cd (/tmp/osate-qa && git checkout https://github.com/khoroshilov/aadl-qa.git aadl-qa)

if [ ! -f /tmp/osate-qa/ramses.zip ]; then
	(cd /tmp/osate-qa && wget -c $RAMSES_URL)
fi

(cd /tmp/osate-qa && unzip ramses.zip )
(cd /tmp/osate-qa/aadl-qa && export PATH=/tmp/osate-qa/ramses/:$PATH ./aadl=qa.pl run Osate )

