#!/bin/sh
rm -rf /tmp/osate-qa
mkdir -p /tmp/osate-qa
(cd /tmp/osate-qa && git clone https://github.com/khoroshilov/aadl-qa.git aadl-qa)

if [ -f /tmp/osate-ramses.zip ]; then
	(cp /tmp/osate-ramses.zip /tmp/osate-qa/ramses.zip)
else
	exit 3
fi

(cd /tmp/osate-qa && unzip -q ramses.zip )
ramsesdir=`find /tmp/osate-qa -type d -name 'ramses*'`
(cd /tmp/osate-qa/aadl-qa && export PATH=$ramsesdir:$PATH && ./aadl-qa.pl run Osate )

