#!/usr/bin/env bash

hugo
echo -e "\n# Moving to public\n"
cd public
git add .
git status --short
echo -e "\n"
git commit -m "Update"
git push
echo -e "\n# Moving back up to root\n"
cd ..
git add -u
git status --short
echo -e "\n"
git commit -m "Update"
git push
git status
