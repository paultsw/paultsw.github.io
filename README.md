Personal homepage at `https://ptsw.ca`

This readme is more for my own reference than for your reading pleasure. That being said, if reading the minutiae of blog deployment on Github-Pages is what gets you going, I obviously won't stand in the way of your pleasure.

### Branches

* The `master` branch contains the Jekyll code for the site and blog.
* The `viz` branch contains the code I use to generate the visualizations on the homepage.

### Running a local copy

1. Install a local copy of Ruby & Jekyll by following the official instructions](https://jekyllrb.com/docs/installation/).
2. Install extra gems:
```
$ gem install jekyll-paginate jekyll-gist jekyll-feed rouge
$ gem install kramdown -v '~> 1.17'
```
3. Serve a local copy of the blog:
```
$ bundle exec jekyll serve --host=localhost
```
4. Navigate to `localhost:4000` to see the blog in action.

* N.B.: [due to a bug](https://bundler.io/blog/2019/05/14/solutions-for-cant-find-gem-bundler-with-executable-bundle.html) in the `bundler` gem you may have to run `gem update --system` if step 3 fails due to an error with bundler.
* N.B.: you may have to fiddle with `bundler` in regards to versioning and dependencies. If I'm writing to my future self, I suggest setting aside a maximum of an hour to deal with this, and no more than that.

### Jupyter notebook integration

This assumes you have an existing, completed `.ipynb` file in a standalone github repository.

In the notebook repository, export the notebook to markdown, which will generate a `.markdown` file and images in `.png` format:
```
$ jupyter nbconvert --to markdown notebook.ipynb
```
Then, cut out segments of the markdown file and paste into the `YYYY-MM-DD-blog-post-title.kramdown` file where appropriate.

### Parsing mathematical content

* This blog incorporates the [MathJax](https://www.mathjax.org/) plugin (delimiters `\\[` and `\\]`); that being said, almost everything here can be parsed with [kramdown's LaTeX parser](https://kramdown.gettalong.org/converter/latex.html) (delimiters `$$`).

* Caveat: nested super-/sub-scripts (e.g. [iterated exponentiation](https://en.wikipedia.org/wiki/Tetration)) may break the rendering engine and fail to render. Avoid excessive super-/sub-scripts whenever possible using judicious choice of variables.
