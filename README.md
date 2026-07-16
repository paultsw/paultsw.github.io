Personal homepage at `https://ptsw.ca`

This readme is more for my own reference than for your reading pleasure. That being said, if reading the minutiae of blog deployment on Github-Pages is what gets you going, I obviously won't stand in the way of your pleasure.

### Branches

* The `master` branch contains the code for the site and blog. It follows an emacs-forward way of exporting org-mode documents to tufte-css formatted HTML files using ox-tufte.
* The `viz` branch contains the code I use to generate the visualizations on the homepage.

### Running a local copy

``` shell
make clean && make && make serve
```
and then navigate to `localhost:8000/`.

### Parsing mathematical content

* This blog incorporates the [MathJax](https://www.mathjax.org/) plugin (delimiters `\\[` and `\\]`); that being said, almost everything here can be parsed with [kramdown's LaTeX parser](https://kramdown.gettalong.org/converter/latex.html) (delimiters `$$`).

* Caveat: nested super-/sub-scripts (e.g. [iterated exponentiation](https://en.wikipedia.org/wiki/Tetration)) may break the rendering engine and fail to render. Avoid excessive super-/sub-scripts whenever possible using judicious choice of variables.
