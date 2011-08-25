# Overview #
Chef cookbook for the [monit](http://mmonit.com/monit/) monitoring and
management tool.

# How to add to your cookbook repository #

## Download the tarball ##
It's up on the opscode
[cookbook community](http://community.opscode.com/cookbooks/monit) site.

## Vendor via knife ##

    $ knife cookbook site download monit

## Track upstream changes via git ##
This is what I use for my chef repos so I can push/pull changes with minimal
hassle.

I use the subtree merge strategy explained in the
[Pro Git](http://progit.org/book/ch6-7.html) book.

#### Track the monit repo ####
    $ cd YOUR_REPO_ROOT
    $ git remote add chef-monit-remote git://github.com/apsoto/chef-monit.git
    $ git fetch chef-monit-remote
    $ git checkout -b chef-monit-upstream chef-monit-remote/master
    $ git checkout master
    $ git read-tree --prefix=cookbooks/monit -u chef-monit-upstream

#### Pull in upstream changes ####
    $ git checkout chef-monit-upstream
    $ git pull
    $ git checkout master
    $ git merge --squash -s subtree --no-commit chef-monit-upstream

History
=======

version 0.6
-----------
 * Released to github
 * Defaults no alert on ACTION event.
   When you manually stop/start a service, alerting me about what I just did isn't useful.

