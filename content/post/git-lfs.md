+++
title = "Tracking large files with Git LFS"
date = "2019-12-15T12:15:44Z"
tags = ["linux", "git"]
categories = ["computing"]
description = "Tracking files with Git that I probably shouldn't"
draft=true
+++

I version control and backup my configuration files in `$HOME` using `git`.
On a recent `git push` on my Debian server, the remote (GitHub) rejected the push because one of my database files had exceed the file size limit of 100MB.
This was a clear sign that I should get around to setting up large file tracking properly.

Since I had a few local commits with the offending file, I first removed it from history without deleting the local file.
I used `git obliterate` from [`git-extras`](https://github.com/tj/git-extras) for this, with `--cached` so as not to delete the local file.

```sh
sudo apt install git-extras
cd REPO_DIR
git obliterate --cached path/to/big/db/file
```

Next I installed [Git Large File Support](https://github.com/git-lfs/git-lfs) (LFS), or `git lfs`, which [optimises the treatment of large files](https://www.atlassian.com/git/tutorials/git-lfs).
I set up LFS to track the files of non-human-readable format in my repository.
I also migrated over all such existing files in the repository's history to LFS.
This didn't work for some reason with the offending database file, which is why I deleted it above.

```sh
sudo apt install git-lfs
git lfs install # set up LFS for repo
git lfs track "*.zip" "*.pickle" "*.db" # configures .gitattributes
git add .gitattributes
git lfs migrate import --include="*.zip *.db *.pickle" --everything
git commit -am "Add LFS"
```

Then, I added back the large database file.

```sh
git add path/to/big/db/file
git commit -m "Added back LFS-tracked db file"
```

Now, GitHub only gives [1GB of LFS bandwidth per month for free](https://help.github.com/en/github/managing-large-files/about-storage-and-bandwidth-usage).
GitLab, on the other hand, doesn't limit the bandwidth.
GitLab does have [a size limit of 10GB per project for LFS files](https://gitlab.com/gitlab-com/www-gitlab-com/issues/1003), versus [GitHub's maximum repository size limit of 100GB](https://help.github.com/en/github/managing-large-files/what-is-my-disk-quota), but I need the bandwidth and I don't need more capacity. 
So, time to jump ship.

```sh
git remote rm origin 
git remote add origin git@gitlab.com:USER/REPO.git
git push -u origin --all
git push -u origin --tags
```

and on other computers, just change the origin and pull.
