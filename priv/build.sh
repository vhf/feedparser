#!/bin/sh -e

cd `dirname $0`
[ -d chardet -a \
  -d erlport -a \
  -f feedparser.py -a \
  ! -d env ] && exit 0
rm -rf env chardet erlport feedparser.py *.pyc

for version in 2.7 2.6 2.5; do
	VIRTUALENV=`which virtualenv-$version 2> /dev/null || echo`
	[ -n ""$VIRTUALENV ] && break
done
[ -z $VIRTUALENV ] && VIRTUALENV=`which virtualenv 2> /dev/null`
[ -z $VIRTUALENV ] && \
	(echo virtualenv: command not found >&2 && exit 1)
VER=`echo $VIRTUALENV | sed -re 's/.*virtualenv-?(.[.].)?/\1/'`

$VIRTUALENV env

env/bin/easy_install -Z erlport
env/bin/easy_install -Z https://github.com/kurtmckee/feedparser/tarball/cf41851
env/bin/easy_install -Z chardet

mv env/lib/*/site-packages/erlport-*/erlport .
mv env/lib/*/site-packages/feedparser-*/feedparser.py .
mv env/lib/*/site-packages/chardet-*/chardet .

sed -i -re '1s%#!.*%#!'`which python$VER`'%' feedparser-port.py

rm -rf env

python$VER -m compileall .
