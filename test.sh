#!/bin/sh

current_branch=release-1.4.1
event_name=push
is_tag=false
GITHUB_ENV=""

build_image_enabled=false
if [[ $current_branch =~ ^(release|dev|master|main).* ]];then
  echo "current_branch is $current_branch"
  if [[ $event_name == 'push' ]]; then
    echo "event_name is $event_name"
    build_image_enabled=true
  fi
fi

echo "build_image_enabled=$build_image_enabled"
# echo "build_image_enabled=$build_image_enabled" >> $GITHUB_ENV

echo "version_fragment=alpha" >> $GITHUB_ENV
if [[ $current_branch =~ ^release.* ]]; then
  echo "version_fragment=rc"

  current_version=${current_branch#*release}
  current_version=${current_version#*/}
  current_version=${current_version#*-}
  echo "current_version=$current_version"
fi

