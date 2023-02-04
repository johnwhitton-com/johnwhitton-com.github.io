---
layout: work
---
<ul>

  {% for work in site.work %}
      <p>{{ work.content | markdownify }}</p>
  {% endfor %}
</ul>