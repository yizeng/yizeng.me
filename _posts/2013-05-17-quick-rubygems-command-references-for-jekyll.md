---
layout: post
title: "Quick RubyGems Command References for Jekyll"
description: "Some quick common RubyGems command references that I use for maintaining my Jekyll site 'yizeng.me'."
categories: [notes]
tags: [jekyll, ruby]
alias: [/2013/05/17/]
last_updated: March 18, 2014
---
Apprently `gem --help` would be helpful but just too long to read, the following commands are just for quick references purpose.

- Install/Uninstall gem

  	gem install jekyll
  	gem uninstall jekyll

- Install specific version of gem

  	gem install pygments.rb --version 0.4.2

- Uninstall specific versions of gem

	+ Prompt 'Select gem to uninstall' and let the user choose

		  gem uninstall jekyll

	+ Uninstall specific version

		  gem uninstall jekyll --version 1.0.1
		  gem uninstall jekyll --version '<1.0.1'

	+ Remove all old versions of jekyll

		  gem cleanup jekyll

- List all local gem

  	gem list --local

- List all versions of gem

  	gem list --all

- List gem with specific name

  	gem list jekyll

- Update installed gem

  	gem update

- Update installed system gem

  	gem update --system
