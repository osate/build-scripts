#!/bin/sh
rm -rf /tmp/osate-qa
mkdir -p /tmp/osate-qa
(cd /tmp/osate-qa && git clone https://github.com/khoroshilov/aadl-qa.git aadl-qa)

if [ -f /tmp/osate-ramses.zip ]; then
	(cp /tmp/osate-ramses.zip /tmp/osate-qa/ramses.zip)
else
	exit 3
fi

(cd /tmp/osate-qa && unzip ramses.zip )
(cd /tmp/osate-qa/aadl-qa && export PATH=/tmp/osate-qa/ramses/:$PATH && ./aadl-qa.pl run Osate )

