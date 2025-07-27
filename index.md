## Math 8xyz - Mathematical Epidemiology

This GitHub repo contains slides for a graduate course on Mathematical epidemiology.

Here, you will find code and slides.

### This GitHub repo

On the [GitHub version](https://github.com/julien-arino/math-8xyz-math-epi/) of the page, you have access to all the files. You can also download the entire repository by clicking the buttons on the left. (You can also of course clone this repo, but you will need to do that from the GitHub version of the site.)

Feel free to use the material in these slides or in the folders. If you find this useful, I will be happy to know.

### Slides


{% assign slide_pdfs = site.static_files | where_exp: "file", "file.path contains '/SLIDES/'" | where_exp: "file", "file.extname == '.pdf'" %}
{% assign slide_pdfs = slide_pdfs | reject: "path", "/SLIDES/FIGS/" %}

{% for slide_pdf in slide_pdfs %}
- [{{ slide_pdf.name }}]({{ slide_pdf.path | relative_url }})
{% endfor %}

### Additional slides and videos

On [my website](https://julien-arino.github.io/teaching/), I have a variety of slides sets/courses and sometimes videos that may help you go further. In particular, if you want to learn more about R, you may find [these "vignettes"](https://julien-arino.github.io/R-for-modellers/) useful.
