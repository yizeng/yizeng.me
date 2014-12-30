---
layout: post
title: "Download PDF files automatically in Firefox using Selenium WebDriver"
description: "Instead of dealing with 'Save file' dialog or in-browser PDF previewing,
this tutorial will demonstrate how to download PDF files automatically in Firefox using Selenium WebDriver."
categories: [articles, popular]
tags: [firefox, ruby, selenium-webdriver]
alias: [/2014/05/23]
utilities: fancybox, highlight, unveil
---
## A complete example
{: #a-complete-example }

For those who are willing to learn by examples right away,
here is a complete example of how to save PDF files automatically in Firefox using Selenium WebDriver.

{% highlight ruby %}
# Environment Tested:
# Windows 7, Ruby 2.0.0p451, Selenium 2.41.0, Firefox 29.0.1
require 'selenium-webdriver'

profile = Selenium::WebDriver::Firefox::Profile.new
profile["browser.download.folderList"] = 2
profile["browser.download.dir"] = 'C:\\'
profile["browser.helperApps.neverAsk.saveToDisk"] = 'application/pdf'

# disable Firefox's built-in PDF viewer
profile["pdfjs.disabled"] = true

# disable Adobe Acrobat PDF preview plugin
profile["plugin.scan.plid.all"] = false
profile["plugin.scan.Acrobat"] = "99.0"

driver = Selenium::WebDriver.for :firefox, :profile => profile
driver.get('http://static.mozilla.com/moco/en-US/pdf/mozilla_privacypolicy.pdf')
{% endhighlight %}


## A walk-through
{: #a-walk-through }

### Prevent Firefox from popping up "Save file" dialog
{: #prevent-firefox-from-popping-up-save-file-dialog }

As Selenium itself doesn't interact with system-level dialogs,
in order to download PDFs as part of the browser automation process,
it requires the help from either additional frameworks or an approach that handles downloading automatically.

<a class="post-image" href="/assets/images/posts/2014-05-23-firefox-save-file-dialog.png" title="'Save file' dialog in Firefox">
<img itemprop="image" data-src="/assets/images/posts/2014-05-23-firefox-save-file-dialog.png" src="/assets/js/unveil/loader.gif" alt="'Save file' dialog in Firefox" />
</a>

Firefox's [download manager preferences][Download Manager preferences] are controlled by some properties defined in [`about:config`][about:config] page,
which can be set programmatically while instantiating `FirefoxDriver` using Selenium WebDriver.

 - `browser.download.folderList` controls the default folder to download a file to.
   `0` indicates the Desktop; `1` indicates the systems default downloads location; `2` indicates a custom folder.
 - `browser.download.dir` holds the custom destination folder for downloading. It is activated if `browser.download.folderList` has been set to `2`.
 - `browser.helperApps.neverAsk.saveToDisk` stores a comma-separated list of MIME types to save to disk without asking what to use to open the file.

{% highlight ruby %}
profile = Selenium::WebDriver::Firefox::Profile.new
profile["browser.download.folderList"] = 2 # use the custom folder defined in "browser.download.dir" below
profile["browser.download.dir"] = 'C:\\'
profile["browser.helperApps.neverAsk.saveToDisk"] = 'application/pdf'
{% endhighlight %}

It is worth noting that the [MIME type][MIME type] defined here is `application/pdf`, which is a type that most PDF files use.
However, if the target PDF file has a non-standard MIME type, then "Save file" dialog might still show up.
In order to fix this issue, the actual MIME type has to be added into `browser.helperApps.neverAsk.saveToDisk` property,
which can be checked out using either of the following approaches:

- Upload file to online tools like [What MIME?][What MIME?]
- Download file and monitor MIME type in Chrome's developer tool or web debugging proxy like [Fiddler][Fiddler], [Charles][Charles], etc.

### Prevent Firefox from previewing PDFs
{: #prevent-firefox-from-previewing-pdfs }

#### For built-in PDF.js viewer
{: #for-built-in-pdf-js-viewer }

With the release of Firefox 19.0,
[PDF.js][PDF.js] has been integrated into Firefox to provide built-in ability of displaying PDF files inside browser.
It tries to parse and render PDFs into HTML5, which can be automated using Selenium WebDriver in theory.
However, to download PDFs instead of preview in Firefox,
another [`about:config`][about:config] entry needs to be changed to disable PDF.js.

{% highlight ruby %}
profile["pdfjs.disabled"] = true
{% endhighlight %}

#### For third party PDF viewers
{: #for-third-party-pdf-viewers }

Except for Firefox's built-in PDF viewer, there might be other third party plugins preventing Firefox from downloading PDFs automatically.
If a machine has [Adobe Reader][Adobe Reader] installed,
then default PDF viewing setting in Firefox might have been set to Adobe Acrobat without notice.

To avoid previewing PDFs with those plugins,
two more [`about:config`][about:config] entries need to be configured when starting WebDriver instance.

- `plugin.scan.plid.all` needs to be `false`, so that Firefox won't scan and load plugins.
- `plugin.scan.Acrobat` is a key that holds the minimum allowed version number that Adobe Acrobat is allowed to launch.
Setting it to a number larger than currently installed Adobe Acrobat version should do the trick.

{% highlight ruby %}
profile["plugin.scan.plid.all"] = false
profile["plugin.scan.Acrobat"] = "99.0"
{% endhighlight %}

[about:config]: http://kb.mozillazine.org/About:config
[Download Manager preferences]: https://developer.mozilla.org/en/docs/Download_Manager_preferences
[MIME type]: http://tools.ietf.org/html/rfc2046
[What MIME?]: http://mime.ritey.com/
[Fiddler]: http://www.telerik.com/fiddler
[Charles]: http://www.charlesproxy.com/
[PDF.js]: https://github.com/mozilla/pdf.js/
[Built-in viewer]: https://support.mozilla.org/en-US/kb/view-pdf-files-firefox-without-downloading-them#w_using-the-built-in-pdf-viewer
[Adobe Reader]: http://get.adobe.com/uk/reader/
