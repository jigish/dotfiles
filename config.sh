CURRDIR=`pwd`
SCRIPTDIR=$(cd `dirname $0` && pwd)

$SCRIPTDIR/config.`uname`.sh $1
