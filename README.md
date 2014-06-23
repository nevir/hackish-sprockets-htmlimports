sprockets-htmlimports
=====================

Sprockets support for HTML Imports, for your [Rails](http://rubyonrails.org/)
and [Middleman](middlemanapp.com) projects.

Please note that `sprockets-htmlimports` is very much an **alpha** project at
this point. You'll be living on the bleeding edge; pulling gems directly from
GitHub, fending off bugs, and dealing with half-implemented behaviors. That's
the joy of open source!


Getting Started
---------------

Add `sprockets-htmlimports` (and _bleeding edge dependencies_) to your
`Gemfile`:

    gem 'sprockets-htmlimports', git: 'https://github.com/nevir/sprockets-htmlimports'

That's all you need for basic support. You may also want to enable HTML
compression by setting `html_compressor = :simple` in the usual spot.

For a rails project, add this to your `production.rb`:

    config.assets.html_compressor = :simple


Ok, What's It Do?
-----------------

`sprockets-htmlimports` parses `.html` files for their dependencies,
expressed via:

* `<link href="..." rel="import">`
* `<script src="...">`
* `<link href="..." rel="stylesheet">`

This enables Sprockets to do all the magic you've come to expect:

* Concatenate all of your HTML imports into a single file.
* Compress your assets (there is also support for basic HTML compression).


What Doesn't It Do (Yet)?
-------------------------

* It isn't smart about stylesheet references. They are currently all inlined so
  that templated stylesheets aren't broken.
* Source maps are not supported.
* HTML compression is pretty simple; there's a lot more that it could do.
