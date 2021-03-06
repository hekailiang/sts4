#!/bin/bash
set -e
set -v
workdir=`pwd`
output=$workdir/out
#atom_commons=$workdir/sts4/atom-extensions/atom-commons
atom_package=$workdir/sts4/atom-extensions/$package_name

url=`cat fatjar/url`
fatjar_version=`cat fatjar/version`

#cd $atom_commons
#npm install
#npm run build

cd $atom_package

#npm install ${atom_commons}

cat > properties.json << EOF
{
    "jarUrl": "${url}"
}
EOF

npm install

npm run build

# push code to release repository

cd $workdir
mkdir -p out/repo
# enable hidden files for * matcher
shopt -s dotglob
cp -a $atom_package/* out/repo
cp -a release_repo/.git out/repo/.git
# disable hidden files for * matcher
shopt -u dotglob
cp $atom_package/.gitignore-release out/repo/.gitignore
rm -f out/repo/.gitignore-release

cd out/repo

git config user.email "aboyko@pivotal.io"
git config user.name "Alex Boyko"

git add .

git commit \
    -m "Publish $fatjar_version"
