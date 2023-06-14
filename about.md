---
layout: about
---
<ul>

  {% for about in site.about %}
      <h1>{{ about.title }}</h1>
      <p>{{ about.content | markdownify }}</p>
  {% endfor %}
</ul>
