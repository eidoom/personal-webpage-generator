#!/usr/bin/env bash

hugo
echo Moving to public\n
cd public
git add .
git status --short
git commit -m "Update"
git push
echo Moving back up to root
cd ..
git add -u
git status --short
git commit -m "Update"
git push
git status
