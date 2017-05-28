---
layout: post
title: "Tips for locating elements in Ext JS applications with Selenium WebDriver"
description: "This article provides few tips for locating elements in ExtJS applications with Selenium WebDriver or similar frameworks."
categories: [articles]
tags: [css selectors, ext js, javascript, selenium webdriver, xpath]
redirect_from:
  - /2017/01/15/
---
Locating elements in web applications created by [Ext JS][Ext JS] framework
could be a total nightmare for UI automators,
as Ext JS generates one of the most complex DOM structures
which have dynamic IDs with a large amount of duplicate class names.

Unlike automating applications with simple DOM structures,
Selenium WebDriver's built-in methods like `By.Id`, `By.ClassName`, `By.Name`
would barely identify anything in Ext JS applications.
In most of the cases, `By.CssSelector` or `By.XPath` will be neccessary,
even though using them are not that straightforward either.

Hopefully this article would help developers write the most concise meaningful and human readable locators,
so that maintenance cost can be kept minimum when automating ExtJS applications.

* Kramdown table of contents
{:toc .toc}

## Ext JS Example

Here Sencha Ext JS' [Ticket App][Ticket App]{:target="_blank"}
is used as an example:

{% highlight html %}
<!-- The Password Field -->
<div class="x-field password x-form-item x-form-item-default x-form-type-password x-field-default x-anchor-form-item" role="presentation" id="textfield-1012">
  <label id="textfield-1012-labelEl" data-ref="labelEl" class="x-form-item-label x-form-item-label-default   x-unselectable" for="textfield-1012-inputEl">
    <span class="x-form-item-label-inner x-form-item-label-inner-default">
      <span id="textfield-1012-labelTextEl" data-ref="labelTextEl" class="x-form-item-label-text">Password:</span>
    </span>
  </label>
  <div id="textfield-1012-bodyEl" data-ref="bodyEl" role="presentation"
  class="x-form-item-body x-form-item-body-default x-form-text-field-body x-form-text-field-body-default  ">
    <div id="textfield-1012-triggerWrap" data-ref="triggerWrap" role="presentation" class="x-form-trigger-wrap x-form-trigger-wrap-default">
      <div id="textfield-1012-inputWrap" data-ref="inputWrap" role="presentation" class="x-form-text-wrap x-form-text-wrap-default">
        <input id="textfield-1012-inputEl" data-ref="inputEl" type="password" size="1" name="password"role="textbox"
        aria-required="true" class="x-form-field x-form-required-field x-form-text x-form-text-default  " autocomplete="off" data-componentid="textfield-1012">
      </div>
    </div>
  </div>
</div>
{% endhighlight %}

