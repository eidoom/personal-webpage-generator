#!/usr/bin/env bash

if [ -z "$1" ]; then
	echo "Missing commit message!"
	exit 0
fi

echo "# Updating public"
cd public
git pull
cd ..
echo -e "\n# Generating static files"
hugo
echo -e "\n# Moving to public\n"
cd public
git add .
git status --short
echo
git commit -m "$1"
git push
echo -e "\n# Moving back up to root\n"
cd ..
git add -u
git status --short
echo
git commit -m "$1"
git push
