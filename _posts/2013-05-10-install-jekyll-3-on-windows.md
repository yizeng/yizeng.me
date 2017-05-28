---
layout: post
title: "Install Jekyll 3 on Windows"
description: "How to install and setup Jekyll 3 on a Windows machine."
categories: [notes]
tags: [jekyll, ruby, windows]
redirect_from:
  - /2013/05/10/
  - /2013/05/10/setup-jekyll-on-windows/
last_updated: January 07, 2017
---
> Recently Updated - January 07, 2017

* Kramdown table of contents
{:toc .toc}

## Install Ruby

1. Go to <http://rubyinstaller.org/downloads/>

2. In "RubyInstallers" section, click a version to download.<br />
For example, `Ruby 2.3.3-p222 (x64)` is the Windows installer for Ruby 2.3.3 x64 on 64-bit machines.

3. Install through the installer

    - Keep the default directory `C:/Ruby23-x64` if possible,
    please note installer advises that "Please avoid any folder name that contains spaces (e.g. Program Files)."
    - Tick "Add Ruby executables to your PATH" checkbox, so PATH will be updated automatically to avoid headaches.

    <a class="post-image" href="/assets/images/posts/2013-05-11-ruby-installer.png">
    <img itemprop="image" data-src="/assets/images/posts/2013-05-11-ruby-installer.png" src="/assets/javascripts/unveil/loader.gif" alt="Windows Ruby installer" />
    </a>

4. Open up a command prompt window and type in the following command, to see if Ruby has been install correctly or not.

        ruby -v

    Example output:

      > ruby 2.3.3p222 (2016-11-21 revision 56859) [x64-mingw32]

## Install DevKit

The DevKit is a toolkit that makes it easy to build
and use native C/C++ extensions such as RDiscount and RedCloth for Ruby on Windows.
Detailed installation instructions can be found on its [wiki page][Full installation instructions].

1. Go to <http://rubyinstaller.org/downloads/> again.

2. Download "DEVELOPMENT KIT" installer that matches the Windows architecture and the Ruby version just installed.
For instance, `DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe` is for 64-bit Windows with Ruby 2.3.3 x64.

    Here is a list about how to choose the correct DevKit version:

    > **Ruby 1.8.6 to 1.9.3**: DevKit tdm-32-4.5.2<br />
    > **Ruby 2.0.0**: DevKit mingw64-32-4.7.2<br />
    > **Ruby 2.0.0 x64**: DevKit mingw64-64-4.7.2

3. Run the installer and extract it to a folder, e.g. `C:\DevKit`.

4. Initialize and create `config.yml` file.

    Insdie `C:/DevKit`, open up a command prompt window and execute the following commands:

       ruby dk.rb init
       notepad config.yml

5. In opened notepad window, if it's not already there, add a new line `- C:/Ruby23-x64` at the end, save and close.

6. Back to the Command Prompt, review (optional) and install.

       ruby dk.rb review
       ruby dk.rb install

## Install Jekyll and Bundler

