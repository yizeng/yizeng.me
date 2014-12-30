---
layout: post
title: "Install ChromeDriver and PhantomJS on Linux Mint"
description: "How to install ChromeDriver and PhantomJS on Linux Mint (Ubuntu)"
categories: [notes]
tags: [chromedriver, linux mint, phantomjs, selenium-webdriver]
alias: [/2014/04/20/]
---
A note on how to install ChromeDriver and PhantomJS on Linux Mint (Ubuntu),
which would be handy for writing Selenium WebDriver tests
to run against Chrome/PhantomJS directly without specifying paths in code.

## Install ChromeDriver
{: #install-chromedriver}

1. Install unzip

	   sudo apt-get install unzip

2. Download latest version from [official website](http://chromedriver.storage.googleapis.com/index.html)
   and upzip it (here for instance, to `~/Downloads`)

	   wget -N http://chromedriver.storage.googleapis.com/2.9/chromedriver_linux64.zip -P ~/Downloads
	   unzip ~/Downloads/chromedriver_linux64.zip -d ~/Downloads

3. Make it executable and move to `/usr/local/share`

	   chmod +x ~/Downloads/chromedriver
	   sudo mv -f ~/Downloads/chromedriver /usr/local/share/chromedriver

4. Create symbolic links

	   sudo ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver
	   sudo ln -s /usr/local/share/chromedriver /usr/bin/chromedriver

## Install PhantomJS
{: #install-phantomjs}

1. Download latest version from [official website](http://phantomjs.org/download.html)
   and extract it (here for instance, to `~/Downloads`)

	   wget -N https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-x86_64.tar.bz2 -P ~/Downloads
	   tar xjf ~/Downloads/phantomjs-1.9.7-linux-x86_64.tar.bz2 -C ~/Downloads

2. Move the folder to `/usr/local/share`

	   sudo mv -f ~/Downloads/phantomjs-1.9.7-linux-x86_64 /usr/local/share/phantomjs-1.9.7-linux-x86_64

3. Create symbolic links

	   sudo ln -s /usr/local/share/phantomjs-1.9.7-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs
	   sudo ln -s /usr/local/share/phantomjs-1.9.7-linux-x86_64/bin/phantomjs /usr/bin/phantomjs

## References
{: #references}

- [Running Selenium Tests with ChromeDriver on Linux](http://selftechy.com/2011/08/17/running-selenium-tests-with-chromedriver-on-linux)
- [How can I setup & run PhantomJS on Ubuntu?](http://stackoverflow.com/q/8778513/1177636)
