---
layout: post
title: "Install ChromeDriver and PhantomJS on Linux Mint"
description: "How to install ChromeDriver and PhantomJS on Linux Mint (Ubuntu)"
categories: [notes]
tags: [chromedriver, linux mint, phantomjs, selenium webdriver]
redirect_from:
  - /2014/04/20/
last_updated: May 27, 2017
---

> Recently Updated - May 27, 2017

A note on how to install ChromeDriver and PhantomJS on Linux Mint (Ubuntu),
which would be handy for writing Selenium WebDriver tests
to run against Chrome/PhantomJS directly without specifying paths in code.

## Install ChromeDriver

1. Install unzip

	   sudo apt-get install unzip

2. Download latest version from [official website](http://chromedriver.storage.googleapis.com/index.html)
   and upzip it (here for instance, verson `2.29` to `~/Downloads`)

	   wget -N http://chromedriver.storage.googleapis.com/2.29/chromedriver_linux64.zip -P ~/Downloads
	   unzip ~/Downloads/chromedriver_linux64.zip -d ~/Downloads

3. Move to `/usr/local/share` and make it executable

	   sudo mv -f ~/Downloads/chromedriver /usr/local/share/
	   sudo chmod +x /usr/local/share/chromedriver

4. Create symbolic links

	   sudo ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver
	   sudo ln -s /usr/local/share/chromedriver /usr/bin/chromedriver

## Install PhantomJS

1. Download latest version from [official website](http://phantomjs.org/download.html)
   and extract it (here for instance, verson `2.1.1` to `~/Downloads`)

	   wget -N https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 -P ~/Downloads
	   tar xjf ~/Downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 -C ~/Downloads

2. Move the folder to `/usr/local/share`

	   sudo mv -f ~/Downloads/phantomjs-2.1.1-linux-x86_64 /usr/local/share/phantomjs-2.1.1-linux-x86_64

3. Create symbolic links

	   sudo ln -s /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs
	   sudo ln -s /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/bin/phantomjs

## References

- [Running Selenium Tests with ChromeDriver on Linux](http://selftechy.com/2011/08/17/running-selenium-tests-with-chromedriver-on-linux)
- [How can I setup & run PhantomJS on Ubuntu?](http://stackoverflow.com/q/8778513/1177636)
