---
layout: post
title: "Test WYSIWYG editors using Selenium WebDriver"
description: "How to write automated UI functional tests for WYSIWYG HTML editors
like TinyMCE, CKEditor, CLEditor, CuteEditor and Primefaces editor
using Selenium WebDriver Ruby binding."
categories: [articles, popular]
tags: [ruby, selenium-webdriver]
alias: [/2014/01/31/]
last_updated: April 20, 2014
utilities: highlight, show-hidden
---
> What is a WYSIWYG HTML editor?
<br />A WYSIWYG HTML editor provides an editing interface which resembles
how the page will be displayed in a web browser.
Because using a WYSIWYG editor may not require any HTML knowledge,
they are often easier for an average computer user to get started with.
([Wikipedia](http://en.wikipedia.org/wiki/HTML_editor#WYSIWYG_HTML_editors))

WYSIWYG HTML editors (an acronym for "What You See Is What You Get")
are widely used in web applications as embedded text editor nowadays.
The most common way of using those editors is framed editing,
which uses `<iframe>` instead of `<textarea>` and displays the content
inside the `<body>` element, however,
it makes the UI automation process a little bit different.

Taking [CKEditor][CKEditor] and [TinyMCE][TinyMCE] as examples,
this article will illustrate:

> 1. How to automate these editors using Selenium WebDriver's native Ruby API<br />
> 2. How to inject JavaScript through Selenium WebDriver to automate using editors' native JavaScript API.

For other editors created with similar technology, for instance, [CLEditor][CLEditor]
(including [Primefaces editor][Primefaces editor]) and [CuteEditor][CuteEditor],
the same logic also applies and should work in theory.

* Kramdown table of contents
{:toc .toc}

## WYSIWYG HTML editors' comparison
{: #wysiwyg-html-editors-comparison}

{% datatable %}
<tr>
	<th></th>
	<th>CKEditor (Standard)</th>
	<th>TinyMCE</th>
	<th>CLEditor</th>
</tr>
<tr>
	<td>Homepage</td>
	<td class="center"><a href="http://ckeditor.com/">ckeditor.com</a></td>
	<td class="center"><a href="http://www.tinymce.com/">tinymce.com</a></td>
	<td class="center"><a href="http://premiumsoftware.net/CLEditor">premiumsoftware.net</a></td>
</tr>
<tr>
	<td>Current version</td>
	<td class="center">4.3.2</td>
	<td class="center">4.0.15</td>
	<td class="center">1.4.4</td>
</tr>
<tr>
	<td>License</td>
	<td class="center"><a href="http://ckeditor.com/about/license">GPL, LGPL and MPL</a></td>
	<td class="center"><a href="http://www.tinymce.com/js/tinymce4/js/tinymce/license.txt">LGPL</a></td>
	<td class="center"><a href="http://premiumsoftware.net/CLEditor">MIT or GPL v2</a></td>
</tr>
<tr>
	<td>Size (Distribution package)</td>
	<td class="center">1022 kB</td>
	<td class="center">291.3 kB</td>
	<td class="center">20.4 kB</td>
</tr>
<tr>
	<td>Size (Core .js file)</td>
	<td class="center">461.2 kB</td>
	<td class="center">282.7 kB</td>
	<td class="center">12.5 kB</td>
</tr>
{% enddatatable %}

## Demos
{: #demos}

### CKEditor 4.3.2 Standard
{: #ckeditor-demo}

<textarea id="ckeditor"></textarea>
<script type="text/javascript" src="/assets/js/ckeditor/ckeditor.js"></script>
<script>CKEDITOR.replace('ckeditor');</script>

### TinyMCE 4.0.15
{: #tinymce-demo}

<textarea id="tinymce-editor"></textarea>
<script type="text/javascript" src="/assets/js/tinymce/tinymce.min.js"></script>
<script type="text/javascript">tinymce.init({selector: "#tinymce-editor"});</script>

## Automate using native Selenium WebDriver API
{: #automate-using-native-selenium-webdriver-api}

Both CKEditor and TinyMCE are JavaScript based,
which means they can be automated using Selenium WebDriver's native API just like any other HTML web applications.

### Click toolbar buttons
{: #click-toolbar-buttons}

WYSIWYG editors normally provide native methods to set raw HTML content directly through API,
automating the toolbar doesn't seem to be really necessary.
If it's needed to be done for some reason, it shouldn't be much of a problem,
because toolbar elements are just ordinary web elements,
the automating process is fairly straight-forward without any frame switching required.

>1. Find the elements by appropriate locators according to the HTML markup.
>2. Manipulate those elements see if they work or not.

Markup for CKEditor's toolbar "Numbered List" button: <a class="show-hidden">{{ site.translations.show }}</a>

{% hide %}
{% highlight html %}
<a id="cke_39" class="cke_button cke_button__numberedlist" href="javascript:void('Insert/Remove Numbered List')" title="Insert/Remove Numbered List" role="button">
    <span class="cke_button_icon cke_button__numberedlist_icon" >&nbsp;</span>
    <span id="cke_39_label" class="cke_button_label cke_button__numberedlist_label">Insert/Remove Numbered List</span>
</a>
{% endhighlight %}
{% endhide %}

Markup for TinyMCE's toolbar "Numbered List" button: <a class="show-hidden">{{ site.translations.show }}</a>

{% hide %}
{% highlight html %}
<div id="mce_11" class="mce-widget mce-btn" role="button" aria-label="Numbered list" aria-pressed="false">
    <button type="button">
        <i class="mce-ico mce-i-numlist"></i>
    </button>
</div>
{% endhighlight %}
{% endhide %}

Selenium WebDriver Ruby code to click the buttons:
{% highlight ruby %}
# click CKEditor's 'Numbered List' button
ckeditor_btn_numbered_list = driver.find_element(:class => "cke_button__numberedlist")
ckeditor_btn_numbered_list.click

# click TinyMCE editor's 'Numbered List' button
tinymce_btn_numbered_list = driver.find_element(:css => ".mce-btn[aria-label='Numbered list'] button")
tinymce_btn_numbered_list.click
{% endhighlight %}

### Switch into input iframe
{: #switch-into-input-iframe}

Although CKEditor and TinyMCE are initialized with `<textarea>` tag,
the editor body is actually constructed within an `<iframe>`, which is still technically a web element,
but all elements inside can only be accessed by WebDriver after switching into the iframe.
As seen in the HTML mark up below,
CKEditor's iframe can be identified using `class`, while TinyMCE's can be located by `id` directly.
Equivalent CSS Selectors and XPaths also exist if needed.

Markup for CKEditor's body: <a class="show-hidden">{{ site.translations.show }}</a>

{% hide %}
{% highlight html %}
<iframe src="" frameborder="0" class="cke_wysiwyg_frame cke_reset" title="Rich Text Editor, ckeditor">
    <html dir="ltr" lang="en-gb">
        <head></head>
        <body contenteditable="true" class="cke_editable cke_editable_themed cke_contents_ltr" spellcheck="false"></body>
    </html>
</iframe>
{% endhighlight %}
{% endhide %}

Markup for TinyMCE's body: <a class="show-hidden">{{ site.translations.show }}</a>

{% hide %}
{% highlight html %}
<iframe id="tinymce-editor_ifr" src='javascript:""' frameborder="0" title="Rich Text Area. Press ALT-F9 for menu. Press ALT-F10 for toolbar. Press ALT-0 for help">
    <html>
        <head></head>
        <body id="tinymce" class="mce-content-body " contenteditable="true" spellcheck="false"></body>
    </html>
</iframe>
{% endhighlight %}
{% endhide %}

#### Locate the iframes
{: #locate-the-iframes}

{% highlight ruby %}
ckeditor_frame = driver.find_element(:class => 'cke_wysiwyg_frame')
tinymce_frame = driver.find_element(:id => 'tinymce-editor_ifr')
{% endhighlight %}

#### Switch into
{: #switch-into-iframes}

{% highlight ruby %}
driver.switch_to.frame(ckeditor_frame) # ckeditor_frame or tinymce_frame, one at a time
{% endhighlight %}

#### Switch out (if necessary)
{: #switch-out-iframes}

If the WebDriver instance is already inside any kind of frames,
switch out the current frame to default content is required.
For example, after switching into CKEditor's iframe and sending some keys,
the only way to get into TinyMCE's input area is to
switch back to default content first,
then locate TinyMCE's iframe and switch into frame again.

{% highlight ruby %}
# if driver is already inside ckeditor_frame, switch out first
driver.switch_to.default_content

# then switch to another iframe, e.g. tinymce_frame
driver.switch_to.frame(tinymce_frame)
{% endhighlight %}

### Automate content
{: #automate-content}

#### Send keys
{: #send-keys}

After switching into the editor's `<iframe>`,
the text can be sent to the `<body>` directly, which is possible using Selenium's native `send_keys` method.
Unlike injecting JavaScript using editors' built-in methods or changing innerHTML,
the keys sent into the editor will always be inside `<p>` tag.
As a result, sending `<h1>Heading</h1>` won't show up as real WYSIWYG heading,
but in plain text. Furthermore, this approach has been reported behaving incorrectly on Firefox,
which might be better to avoid if possible.

{% highlight ruby %}
editor_body = driver.find_element(:tag_name => 'body')
editor_body.send_keys("<h1>Heading</h1>Yi Zeng")
{% endhighlight %}

#### Set innerHTML
{: #set-innerhtml}

In order to set editor content with raw HTML like WYSIWYG mode,
one approach is to change the innerHTML of editor body by injecting JavaScript.
In this case, sending `<h1>Heading</h1>` will actually show up as heading one.

{% highlight ruby %}
editor_body = driver.find_element(:css => 'body')
driver.execute_script("arguments[0].innerHTML = '<h1>Heading</h1>Yi Zeng'", editor_body)
{% endhighlight %}

#### Clear all input
{: #clear-all-input}

A quote from Selenium Ruby's API documentation on
[clear() method](http://selenium.googlecode.com/git/docs/api/rb/Selenium/WebDriver/Element.html#clear-instance_method):

> If this element is a text entry element, this will clear the value. Has no effect on other elements.

Although `clear()` method is stated as not available for non-text entry elements,
it seems it can actually clear the input iframe without any exceptions.

Apart from `clear()`,
an alternative is to use Selenium's [ActionBuilder](http://selenium.googlecode.com/svn/trunk/docs/api/rb/Selenium/WebDriver/ActionBuilder.html)
to construct an action chain to mimic keyboard shortcut pressing.
`Ctrl + A` will select all, then push `Backspace` to clear.

{% highlight ruby %}
# Method 1. Using clear() method
editor_body.clear

# Method 2. Using ActionBuilder
driver.action.click(editor_body)
             .key_down(:control)
             .send_keys("a")
             .key_up(:control)
             .perform
driver.action.send_keys(:backspace).perform
{% endhighlight %}

## Automate using editors' built-in JavaScript API
{: #automate-using-editors-built-in-javascript-api}

Without worrying about frame switching like using Selenium WebDriver's native API,
it would also be a stable solution to inject JavaScript directly
using `driver.execute_script()` to call editors' built-in JS functions.

### Set content
{: #set-content}

Both editors have built-in methods to set the content of entire input area.
CKEditor's [API](http://docs.ckeditor.com/#!/api/CKEDITOR.editor-method-setData) provides a method called `setData()`,
which replaces editor data with raw input HTML data.
Similar method `setContent()` also exists in TinyMCE editor's [API][TinyMCE setContent].

{% highlight ruby %}
driver.execute_script("CKEDITOR.instances.ckeditor.setData('<h1>Yi Zeng</h1> CKEditor')")
driver.execute_script("tinyMCE.activeEditor.setContent('<h1>Yi Zeng</h1> TinyMCE')")
{% endhighlight %}

### Clear content
{: #clear-content}

With the same logic, clearing content can be done by injecting JavaScript to set the entire content to empty string.

{% highlight ruby %}
driver.execute_script("CKEDITOR.instances.ckeditor.setData( '' )")
driver.execute_script("tinyMCE.activeEditor.setContent('')")
{% endhighlight %}

### Insert content
{: #insert-content}

Instead of setting the entire content, it is also possible to insert some content to the editors.
CKEditor's has a method called `insertHTML()`, which inserts content at currently selected position,
in TinyMCE, it's called `insertContent()`.

{% highlight ruby %}
driver.execute_script("CKEDITOR.instances.ckeditor.insertHtml('<p>Christchurch</p>')")
driver.execute_script("tinyMCE.activeEditor.insertContent('<p>Christchurch</p>')")
{% endhighlight %}

## Examples
{: #examples}

### Set content using Selenium WebDriver API
{: #set-content-using-selenium-webdriver-api}

<a class="show-hidden">{{ site.translations.show }}</a>

{% hide %}
{% highlight ruby %}
# Environment tested
# Linux Mint 16, Selenium 2.41.0, Chromium 33.0, ChromeDriver 2.9
require 'selenium-webdriver'

driver = Selenium::WebDriver.for :chrome
driver.get('http://yizeng.me/2014/01/31/test-wysiwyg-editors-using-selenium-webdriver/')

ckeditor_frame = driver.find_element(:class => 'cke_wysiwyg_frame')
tinymce_frame = driver.find_element(:id => 'tinymce-editor_ifr')

# Using JavaScript injection to set innerHTML, shown as WYSIWYG
driver.switch_to.frame(ckeditor_frame)
ck_editor_body = driver.find_element(:tag_name => 'body')
driver.execute_script("arguments[0].innerHTML = '<h1>CKEditor</h1>Yi Zeng'", ck_editor_body)

driver.switch_to.default_content

# Using native 'send_keys' method, all content are wrapped with <p>
driver.switch_to.frame(tinymce_frame)
tinymce_body = driver.find_element(:css => 'body')
tinymce_body.send_keys('<h1>TInyMCE</h1>Yi Zeng')
{% endhighlight %}
{% endhide %}

### Select all content
{: #select-all-content}

<a class="show-hidden">{{ site.translations.show }}</a>

{% hide %}
{% highlight ruby %}
# Environment tested
# Linux Mint 16, Selenium 2.41.0, Chromium 33.0, ChromeDriver 2.9
require 'selenium-webdriver'

driver = Selenium::WebDriver.for :chrome
driver.get('http://yizeng.me/2014/01/31/test-wysiwyg-editors-using-selenium-webdriver/')

driver.switch_to.frame(driver.find_element(:class => 'cke_wysiwyg_frame'))

ck_editor_body = driver.find_element(:tag_name => 'body')
ck_editor_body.send_keys("Yi Zeng")

driver.action.click(ck_editor_body)
             .key_down(:control)
             .send_keys("a")
             .key_up(:control)
             .perform
{% endhighlight %}
{% endhide %}

### Click "Numbered list" from toolbar
{: #click-numbered-list-from-toolbar}

<a class="show-hidden">{{ site.translations.show }}</a>

{% hide %}
{% highlight ruby %}
# Environment tested
# Linux Mint 16, Selenium 2.41.0, Chromium 33.0, ChromeDriver 2.9
require 'selenium-webdriver'

driver = Selenium::WebDriver.for :chrome
driver.get('http://yizeng.me/2014/01/31/test-wysiwyg-editors-using-selenium-webdriver/')

# click CKEditor's 'Numbered List' button
ckeditor_btn_numbered_list = driver.find_element(:class => "cke_button__numberedlist")
ckeditor_btn_numbered_list.click

# click TinyMCE editor's 'Numbered List' button
tinymce_btn_numbered_list = driver.find_element(:css => ".mce-btn[aria-label='Numbered list'] button")
tinymce_btn_numbered_list.click
{% endhighlight %}
{% endhide %}

### Set content using editors' API
{: #set-content-using-editors-api}

<a class="show-hidden">{{ site.translations.show }}</a>

{% hide %}
{% highlight ruby %}
# Environment tested
# Linux Mint 16, Selenium 2.41.0, Chromium 33.0, ChromeDriver 2.9
require 'selenium-webdriver'

driver = Selenium::WebDriver.for :chrome
driver.get('http://yizeng.me/2014/01/31/test-wysiwyg-editors-using-selenium-webdriver/')

driver.execute_script("CKEDITOR.instances.ckeditor.setData('<h1>Yi Zeng</h1> CKEditor')")
driver.execute_script("tinyMCE.activeEditor.setContent('<h1>Yi Zeng</h1> TinyMCE')")

driver.execute_script("CKEDITOR.instances.ckeditor.insertHtml('<p>Christchurch</p>')")
driver.execute_script("tinyMCE.activeEditor.insertContent('<p>Christchurch</p>')")
{% endhighlight %}
{% endhide %}

## References
{: #references}

- [Selenium Ruby binding API](http://selenium.googlecode.com/git/docs/api/rb/index.html)
- [RubyBindings WikiPage](https://code.google.com/p/selenium/wiki/RubyBindings)
- [CKEditor 4 Documentation](http://docs.ckeditor.com/)
- [TinyMCE 4 Documentation](http://www.tinymce.com/wiki.php)
- [Automate entering text into WYSIWYG editors using Watir-WebDriver](http://watirmelon.com/2011/08/12/automate-entering-text-into-wysiwyg-editors-using-watir-webdriver/)

[CKEditor]: http://ckeditor.com/
[TinyMCE]: http://www.tinymce.com/
[CLEditor]: http://premiumsoftware.net/CLEditor
[CuteEditor]: http://cutesoft.net/ASP.NET%2BWYSIWYG%2BEditor/
[PrimeFaces Editor]: http://www.primefaces.org/showcase/ui/editor.jsf
[TinyMCE setContent]: http://www.tinymce.com/wiki.php/api4:method.tinymce.Editor.setContent
