---
layout: post
title: "Setup Jekyll on Windows"
description: "How to install and setup Jekyll on a Windows machine."
categories: [notes, popular]
tags: [jekyll, ruby, windows]
alias: [/2013/05/10/]
last_updated: December 31, 2014
utilities: fancybox, unveil
---
* Kramdown table of contents
{:toc .toc}

## Install Ruby
{: #install-ruby}

1. Go to <http://rubyinstaller.org/downloads/>

2. In "RubyInstallers" section, click a version to download.<br />
For example, `Ruby 2.0.0-p598 (x64)` is the Windows installer for Ruby 2.0.0 x64 on 64-bit machines.

3. Install through the installer

	- Keep the default directory `C:\Ruby200-x64` if possible,
		please note installer advises that "Please avoid any folder name that contains spaces (e.g. Program Files)."
	- Tick "Add Ruby executables to your PATH" checkbox, so PATH will be updated automatically to avoid headaches.

	<a class="post-image" href="/assets/images/posts/2013-05-11-ruby-installer.png">
	<img itemprop="image" data-src="/assets/images/posts/2013-05-11-ruby-installer.png" src="/assets/js/unveil/loader.gif" alt="Windows Ruby installer" />
	</a>

4. Open up a command prompt window and type in the following command, to see if Ruby has been install correctly or not.

	> ruby -v

	Example output:

	> ruby 2.0.0p598 (2014-11-13) [x64-mingw32]

## Install DevKit
{: #install-devkit}

The DevKit is a toolkit that makes it easy to build
and use native C/C++ extensions such as RDiscount and RedCloth for Ruby on Windows.
Detailed installation instructions can be found on its [wiki page][Full installation instructions].

1. Go to <http://rubyinstaller.org/downloads/> again.

2. Download "DEVELOPMENT KIT" installer that matches the Windows architecture and the Ruby version just installed.
For instance, `DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe` is for 64-bit Windows with Ruby 2.0.0 x64.

	Here is a list about how to choose the correct DevKit version:

	> **Ruby 1.8.6 to 1.9.3**: DevKit tdm-32-4.5.2<br />
	> **Ruby 2.0.0**: DevKit mingw64-32-4.7.2<br />
	> **Ruby 2.0.0 x64**: DevKit mingw64-64-4.7.2

3. Run the installer and extract it to a folder, e.g. `C:\DevKit`.

4. Initialize and create `config.yml` file. Type in the following commands in command Prompt window:

	> cd "C:\DevKit"<br />
	> ruby dk.rb init<br />
	> notepad config.yml

5. In opened notepad window, add a new line `- C:\Ruby200-x64` at the end if it's not already there, save and close.

6. Back to the Command Prompt, review (optional) and install.

	> ruby dk.rb review<br />
	> ruby dk.rb install

## Install Jekyll
{: #install-jekyll}

1. Verify that gem has been installed properly

	> gem -v

	Example output:

	> 2.4.5

2. Install Jekyll gem

	> gem install jekyll

## Install Pygments
{: #install-pygments}

The default syntax highlighting engine in Jekyll is [Pygments](http://pygments.org/).
It requires Python to be installed and `highlighter` field to be set to `pygments` in site’s configuration file `_config.yml`.

Recently, Jekyll has added another highlighting engine called [Rouge](https://github.com/jayferd/rouge),
which doesn't support as many languages as Pygments at the moment, but it's Ruby native and Python-free.
More details can be followed [here](http://jekyllrb.com/docs/templates/#code-snippet-highlighting).

### Install Python
{: #install-python}

1. Go to <http://www.python.org/download/>
2. Download appropriate version of Python windows installer, e.g. `Python 2.7.8 Windows Installer`.
Note that Python 2 is preferred since Python 3 might not be functioning as intended at the time of writing.
3. Install
4. Set the installation directory (e.g. `C:\Python27`) to PATH. (How to? See [Troubleshooting #1](#troubleshooting))
5. Verify Python installation

	> python \--version

	Example output:

	> Python 2.7.8

### Install 'Easy Install'
{: #install-easy-install}

1. Visit <https://pypi.python.org/pypi/setuptools#installation-instructions> for detailed installation instructions.
2. For best results, uninstall previous versions FIRST (see [Uninstalling](https://pypi.python.org/pypi/setuptools#uninstalling)).
3. For machines with PowerShell 3 installed, start up Powershell as administrator and paste this command:
	
	> (Invoke-WebRequest https://bootstrap.pypa.io/ez_setup.py).Content \| python -

4. For Windows without PowerShell 3,
download [ez_setup.py](https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py)
and save it, for example, to `C:\`. Then run it using Python in a command prompt window:

	> python "C:\ez_setup.py"

5. Add 'Python Scripts' directory (e.g. `C:\Python27\Scripts`) to PATH.

### Install Pygments
{: #install-pygments-2}

1. Verify easy_install is installed properly

	> easy_install \--version

	Example output:

	> setuptools 10.0.1

2. Install Pygments using "easy_install"

	> easy_install Pygments

## Start Jekyll
{: #start-jekyll}

Following the commands on official [Jekyll Quick-start guide][Jekyll Quick-start guide],
a new Jekyll blog should be created and can be browsed at [localhost:4000](http://localhost:4000).

> jekyll new myblog<br />
> cd myblog<br />
> jekyll serve

## Troubleshooting
{: #troubleshooting}

1. Error message:

	   “python” is not recognized as an internal or external command, operable program or batch file.

	**Alternatives**: "python" here can also be "ruby", "gem" or "easy_install", etc.

	**Reason**: Program is not properly installed, or the PATH has not been set correctly.

	**Solution**: Ensure the program has been installed correctly.
		Then add it to the PATH manually, see the steps below{% footnote 1 %}.

	> 1. Hold Win and press Pause.
	> 2. Click Advanced System Settings.
	> 3. Click Environment Variables.
	> 4. Append `;C:\python27` to the Path variable.
	> 5. Restart Command Prompt.

2. Error message:

	   ERROR:  Error installing jekyll:
	   ERROR: Failed to build gem native extension.

	   "C:/Program Files/Ruby/Ruby200-x64/bin/ruby.exe" extconf.rb

	   creating Makefile
	   make generating stemmer-x64-mingw32.def
	   compiling porter.c
	   ...
	   make install
	   /usr/bin/install -c -m 0755 stemmer.so C:/Program Files/Ruby/Ruby200-x64/lib/ruby/gems/2.0.0/gems/fast-stemmer-1.0.2/li
	   /usr/bin/install: target `Files/Ruby/Ruby200-x64/lib/ruby/gems/2.0.0/gems/fast-stemmer-1.0.2/lib' is not a directory
	   make: *** [install-so] Error 1

	**Reason**: Ruby has been installed to a folder with spaces.

	**Solution**: Re-install Ruby, but this time install it to a folder without spaces,
	or simply keep the default directory when installing.

3. Error message:

	   Generating... Liquid Exception: No such file or directory - python c:/Ruby200-x64/lib/ruby/gems/2.0.0/gems/pygments.rb-0.4.2/lib/pygments/mentos.py in 2013-04-22-yizeng-hello-world.md

	**Reason**: Pygments is not properly installed or the PATH is yet to be effective.

	**Solution**: First make sure Pygments has been installed and PATH for Python is correct without no spaces or trailing slash.
		Then restart Command Prompt. If it's not working, try logout Windows and log back in again.
		Or even try the ultimate and most powerful solution - "turning the computer off and on again".

4. Error message:

	   Generating... Liquid Exception: No such file or directory - /bin/sh in _posts/2013-04-22-yizeng-hello-world.md

	**Reason**: Incompatibility issue with pygments.rb versions 0.5.1/0.5.2.

	**Solution**: Downgrade pygments.rb gem from 0.5.1/0.5.2 to version 0.5.0.

	> gem uninstall pygments.rb \--version 0.5.2<br />
	> gem install pygments.rb \--version 0.5.0

5. Error message:

	   c:/Ruby200-x64/lib/ruby/2.0.0/rubygems/dependency.rb:296:in `to_specs': Could not find 'pygments.rb' (~> 0.4.2) - did find: [pygments.rb-0.5.0] (Gem::LoadError)
	   from c:/Ruby200-x64/lib/ruby/2.0.0/rubygems/specification.rb:1196:in `block in activate_dependencies'
	   from c:/Ruby200-x64/lib/ruby/2.0.0/rubygems/specification.rb:1185:in `each'
	   from c:/Ruby200-x64/lib/ruby/2.0.0/rubygems/specification.rb:1185:in `activate_dependencies'
	   from c:/Ruby200-x64/lib/ruby/2.0.0/rubygems/specification.rb:1167:in `activate'
	   from c:/Ruby200-x64/lib/ruby/2.0.0/rubygems/core_ext/kernel_gem.rb:48:in`gem'
	   from c:/Ruby200-x64/bin/jekyll:22:in `<main>'`

	**Reason**: As suggested in the message, pygments.rb 0.4.2 is needed, while version 0.5.0 is found.
	(This issue happened a while back with an old version of Jekyll, which should have been fixed by now.)

	**Solution**: Downgrade pygments.rb gem to version 0.4.2

	> gem uninstall pygments.rb \--version 0.5.0<br />
	> gem install pygments.rb \--version 0.4.2

6. Error message:

	   Generating... You are missing a library required for Markdown. Please run:
	   $ [sudo] gem install rdiscount
	   Conversion error: There was an error converting '_posts/2013-04-22-yizeng-hello-world.md/#excerpt'.

	   ERROR: YOUR SITE COULD NOT BE BUILT:
	      ------------------------------------
	      Missing dependency: rdiscount

	**Reason**: Dependency `rdiscount` is missing.
	This is most likely because the site selects [rdiscount](https://github.com/davidfstr/RDiscount) as Markdown engine,
	which is not Jekyll's default and needs to be installed manually.

	**Solution**:

	> gem install rdiscount

7. Error message:

	   c:/Ruby200-x64/lib/ruby/site_ruby/2.0.0/rubygems/core_ext/kernel_require.rb:55:in `require': cannot load such file -- wdm (LoadError)
	   from c:/Ruby200-x64/lib/ruby/site_ruby/2.0.0/rubygems/core_ext/kernel_require.rb:55:in `require'
	   from c:/Ruby200-x64/lib/ruby/gems/2.0.0/gems/listen-1.3.1/lib/listen/adapter.rb:207:in `load_dependent_adapter'
	   from c:/Ruby200-x64/lib/ruby/gems/2.0.0/gems/listen-1.3.1/lib/listen/adapters/windows.rb:33:in `load_dependent_a
	   dapter'
	   ...

	**Reason**: `wdm` gem could not be found. Since Jekyll only supports *nix systems officially,
		[Windows Directory Monitor][WDM] is therefore not included among Jekyll dependencies.

	**Solution**:

	> gem install wdm

[Full installation instructions]: https://github.com/oneclick/rubyinstaller/wiki/Development-Kit#installation-instructions
[Jekyll Quick-start guide]: http://jekyllrb.com/docs/quickstart/
[WDM]: https://github.com/Maher4Ever/wdm

{% footnotes %}
<p id="footnote-1">
[1]: <a href="http://stackoverflow.com/a/6318188/1177636">Adding Python Path on Windows 7</a> by melhosseiny.
{% reverse_footnote 1 %}
</p>
{% endfootnotes %}