---
layout: post
title: "Hello World!"
description: "The first 'Hello world' post for Yi Zeng's personal website
'yizeng.me' in order to test Jekyll code highlightings."
categories: [uncategorized]
tags: [jekyll]
redirect_from:
  - /2013/04/22/
---
> Recently Updated - May 24, 2017

This is test page for [kramdown][kramdown] formatting of [Simple Texture][Simple Texture] theme.

* Kramdown table of contents
{:toc .toc}

# General Usage

This is a normal paragraph.

This is [a link](http://yizeng.me) to my homepage.
A [link](http://yizeng.me/blog "Yi Zeng's Blog") can also have a title.

This is a ***text with light and strong emphasis***.

This **is _emphasized_ as well**.

This *does _not_ work*.

This **does __not__ work either**.

This is a footnote[^1].

## Blockquotes

> ruby -v
>
> tsc -v

### Nested

> This is a paragraph in blockquote.
>
> > A nested blockquote.
>

### Lists inside

> Unordered List
> * lists one
> * lists two
> * lists three
>
> Ordered List
> 1. lists one
> 2. lists two
> 3. lists three

### Long lines

> Jekyll is a simple, blog-aware, static site generator perfect for personal, project, or organization sites. Think of it like a file-based CMS, without all the complexity. Jekyll takes your content, renders Markdown and Liquid templates, and spits out a complete, static website ready to be served by Apache, Nginx or another web server. Jekyll is the engine behind GitHub Pages, which you can use to host sites right from your GitHub repositories.

## Lists

* list 1 item 1
  * nested list item 1
  * nested list item 2
  * nested list item 3 with blockquote
> ruby -v
>
> tsc -v
* list 1 item 2
* list 1 item 3

## Tables


* Table 1

    |-----------------+------------+-----------------+----------------|
    | Default aligned |Left aligned| Center aligned  | Right aligned  |
    |-----------------|:-----------|:---------------:|---------------:|
    | First body part |Second cell | Third cell      | fourth cell    |
    | Second line     |foo         | **strong**      | baz            |
    | Third line      |quux        | baz             | bar            |
    | Footer row      |            |                 |                |
    |-----------------+------------+-----------------+----------------|

* Table 2

    |---
    | Default aligned | Left aligned | Center aligned | Right aligned
    |-|:-|:-:|-:
    | First body part | Second cell | Third cell | fourth cell
    | Second line |foo | **strong** | baz
    | Third line |quux | baz | bar
    | Footer row

## Horizontal Rules

* * *

---

  _  _  _  _

---------------

## Images

Here comes an image!

![smiley](https://kramdown.gettalong.org/overview.png)

# Code

## Code Spans

This is a test for inline codeblocks like `C:/Ruby23-x64` or `SELECT  "offices".* FROM "offices" `

Here is a literal `` ` `` backtick.
And here is ``  `some`  `` text (note the two spaces so that one is left
in the output!).

This is a Ruby code fragment `x = Class.new`{:.language-ruby}

## Fenced Code Blocks

~~~~~~~~~~~~
~~~~~~~
code with tildes
~~~~~~~~
~~~~~~~~~~~~~~~~~~

## Simple codeblock with long lines

    function myFunction() {
        alert("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.");
    }

## Language of Code Blocks

~~~ ruby
def what?
  42
end
~~~

## Highlighted

### External Gist

<script src="https://gist.github.com/yizeng/9b871ad619e6dcdcc0545cac3101f361.js"></script>

### Simple Highlight

{% highlight ruby %}
def foo
  puts 'foo'
end
{% endhighlight %}

### Highlight with long lines

{% highlight c# %}
public class Hello {
    public static void Main() {
        Console.WriteLine("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.");
    }
}
{% endhighlight %}

### Highlight with line numbers and long lines

{% highlight javascript linenos=table %}
function myFunction() {
    alert("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.");
}
{% endhighlight %}

[^1]: This is a footnote.

[kramdown]: https://kramdown.gettalong.org/
[Simple Texture]: https://github.com/yizeng/simple-texture-jekyll-theme