<link rel="stylesheet" href="{{ "/assets/css/style.css" | relative_url }}">

## Math 8xyz - Mathematical epidemiology

This GitHub repo contains material (slides and code) for a graduate course on Mathematical epidemiology.

I am adding slides progressively; those that are present are, for the most part, "ready for consumption".
I will be recording videos to match the slides but have not started yet.

### This GitHub repo

On the [GitHub version](https://github.com/julien-arino/math-8xyz-math-epi/) of the page, you have access to all the files. You can also download the entire repository by clicking the buttons on the left. (You can also of course clone this repo, but you will need to do that from the GitHub version of the site.)

### Using/copying this material
Feel free to use the material in these slides or in the folders. If you find this useful, I will be happy to know.

### Slides

{% if site.data.slides %}
  {% for slide in site.data.slides %}
- [{{ slide.lecture_number }} - {{ slide.title }}](SLIDES/{{ slide.pdf_filename }})
  {% endfor %}
{% else %}
  {% comment %} Fallback: auto-detect PDF files if CSV data is not available {% endcomment %}
  {% assign slide_pdfs = site.static_files 
    | where_exp: "file", "file.path contains '/SLIDES/'" 
    | where_exp: "file", "file.extname == '.pdf'" 
  %}
  {% for slide_pdf in slide_pdfs %}
    {% unless slide_pdf.path contains '/SLIDES/FIGS/' %}
- [{{ slide_pdf.name | remove: '.pdf' }}]({{ slide_pdf.path | relative_url }})
    {% endunless %}
  {% endfor %}
{% endif %}

### Additional slides and videos

On [my website](https://julien-arino.github.io/teaching/), I have a variety of slides sets/courses and sometimes videos that may help you go further. In particular, if you want to learn more about R, you may find [these "vignettes"](https://julien-arino.github.io/R-for-modellers/) useful.
