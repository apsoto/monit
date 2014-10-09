# Overview #
Chef cookbook for the [monit](http://mmonit.com/monit/) monitoring and
management tool.

[![Build Status](https://travis-ci.org/apsoto/monit.svg?branch=master)](https://travis-ci.org/apsoto/monit)

# Submitting a change #
 * Make sure your code follows existing conventions
 * Squash your PR into a single commit
 * Rebase onto master if needed
 * Add Chefspec test
 * Make sure foodcritic is happy
 * Make sure your PR is marked as "safe to merge"

# Changelog #
[Changelog](https://github.com/apsoto/monit/blob/master/Changelog)

# How to add to your cookbook repository #

## Download the tarball ##
It's up on the opscode
[cookbook community](http://community.opscode.com/cookbooks/monit) site.

## Vendor via knife ##

    $ knife cookbook site download monit

## Track upstream changes via git ##
I use git submodules for my chef repos so I can push/pull changes with minimal
hassle.

For more info, check out the [Pro Git](http://progit.org/book/ch6-6.html) book.

#### Add the monit repo ####

    $ cd YOUR_REPO_ROOT
    $ git submodule add git://github.com/apsoto/monit.git cookbooks/monit



