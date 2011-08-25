# CouchVisible

CouchVisible is a mixin for your CouchRest::Model documents that provides a simple API for specifying the visibility of a document. This comes in handy in content publishing systems where you want to be able to hide and show documents on your website.  

## Installation

It's a gem. Either run `gem install couch_visible` at the command line, or add `gem 'couch_visible'` to your Gemfile.

## Usage

The gem provides a mixin `CouchVisible` for your `CouchRest::Model::Base` derived documents:

```ruby
class Article < CouchRest::Model::Base
  include CouchVisible
end
```

### Hidden by default

Mixing it into your document will create a boolean "couch_visible" property on your document. By default, documents will be hidden; if you'd prefer your documents to be visible by default, simply use the `show_by_default!` macro: 

```ruby
class Article < CouchRest::Model::Base
  include CouchVisible
  show_by_default!
end
```

You can also configure this globally:
  
```ruby
CouchVisible.show_by_default!
```

Now, all document models that include CouchVisible will be shown by default. They could override the global default by calling "hide_by_default!":

```ruby
class Post < CouchRest::Model::Base
  include CouchVisible
  hide_by_default!
end
```

### Showing and Hiding Documents

`CouchVisible` lets you toggle the visibility of documents via `show!` and `hide!` methods:
    
```ruby
a = Article.first

a.hide! 
  #==> sets the couch_visible property to false and saves the document 

a.show!
  #==> sets the couch_visible property to true and saves the document
```

You can also ask whether the document is currently `hidden?` or `shown?`:
    
```ruby
a = Article.first
a.hide!   
a.shown?  #==> false
a.hidden? #==> true
```

### Fetching Hidden/Shown documents

Lastly, when you mixed `CouchVisible` into your document, a new map/reduce was created for your document that allows you to easily find shown and hidden documents:

```ruby
hidden_article = Article.create
hidden_article.hide!

Article.map_by_hidden.get!
Article.count_by_hidden.get!
Article.map_by_shown.get!
Article.count_by_shown.get!
```

You can use all of the typical CouchDB options you would normally use in your queries. If you're unfamiliar with this format, checkout the `couch_view` gem, which `couch_visible` depends on: http://github.com/moonmaster9000/couch_view

## CouchPublish / Memories Integration

The `couch_visible` integrates nicely with the `couch_publish` and `memories` gems for versioning / publishing. If you mix `Memories` or `CouchPublish` into your document, then mix `CouchVisible` into it, then `CouchVisible` will create an unversioned `couch_visible` property, so that reverting versions won't unintentionally toggle the visibility of the document.   

For example, let's create a document with several versions, then inspect that state of `couch_visible` after reverting:

```ruby
class Article < CouchRest::Model::Base
  include Publish
  include CouchVisible
  
  property :title
end

a = Article.create :title => "The Mavs spank the Heat"

a.hidden? 
  #==> true

a.publish!

a.version
  #==> 2
```

Our document is published, but hidden. Now let's unhide the document:

```ruby
a.show!

a.version 
  #==> 3
```

Now the document is shown. Presumably, it would start showing up on the website.

Next, let's imagine our editor wanted to make the title more specific. You update the title and republish: 

```ruby
a.title
  #==> "The spank the Heat in game 6"

a.publish!
```

The editor's boss wasn't happy with the change; they ask you to revert back to the old title. Here's where it gets interesting. If `memories` had versioned the `couch_visible` boolean property, then reverting back to version `2` would hide the document again. But since `CouchVisible` detected that you were using `Memories` or `CouchPublish`, it created the `couch_visible` property as a non-versioned property.  

```ruby
a.published_versions.first.publish! 

a.hidden?
  #==> false
```

So even though you've reverted back to version 2, your document is still visible. 

### Filtering your views by published and unpublished

Another nice integration: when you include `CouchVisible` into a model that already includes `CouchPublish`, you'll be able to filter your `map_by_hidden`/`count_by_hidden`/`map_by_shown`/`count_by_shown` queries for `published` and `unpublished` documents: 

```ruby
class Article < CouchRest::Model::Base
  include CouchPublish
  include CouchVisible
end

Article.map_by_shown.published.get!
  #==> all of the shown and published Article documents

Article.count_by_hidden.unpublished.get!
  #==> all of the hidden documents that have never been published
```
