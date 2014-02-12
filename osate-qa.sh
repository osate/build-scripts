#!/bin/sh

rm -rf /tmp/osate-qa
mkdir -p /tmp/osate-qa
mkdir -p /tmp/osate-qa/reports
mkdir -p /tmp/osate-qa/reports/pmd
mkdir -p /tmp/osate-qa/reports/findbugs


(cd /tmp/osate-qa && git clone -b develop https://github.com/osate/osate2-core.git core)
(cd /tmp/osate-qa && git clone -b develop https://github.com/osate/osate2-plugins.git plugins)
(cd /tmp/osate-qa && git clone -b develop https://github.com/osate/ErrorModelV1.git error-model1)
(cd /tmp/osate-qa && git clone -b develop https://github.com/osate/ErrorModelV2.git error-model2)

DO_AADLQA=1

if [ ${DO_AADLQA} -eq 1 ]; then

  (cd /tmp/osate-qa && git clone https://github.com/khoroshilov/aadl-qa.git aadl-qa)

  if [ -f /tmp/osate-ramses.zip ]; then
	  (cp /tmp/osate-ramses.zip /tmp/osate-qa/ramses.zip)
  else
	  exit 3
  fi

  (cd /tmp/osate-qa && unzip -q ramses.zip )
  ramsesdir=`find /tmp/osate-qa -type d -name 'ramses*'`
  (cd /tmp/osate-qa/aadl-qa && export PATH=$ramsesdir:$PATH && ./aadl-qa.pl run Osate )
fi

echo "PMD $PMD_PATH"
if [ -d "${PMD_PATH}" ]; then
  for v in core plugins error-model2; do
  export PMD_PATH
    (cd ${PMD_PATH}  ; HEAPSIZE=1024m ./bin/run.sh pmd -d /tmp/osate-qa/$v/ -f html -R java-unusedcode -version 1.7 -language java > /tmp/osate-qa/reports/pmd/osate-$v.html)
  done
fi


if [ -f "${FINDBUGS_BIN}" ]; then
  for v in core plugins error-model2; do
  export FINDBUGS_BIN
    ( ${FINDBUGS_BIN} -textui -output /tmp/osate-qa/reports/findbugs/osate-$v.html -html -onlyAnalyze org.osate.- /tmp/osate-qa/$v/ )
  done
fi
