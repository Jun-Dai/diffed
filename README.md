# Diffed [![Build Status](https://secure.travis-ci.org/Jun-Dai/diffed.png)](http://travis-ci.org/Jun-Dai/diffed)

This is a library for creating HTML from a unified diff string.  Currently the only use-case I am building is for retrieving diffs from `p4 describe -du 123456` and sending the HTML in an e-mail.  Hopefully I can generalise the problem to add other use-cases.

## Installation

Add this line to your application's Gemfile:

    gem 'diffed'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install diffed

## Usage

Assuming you have a unified diff output in a string called `diff_output`, you can format it like this:

```Ruby
require 'diffed'

html = Diffed::Diff.new(diff_output).as_html_table
```

By default, this will print the HTML table with inline CSS styles (e.g., `style="color: #FDD"`), for maximum compatibility when sending HTML e-mails and for inclusion in other HTML documents without having to load separate stylesheets.

If you'd like to style the HTML yourself, you can have the table render with CSS classes instead of inline styles, like so:

```Ruby
html = Diffed::Diff.new(diff_output).as_html_table(false)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