## DON'Ts
{: #donts}

### Don't match only IDs

{% highlight c# %}
// DON'T USE
driver.FindElement(By.Id("textfield-1012-inputEl"));
{% endhighlight %}

Unless IDs are explicitly defined in application's source code,
ExtJS will produce IDs for each elements dynamically, like `textfield-1012-inputEl`, `button-1016-btnInnerEl`.
Matching elements using those dynamic numbers will make project unmaintainable.
Even matching on IDs partially like `input[id$='inputEl']` wouldn't help either,
as there will be lots of others elements have the same id structures.

### Don't use highly position-dependent XPaths

{% highlight c# %}
// DON'T USE
driver.FindElement(By.XPath("//div[contains(@class, 'x-panel-body')]/div/div/div[2]/div/div/div/input"));
{% endhighlight %}

Highly position-dependent XPaths, or even worse, absolute XPaths should be avoided no matter what,
even for web applications with simple DOM structures.
Because any tiny bit of DOM change will result in XPath becoming invalid.
XPaths like `//div[contains(@class, 'x-panel-body')]/div/div/div[2]/div/div/div/input`
are too fragile in terms of UI automation.

### Don't match single class name only

{% highlight c# %}
// DON'T USE
driver.FindElement(By.ClassName("x-form-text"));
{% endhighlight %}

Just like matching IDs, matching single class name won't help either.
As ExtJS generates class names in a similar naming convention for all elements,
`.x-form-field` will mostly likely result in multiple elements.

### Don't perform exact match on multiple classes

{% highlight c# %}
// DON'T USE
driver.FindElement(By.XPath(".//a[contains(@class, 'x-btn btn-submit')]"));
driver.FindElement(By.CssSelector("a[class*='x-btn btn-submit']"));

// TO MATCH TWO CLASS NAMES TOGETHER
driver.FindElement(By.CssSelector("a.x-btn.btn-submit"));
{% endhighlight %}

This happens mostly to XPath locators instead of CSS selectors.

When matching multiple class names using CSS selectors,
people would normally use something like `a.x-btn.btn-submit`,
which matches an anchor that has class `x-btn` and `btn-submit`.
This is absolutely fine without any problems.

However, for XPaths, a common usage
`.//a[contains(@class, 'x-btn btn-submit')]` doesn't do the same thing,
as it matches exactly class attributes `x-btn btn-submit` with exact one space and class order.
This XPath is actually equivalent to CSS selector `a[class*='x-btn btn-submit']`.
Matching class names by exact string `x-btn btn-submit` should be avoided
unless the order is important in that particular case.

Imagine we have few elements as the followings:

1. `<input class="x-form-field x-form-text">`
2. `<input class="x-form-field x-form-text    "><!-- Note the trailing space -->`
3. `<input class="x-form-required-field x-form-field x-form-text x-form-text-default  ">`
4. `<input class="x-form-text x-form-field">`

How XPath and CSS Selectors match them:

- Match only #1 (exact match)

{% highlight c# %}
driver.FindElement(By.CssSelector("input[class='x-form-field x-form-text']"));
driver.FindElement(By.XPath("//input[@class='x-form-field x-form-text']"));
{% endhighlight %}

- Match #1, #2 and #3 (match class contains `x-form-field x-form-text`, class order matters)

{% highlight c# %}
driver.FindElement(By.CssSelector("input[class*='x-form-field x-form-text']"));
driver.FindElement(By.XPath("//input[contains(@class, 'x-form-field x-form-text')]"));
{% endhighlight %}

- Match #1, #2, #3 and #4 (as long as elements have class `x-form-field` and `x-form-text`)

{% highlight c# %}
driver.FindElement(By.CssSelector("input.x-form-field.x-form-text"));
driver.FindElement(By.XPath("//input[contains(@class, 'x-form-field') and contains(@class, 'x-form-text')]"));
{% endhighlight %}

### Don't use tools to generate locators

There are XPath generating extensions in Chrome or Firefox to create XPaths.
Never ever use them against web applications with complex DOM.
Some tools generate absolute or position-based XPaths,
which are totally rubbish and shouldn't be used in any Selenium WebDriver code at all.
Some extensions are smarter that generates some relative selectors based on class names or IDs.
Due to the nature of Ext JS as explained above,
class names or IDs are unlikely to be sufficient for locating elements in Ext JS applications most of the time.

## DOs

> Q: What makes a locator good locator?<br /><br />
A: In my opinion, good locators are unique and concise, not random or fragile.

### Use meaningful class names

Among all those Ext JS generated class names, sometimes some meaningful ones can be used as good locators.
In the example above, there are two labels for text fields.
To locate the 'Password' label, `.password label` would be a nice and easy one,
as `password` is the meaningful and unique class name among those text fields.

{% highlight c# %}
driver.FindElement(By.CssSelector(".password label"));
{% endhighlight %}

### Use unique attributes

If there are no meaningful class names generated by Ext JS can be found,
the next step is to find some unique attributes.
Sometimes this is even better than meaningful class names depending how unique they are.

Take the Ticket App login screen as an example,
there is only one button and one dropdown combo box.
It is fairly easy locate them using either CSS or XPath locators.

{% highlight c# %}
// In this example, there is only one combobox or button in the dialog.
driver.FindElement(By.CssSelector("input[role='combobox']"));
driver.FindElement(By.CssSelector("a[role='button']"));
{% endhighlight %}

### Find a unique ancestor

Sometimes one locator matches multiple elements, but each element is within a unique ancestor.
In this case, try locate the unique ancestor and then match the element based on this context.

For example, here are few 'Cancel' buttons which are almost identical
except for one is in a container `<div id='header'>`, while the other two are in `<div id='footer'>`.

{% highlight html %}
<div id='header'>
    <div id="ext-gen1179" class="x-grid-cell-inner x-unselectable">Cancel</div>
</div>
<div id='footer'>
  <div id='ext-gen1260' class='x-grid3-body'>
      <div id="ext-gen1359" class="x-grid-cell-inner x-unselectable">Cancel</div>
  </div>
  <div id='ext-gen2555' class='x-toolbar-right-row'>
      <div id="ext-gen2951" class="x-grid-cell-inner x-unselectable">Cancel</div>
  </div>
</div>
{% endhighlight %}

Then instead of matching by ID, class names or anything else,
each button can be uniquely identified by their ancestors.

{% highlight c# %}
driver.FindElement(By.XPath("//div[@id='header']//div[text()='Cancel']"));
driver.FindElement(By.XPath("//div[@id='footer']//div[contains(@class, 'x-grid3-body')]//div[text()='Cancel']"));
driver.FindElement(By.XPath("//div[@id='footer']//div[contains(@class, 'x-toolbar-right-row')]//div[text()='Cancel']"));
{% endhighlight %}

## Gotchas

### Match element text

Matching element by text is commonly used to locate elements.
Personally I rarely use it, but there is nothing wrong with the approach itself.
However, to match elements with text, there are things to be considered first!

- Whitespace

    If you are doing something like `//div[contains(@class, 'password')]/label//span[text()='Password:']`
    to find the `Password:` label,
    it won't match if there are extra whitespaces around it!

    In this case, normalize whitespace in XPath would be a good idea.

{% highlight c# %}
driver.FindElement(By.XPath("//div[contains(@class, 'password')]/label[normalize-space(.)='Password:']"));
{% endhighlight %}

- Internationalization

  Many web applications nowadays support internationalization.
  Matching text will make the tests dependent on the displaying language of the application.
  This is one major reason that I personally always avoid writing text matching locators.
  Even if there is only one language supported in the application at the moment,
  it's still good to keep Selenium code extensible in the future.

- Encoding

  Say for example, the only display language of the application is Simplified Chinese.
  If the test code uses text matching, it might run into encoding problems,
  especially for those Selenium WebDriver Python binding users.

### Use index

Sometimes it is not easy to find one perfect locator that matches exact one element.
Therefore many developers like to find few elements by one locator and index the elements,
or use `nth-child()`, `first-child`, `[1]` in CSS Selectors or XPaths.

There is nothing wrong with these index-type locators, but they can cause problems potentially.
Using them to locate the first or number X item of a list is totally acceptable,
where the items are actually structured inside a list (options, lists, etc.) logically.
But using them against some elements that are not logically related,
like three buttons called 'Cancel' in different containers from the example above, might make tests really fragile
that any text change or position change would fail the tests.

## Ultimate Solution

> Q: None of the tips above seem to be sufficient. Is there any better way to write locators for Ext JS apps?<br /><br />
A: Yes, there is! Personally, I believe this is ultimate solution.

Web designers can add class names to HTML in order to make styling easier.
Developers should add class names to HTML for UI testing purposes too!

[Ext JS API][Ext JS API] allows users to set class names in most of their components with great flexibility,
which can make locating elements so much easier.

For example, to add classes to a button, the following JavaScript code

{% highlight javascript %}
var button = Ext.create('Ext.Button', {
    cls: 'ui-test-button',
    labelCls: 'ui-test-button-label',
    text: 'Button'
});
{% endhighlight %}

will generate the following HTML with user defined class names for UI testing purposes.

{% highlight html %}
<div class="x-unsized x-component x-button x-button-no-icon ui-test-button x-haslabel x-layout-auto-item"
  id="ext-button-1" data-componentid="ext-button-1">
  <span class="x-hidden-display x-badge" id="ext-element-17"></span>
  <span class="x-button-icon x-font-icon x-hidden" id="ext-element-19"></span>
  <span class="ui-test-button-label" id="ext-element-18">Button</span>
</div>
{% endhighlight %}

[Ext JS]: https://www.sencha.com/products/extjs/#overview
[Ticket App]: http://examples.sencha.com/extjs/6.2.0/examples/classic/ticket-app/index.html
[Ext JS API]: http://docs.sencha.com/extjs/6.2.0/index.html
