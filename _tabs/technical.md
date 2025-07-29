---
title: Compile
icon: fas fa-laptop-code
order: 1
---

{% assign compile_posts = site.posts | where_exp: "post", "post.categories contains 'compile'" %}

<ul>
  {% for post in compile_posts %}
    <li><a href="{{ post.url | relative_url }}">{{ post.title }}</a> ({{ post.date | date: "%Y-%m-%d" }})</li>
  {% endfor %}
</ul>