1. Install Jekyll and [Bundler](http://bundler.io/) gems

       gem install jekyll bundler

2. Verify that Jekyll gem has been installed properly

       jekyll -v

    Example output:

      > jekyll 3.3.1

3. Verify that Bundler gem has been installed properly

       bundle -v

    Example output:

      > Bundler version 1.13.7

## Start Jekyll

Following the commands on official [Jekyll Quick-start guide][Jekyll Quick-start guide],
a new Jekyll blog should be created and can be browsed at [127.0.0.1:4000](http://127.0.0.1:4000).

    jekyll new myblog
    cd myblog
    bundle exec jekyll serve

<a class="post-image" href="/assets/images/posts/2013-05-11-new-jekyll-3-site.png">
<img itemprop="image" data-src="/assets/images/posts/2013-05-11-new-jekyll-3-site.png" src="/assets/javascripts/unveil/loader.gif" alt="New Jekyll 3 Site" />
</a>

## Troubleshooting

1. Error message:

        "ruby" is not recognized as an internal or external command, operable program or batch file.

    **Reason**: Program is not properly installed, or the PATH has not been set correctly.

    **Solution**: Ensure the program has been installed correctly.
    Then add it to the PATH manually if needed, see the steps below[^1].

    > 1. Hold Win and press Pause.
    > 2. Click Advanced System Settings.
    > 3. Click Environment Variables.
    > 4. Append `;C:\Ruby23-x64\bin` to the Path variable.
    > 5. Restart Command Prompt.

2. Error message:

       ERROR:  Error installing jekyll:
       ERROR: Failed to build gem native extension.

       "C:/Program Files/Ruby23-x64/bin/ruby.exe" extconf.rb

       creating Makefile
       make generating stemmer-x64-mingw32.def
       compiling porter.c
       ...
       make install
       /usr/bin/install -c -m 0755 stemmer.so C:/Program Files/Ruby23-x64/lib/ruby/gems/2.0.0/gems/fast-stemmer-1.0.2/li
       /usr/bin/install: target `Files/Ruby23-x64/lib/ruby/gems/2.0.0/gems/fast-stemmer-1.0.2/lib' is not a directory
       make: *** [install-so] Error 1

    **Reason**: Ruby has been installed to a folder with spaces.

    **Solution**: Re-install Ruby, but this time install it to a folder without spaces,
    or simply keep the default directory when installing.

3. Error message:

        New jekyll site installed in C:/Code/GitHub/blog.
          Dependency Error: Yikes! It looks like you don't have bundler or one of its dependencies installed. In order to use Jekyll as currently configured, you'll need to install this gem. The full error message from Ruby is: 'cannot load such file -- bundler' If you run into trouble, you can find helpful resources at http://jekyllrb.com/help/!
        jekyll 3.3.1 | Error:  bundler

     **Reason**: Bundler gem was not installed.

     **Solution**: Run command `gem install bundler`

4. Error message:

       Generating... Liquid Exception: No such file or directory - python c:/Ruby23-x64/lib/ruby/gems/2.0.0/gems/pygments.rb-0.4.2/lib/pygments/mentos.py in 2013-04-22-yizeng-hello-world.md

    **Reason**: If you are using Jekyll 2 with Pygments, it mostly like to that Pygments is not properly installed or the PATH is yet to be effective.

    **Solution**: First make sure Pygments has been installed and PATH for Python is correct without no spaces or trailing slash.
    Then restart Command Prompt. If it's not working, try logout Windows and log back in again.
    Or even try the ultimate and most powerful solution - "turning the computer off and on again".

5. Error message:

       Generating... Liquid Exception: No such file or directory - /bin/sh in _posts/2013-04-22-yizeng-hello-world.md

    **Reason**: Incompatibility issue with pygments.rb versions 0.5.1/0.5.2.

    **Solution**: Downgrade pygments.rb gem from 0.5.1/0.5.2 to version 0.5.0.

        gem uninstall pygments.rb --version 0.5.2
        gem install pygments.rb --version 0.5.0

6. Error message:

       c:/Ruby23-x64/lib/ruby/2.0.0/rubygems/dependency.rb:296:in `to_specs': Could not find 'pygments.rb' (~> 0.4.2) - did find: [pygments.rb-0.5.0] (Gem::LoadError)
       from c:/Ruby23-x64/lib/ruby/2.0.0/rubygems/specification.rb:1196:in `block in activate_dependencies'
       from c:/Ruby23-x64/lib/ruby/2.0.0/rubygems/specification.rb:1185:in `each'
       from c:/Ruby23-x64/lib/ruby/2.0.0/rubygems/specification.rb:1185:in `activate_dependencies'
       from c:/Ruby23-x64/lib/ruby/2.0.0/rubygems/specification.rb:1167:in `activate'
       from c:/Ruby23-x64/lib/ruby/2.0.0/rubygems/core_ext/kernel_gem.rb:48:in`gem'
       from c:/Ruby23-x64/bin/jekyll:22:in `<main>'`

    **Reason**: As suggested in the message, pygments.rb 0.4.2 is needed, while version 0.5.0 is found.
    (This issue happened a while back with an old version of Jekyll 2, which should have been fixed by now.)

    **Solution**: Downgrade pygments.rb gem to version 0.4.2

        gem uninstall pygments.rb --version 0.5.0
        gem install pygments.rb --version 0.4.2

7. Error message:

       Generating... You are missing a library required for Markdown. Please run:
       $ [sudo] gem install rdiscount
       Conversion error: There was an error converting '_posts/2013-04-22-yizeng-hello-world.md/#excerpt'.

       ERROR: YOUR SITE COULD NOT BE BUILT:
          ------------------------------------
          Missing dependency: rdiscount

    **Reason**: If you are still on Jekyll 2, dependency `rdiscount` is missing.
    This is most likely because the site selects [rdiscount](https://github.com/davidfstr/RDiscount) as Markdown engine,
    which is not Jekyll's default and needs to be installed manually.

    **Solution**: Run command `gem install rdiscount`

8. Error message:

       c:/Ruby23-x64/lib/ruby/site_ruby/2.0.0/rubygems/core_ext/kernel_require.rb:55:in `require': cannot load such file -- wdm (LoadError)
       from c:/Ruby23-x64/lib/ruby/site_ruby/2.0.0/rubygems/core_ext/kernel_require.rb:55:in `require'
       from c:/Ruby23-x64/lib/ruby/gems/2.0.0/gems/listen-1.3.1/lib/listen/adapter.rb:207:in `load_dependent_adapter'
       from c:/Ruby23-x64/lib/ruby/gems/2.0.0/gems/listen-1.3.1/lib/listen/adapters/windows.rb:33:in `load_dependent_a
       dapter'
       ...

    **Reason**: `wdm` gem could not be found. Since Jekyll only supports *nix systems officially,
    [Windows Directory Monitor][WDM] is therefore not included among Jekyll dependencies.

    **Solution**: Add `gem 'wdm', '>= 0.1.0' if Gem.win_platform?` to `Gemfile` and run `bundle install` again.

[Full installation instructions]: https://github.com/oneclick/rubyinstaller/wiki/Development-Kit#installation-instructions
[Jekyll Quick-start guide]: http://jekyllrb.com/docs/quickstart/
[WDM]: https://github.com/Maher4Ever/wdm

[^1]: <a href="http://stackoverflow.com/a/6318188/1177636">Adding Python Path on Windows 7</a> by melhosseiny.
