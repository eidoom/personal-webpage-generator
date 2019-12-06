#!/usr/bin/env bash

git status
hugo
echo Moving to public
cd public
git add .
git status
git commit -m "Update"
git push
echo Moving back up to root
cd ..
git add -u
git status
git commit -m "Update"
git push
git status
