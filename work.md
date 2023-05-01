---
layout: work
---
<ul>

  {% for work in site.work %}
      <h1>{{ work.title }}</h1>
      <p>{{ work.content | markdownify }}</p>
  {% endfor %}
</ul>
