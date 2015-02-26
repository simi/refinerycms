set -e

# prepare SSH key
openssl aes-256-cbc -K $encrypted_c569829839db_key -iv $encrypted_c569829839db_iv -in refinerybot_dsa.enc -out ci/refinerybot_dsa -d
chmod 600 ci/refinerybot_dsa
mkdir -p ~/.ssh
mv ci/refinerybot_dsa ~/.ssh/id_dsa

cd ..

# install needed gems
gem install railties
gem install execjs

# BUNDLE_GEMFILE was set to refinerycms by Travis CI
unset BUNDLE_GEMFILE

# create new app based on demo template
rails new demo-edge -d postgresql -m refinerycms/templates/refinery/demo.rb
cd demo-edge/
cat Gemfile

# configure git
git config --global user.email "refinerybot@p.arndt.io"
git config --global user.name "RefineryCMS bot"

# initialize git repo
git init .
git remote add github git@github.com:refinery/demo-edge.git
git remote add dokku dokku@dokku.refinerycms.com:demo-edge

# https://github.com/progrium/dokku/issues/953
echo "export BUILDPACK_URL=https://github.com/heroku/heroku-buildpack-ruby" > .env

# create REVISION file
echo $TRAVIS_COMMIT > REVISION

# add and commit all files
git add -A
git commit -m "deploy $TRAVIS_REPO_SLUG#$TRAVIS_COMMIT on `date +"%Y-%m-%d.%H-%M-%S"`"

# deploy to edge-demo.refinerycms.com
git push --force dokku master

# nullify DB
ssh dokku@dokku.refinerycms.com run demo-edge bin/rake db:setup

# push to https://github.com/refinery/demo-edge
git push --force github master
