#!/bin/bash
set -e
set -o pipefail

# call as ./build_tar.sh $path_to_local_git_repo $last_upstream_version_number

UPSDIR=$1
VERSION=$2

test -d "$UPSDIR" || ( echo "No upstream directory"; exit 1 )
test -z "$VERSION" && ( echo "No Version"; exit 1 )

CURDIR=$PWD

#Determine GIT repositories' state
cd $UPSDIR
DATE=$( git log --pretty="%ci" HEAD^..HEAD | awk '{print $1}' | sed -e 's/-//g' )
cd $CURDIR

tmpdir=$(mktemp --tmpdir -d logwatch.XXXXXXX)
logwatch_dir=logwatch-$VERSION+git${DATE}
target_dir=$tmpdir/$logwatch_dir

mkdir -p $target_dir

rsync -av --exclude=.svn --exclude=.git $UPSDIR/ $target_dir

tar -C $tmpdir -cavf $logwatch_dir.tar.xz $logwatch_dir







