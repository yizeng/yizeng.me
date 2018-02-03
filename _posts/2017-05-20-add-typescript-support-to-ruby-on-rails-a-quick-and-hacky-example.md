---
layout: post
title: "Add TypeScript support to Ruby on Rails - A quick and hacky example"
description: "How to add TypeScript support to Ruby on Rails in a quick and hacky way."
categories: [tutorials]
tags: [javascript, typescript, ruby on rails, yarn]
redirect_from:
  - /2017/05/20/
---

> For a proper and comprehensive integration of TypeScript in Rails, please see [Webpacker][Webpacker] gem.

As I'm currently learning [TypeScript][TypeScript],
I wondered if I could apply it to my little [Ruby on Rails][Ruby on Rails] project [Strafforts][Strafforts]
(A Visualizer for Strava Estimated Best Efforts and Races),
so that I could use this real world project to help me learning TypeScript quickly.

Even though there is a gem called [typescript-rails][typescript-rails]
which is a Rails asset pipeline wrapper for the TypeScript,
or a proper and comprehensive integration of TypeScript in Rails like [Webpacker][Webpacker] gem.
I have decided to create my own quick and hacky way of introducing TypeScipt to my Ruby on Rails project,
mostly due to the following reasons:

- The purpose is to learn TypeScript with all its setup process, so why not start from scratch by myself
as I'm not trying to create a nice and complete solution for everyone.
- `typescript-rails` project hasn't been updated for almost a year.
Is it well maintained and fully compatible with the latest Rails 5.1.x?
- `webpacker` is a whole solution which is too heavy for TypeScript learning purpose.
- [Rails 5.1.x supports Yarn now][Rails 5-1 Release].
Why not try the traditional Node.js way instead of the Rails way?

Therefore I have added TypeScript support to my Ruby on Rails project in a quick and hacky way.

* Kramdown table of contents
{:toc .toc}

## Install Yarn

[Yarn][Yarn] is a JavaScript package manager, a quick, secure and reliable npm alternative.
which is officially supported by Rails from version 5.1.

To install Yarn, please follow the official installation guide [here][Yarn Installation].
For macOS users, simply use homebrew `brew install yarn`.

## Install TypeScript through Yarn

### Initialize

For projects with Rails 5.1 or above,
`package.json` should have been created automatically when app was created.
Otherwise for older versions of Rails, use `yarn init` to create a `package.json` first.

### Add TypeScipt package

Use the following command to add TypeScript package to the project.

> yarn add typescript

It will create `node_modules` folder under project root
and a `yarn.lock` file containing information about the package versions.
If installation is successful, TypeScript binary should be accessible in `node_modules/.bin/tsc`.

### Add to assets paths

For users with Rails 5.1 or above, this step should have been done automatically.
But for users with older Rails versions, `node_modules` folder needs to be added to Rails assets paths manually.

To do so, add the following line to `config/initializers/assets.rb`:

{% highlight ruby %}
Rails.application.config.assets.paths << Rails.root.join('node_modules')
{% endhighlight %}

### Update .gitignore

For users with Rails 5.0 or under, once `node_modules` folder is created,
remember to add it together with Yarn's error log file to `.gitignore`,
so that they will not be commited to the repository.

> /node_modules<br />
> /yarn-error.log

## Write TypeScript

Now write some TypeScript to replace the existing CoffeeScript or plain JavaScript.
For example, create a TypeScript file `welcome.ts` under `app/assets/javascripts`.

{% highlight typescript %}
class HelloWorld {

    private name: string;

    constructor(name: string) {
        this.name = name;
    }

    print() {
        alert(`Hello World, ${this.name}!`);
    }
}

new HelloWorld('John Doe').print();
{% endhighlight %}

## Add tsconfig.json

Typically, to guide TypeScript compiler on how to generate JavaScript files,
add a TypeScript configuration file called `tsconfig.json` to the project.

The presence of a `tsconfig.json` file in a directory indicates that the directory is the root of a TypeScript project.
It specifies the root files and the compiler options required to compile the project.

Here for example, create a `tsconfig.json` file with some common options,
and tell compiler to convert `welcome.ts` to `generated/welcome.js`,
where everything in `generated` folder can be added to `.gitignore`.

{% highlight json %}
{
  "compilerOptions": {
      "outFile": "app/assets/javascripts/generated/welcome.js",
      "noImplicitAny": true,
      "noEmitOnError": true,
      "sourceMap": true,
      "target": "es5"
  },
  "files": [
      "app/assets/javascripts/welcome.ts"
  ]
}
{% endhighlight %}

## Add Rake build task

Finally create a new Rake task to compile to TypeScript files to JavaScript.
Note that this new task can be added to Rails' `rake assets:precompile` task,
so that every time `rake assets:precompile` is executed, `assets:tsc` will be run first.

{% highlight ruby %}
namespace :assets do
  desc 'Compile TypeScript Files'
  task :tsc do
    system('node_modules/.bin/tsc')
  end
end

Rake::Task['assets:precompile'].enhance ['assets:tsc']
{% endhighlight %}

For example, add a `assets.rake` file to `lib/tasks` folder with the content above,
then call the following command to compile TypeScript.

> rake assets:tsc

## Demos

A simple demo for this tutorial is hosted on [GitHub][Demo on GitHub].

The more complicated example that was actually applied to [Strafforts][Strafforts]
can also be viewed on [GitHub][Strafforts Source Code],
which contains separate `tsconfig.json` files for compiling different pages/projects.

[Webpacker]: https://github.com/rails/webpacker
[TypeScript]: https://www.typescriptlang.org/
[Ruby on Rails]: http://rubyonrails.org/
[Strafforts]: http://www.strafforts.com/
[typescript-rails]: https://github.com/typescript-ruby/typescript-rails
[Rails 5-1 Release]: http://weblog.rubyonrails.org/2017/4/27/Rails-5-1-final/
[Yarn]: https://yarnpkg.com/lang/en/
[Yarn Installation]: https://yarnpkg.com/en/docs/install
[Demo on GitHub]: https://github.com/yizeng/Demo-TypeScript-Support-to-Ruby-on-Rails
[Strafforts Source Code]: https://github.com/yizeng/strafforts
