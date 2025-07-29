---
title: Memoir
icon: fas fa-heart
order: 2
---

{% assign memoir_posts = site.posts | where_exp: "post", "post.categories contains 'memoir'" %}

<ul>
  {% for post in memoir_posts %}
    <li><a href="{{ post.url | relative_url }}">{{ post.title }}</a> ({{ post.date | date: "%Y-%m-%d" }})</li>
  {% endfor %}
</ul>
