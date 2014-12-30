---
layout: post
title: "Install TortoiseHg on Linux Mint"
description: "How to install TortoiseHg on Linux Mint 15 via official PPA."
categories: [notes]
tags: [linux mint, tortoisehg]
alias: [/2013/07/02/]
last_updated: March 18, 2014
---
This is a note for how to install [TortoiseHg][TortoiseHg]
on Linux Mint 15 via [TortoiseHg Release PPA][TortoiseHg Release PPA].

**Note**:

- It is suggested that do NOT also include a [Mercurial PPA][Mercurial PPA] in the system,
as TortoiseHg has strict version requirements for which versions of Mercurial it can interoperate with.
- [TortoiseHg PPA Stable Snapshots][TortoiseHg PPA Stable Snapshots] provides packages of the latest TortoiseHg release.

**Steps**:

1. Add [TortoiseHg Release PPA][TortoiseHg Release PPA] to the system

	> sudo add-apt-repository ppa:tortoisehg-ppa/releases

2. Get information on the newest versions of packages and their dependencies

	> sudo apt-get update

3. Install `tortoisehg` package

	> sudo apt-get install tortoisehg

4. Check if installation succeeded

	> hg \--version

	Terminal output for example:

	   Mercurial Distributed SCM (version 2.8.2)
	   (see http://mercurial.selenic.com for more information)

	   Copyright (C) 2005-2013 Matt Mackall and others
	   This is free software; see the source for copying conditions. There is NO
	   warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

[TortoiseHg]: http://tortoisehg.bitbucket.org/
[TortoiseHg Release PPA]: https://launchpad.net/~tortoisehg-ppa/+archive/releases
[Mercurial PPA]: https://launchpad.net/~mercurial-ppa/+archive/releases
[TortoiseHg PPA Stable Snapshots]: https://launchpad.net/~tortoisehg-ppa/+archive/stable-snapshots
[TortoiseHg Release PPA]: https://launchpad.net/~tortoisehg-ppa/+archive/releases