#!/usr/bin/env bash

hugo
echo -e "\nMoving to public\n"
cd public
git add .
git status --short
git commit -m "Update"
git push
echo -e "\nMoving back up to root\n"
cd ..
git add -u
git status --short
git commit -m "Update"
git push
git status
