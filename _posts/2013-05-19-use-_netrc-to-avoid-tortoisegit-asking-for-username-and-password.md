---
layout: post
title: "Use netrc to avoid TortoiseGit asking for username and password"
description: "How to use _netrc in order to avoid TortoiseGit asking for username and password."
categories: [notes]
tags: [git, tortoisegit, windows]
alias: [/2013/05/19/]
---
1. Open `%USERPROFILE%` from Windows Explorer
2. Create a new file with name `_netrc`
3. Put the following lines in

> machine github.com<br />
> login yizeng<br />
> password the_password