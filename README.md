# PresideCMS Extension: Blog

This is an extension for [PresideCMS](https://www.presidecms.com) that provides a simple blogging functionality.
In detail the following is added:

* extends the site object to integrate https://www.addthis.com and https://disqus.com
* objects for blog authors and tags
* blog listing + blog post page types
* widgets for some blog related aspects

The 'most-viewed' functionality only works if using google analytics tracking and import - that can be done by making use of [preside-ext-analytics-import](https://bitbucket.org/jjannek/preside-ext-analytics-import)

## Installation

Install the extension to your application via either of the methods detailed below (Git submodule / CommandBox) and then enable the extension by opening up the Preside developer console and entering:

    extension enable preside-ext-blog
    reload all

### Git Submodule method

From the root of your application, type the following command:

    git submodule add https://github.com/pixl8/preside-ext-blog.git application/extensions/preside-ext-blog

### CommandBox (box.json) method

From the root of your application, type the following command:

    box install preside-ext-blog

## Contribution

Feel free to fork and pull request. Any other feedback is also welcome - preferable on the PresideCMS slack channel.