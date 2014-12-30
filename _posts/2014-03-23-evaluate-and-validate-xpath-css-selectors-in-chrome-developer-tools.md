---
layout: post
title: "Evaluate and validate XPath/CSS selectors in Chrome Developer Tools"
description: "Demonstrate two approaches to evaluate and validate XPath/CSS selectors in Chrome Developer Tools without extensions, one by searching in 'Elements' panel, one by executing $x/$$ tokens in 'Console' panel."
categories: [articles, popular]
tags: [css-selectors, selenium-webdriver, xpath]
alias: [/2014/03/23/]
utilities: fancybox, unveil
---
Google Chrome provides a built-in debugging tool called "[Chrome DevTools][Chrome DevTools]" out of the box,
which includes a handy feature that can evaluate or validate XPath/CSS selectors without any third party extensions.

This can be done by two approaches:

- Use the search function inside `Elements` panel to evaluate XPath/CSS selectors and highlight matching nodes in the DOM.
- Execute tokens `$x("some_xpath")` or `$$("css-selectors")` in `Console` panel, which will both evaluate and validate.

## From Elements panel
{: #from-elements-panel}

1. Press `F12` to open up Chrome DevTools.
2. `Elements` panel should be opened by default.
3. Press `Ctrl` + `F` to enable DOM searching in the panel.
4. Type in XPath or CSS selectors to evaluate.
5. If there are matched elements, they will be highlighted in DOM.<br />
   However, if there are matching strings inside DOM, they will be considered as valid results as well.
   For example, CSS selector `header` should match everything (inline CSS, scripts etc.) that contains the word `header`, instead of match only elements.

<a class="post-image" href="/assets/images/posts/2014-03-23-evaluate-using-elements-panel.gif">
<img itemprop="image" data-src="/assets/images/posts/2014-03-23-evaluate-using-elements-panel.gif" src="/assets/js/unveil/loader.gif" alt="Evaluate XPath/CSS selectors using 'Elements' panel's seach function" />
</a>

## From Console panel
{: #from-console-panel}

1. Press `F12` to open up Chrome DevTools.
2. Switch to `Console` panel.
3. Type in XPath like `$x(".//header")` to evaluate and validate.
4. Type in CSS selectors like `$$("header")` to evaluate and validate.
5. Check results returned from console execution.
	- If elements are matched, they will be returned in a list. Otherwise an empty list `[ ]` is shown.

	> $x(".//article")<br />
	> [&lt;article class="unit-article layout-post"&gt;...&lt;/article&gt;]
	>
	> $x(".//not-a-tag")<br />
	> [ ]

	- If the XPath or CSS selector is invalid, an exception will be shown in red text. For example:

	> $x(".//header/")<br />
	> SyntaxError: Failed to execute 'evaluate' on 'Document': The string './/header/' is not a valid XPath expression.
	>
	> $$("header[id=]")<br />
	> SyntaxError: Failed to execute 'querySelectorAll' on 'Document': 'header[id=]' is not a valid selector.

<a class="post-image" href="/assets/images/posts/2014-03-23-evaluate-using-console-panel.gif">
<img itemprop="image" data-src="/assets/images/posts/2014-03-23-evaluate-using-console-panel.gif" src="/assets/js/unveil/loader.gif" alt="Evaluate XPath/CSS selectors using 'Console' panel" />
</a>

## Pros and cons
{: #pros-and-cons}

Advantages of one approach are pretty much considered as the cons of another method, and vice versa.

{% datatable %}
<tr>
	<th>From 'Elements' panel</th>
	<th>From 'Console' panel</th>
</tr>
<tr class="center bold">
	<td>Pros</td>
	<td>Cons</td>
</tr>
<tr>
	<td>Quick and easy accessibility</td>
	<td>Need to switch panel and extra typing</td>
</tr>
<tr>
	<td>Results are directly highlighted in DOM</td>
	<td>Results are shown in a list<br />Need to right click and go back to 'Element' panel</td>
</tr>
<tr>
	<td>Result count is displayed</td>
	<td>Only a list of matching nodes are displayed</td>
</tr>
<tr class="center bold">
	<td>Cons</td>
	<td>Pros</td>
</tr>
<tr>
	<td>All matched strings are also counted in</td>
	<td>Will only match elements</td>
</tr>
<tr>
	<td>Only evaluates, doesn't validate<br />Invalid locators will just return nothing</td>
	<td>Throw exceptions if locator is invalid</td>
</tr>
<tr>
	<td class="center">-</td>
	<td>Can be used in console immediately for other purposes</td>
</tr>
{% enddatatable %}

[Chrome DevTools]: https://developers.google.com/chrome-developer-tools/