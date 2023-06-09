---
layout: default
parent: Topics
title: "Git/GitHub: Configuration"
description: "Configuring your laptop for git"
indent: true
prefix: "git/github: "
---

# {{page.title}} 

*{{page.description}}*

This page describes how to configure your laptop for git.

To set up your laptop for using command line git, type the following commands, substituting your real name (e.g. `Chris Gaucho`) in place of `"Your Name"` and your email address (e.g. `cgaucho@ucsb.edu`) in place of `"you@example.com"`.

```
git config --global user.name "Your Name"
git config --global user.email you@example.com
git config --global push.default simple
```

You should only have to ever do these steps once for any given computer system. The values of these global configuration options are stored in a file called `.gitconfig` in your home directory. Take a look by cd'ing into your home directory, and using the `more` command to list the contents of `.gitconfig`:

```
$ cd
$ more .gitconfig
[push]
    default = simple
[user]
    name = Chris Gaucho
    email = cgaucho@ucsb.edu
$
```

The `~/.gitconfig` file is a plain text file, and the options in it can also be set by just editing this file. Using the git config command is an alternative to hand editing this file, and is really just a way to be sure that the syntax ends up being right.

What about a GUI for git
------------------------

Even if you normally use a GUI interface for git, or a git plug in for an IDE such as Eclipse or Netbeans, it is important to learn the git commad line interface.

The official trainers from github.com themselves, emphasize strongly:

* git is fundamentally a command line tool
* We recommend that you learn the git command line so that if/when the GUI does something weird, you can get under the hood and fix things.
* Again to emphasize: "To learn git, you need to learn the command line interface."
