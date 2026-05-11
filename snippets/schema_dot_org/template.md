---
type: snippet
author: ianyamey
title: Schema.org structured data
description: Add JSON-LD structured data to your Perron site using the schema_dot_org gem.
---

This snippet adds the foundation for adding Schema.org structured data to your static site.


## Usage

In any controller, include the concern and call structured_data:
```ruby
class Content::PostsController < ApplicationController
  include StructuredData

  def show
    @resource = Content::Post.find!(params[:id])

    structured_data do |schemas|
      schemas.add SchemaDotOrg.make_breadcrumbs([
        {name: "Home", url: root_url},
        {name: "Posts", url: posts_url},
        {name: @resource.title, url: post_url(@resource)}
      ])

      schemas.add @resource.to_schema_dot_org(url: polymorphic_url(@resource))
    end
  end
end
```

In your resource model, define the method:
```ruby
class Content::Post < Perron::Resource
  def to_schema_dot_org(url:)
    SchemaDotOrg::Article.new(
      headline: title,
      description: description,
      url: url,
      date_published: published_at.iso8601
    )
  end
end
```

In your layout head, render the tags:
```erb
<%= structured_data_tags %>
```


## Available schema types

The gem provides: Article, Organization, Person, BlogPosting, BreadcrumbList, FAQPage, Product, Review and more. Override `to_schema_dot_org(url:)` in your resource to return any type.


## Extend

Add additional schema types in `app/models/schema_dot_org/` following the Article pattern.
