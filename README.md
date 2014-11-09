# Html::Pipeline::NicoLink

An HTML::Pipeline filter for niconico(http://www.nicovideo.jp) description links.

niconicoの動画説明文中のオートリンクです。mylist2.jsの定義を参考にしています。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'html-pipeline-nico_link'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install html-pipeline-nico_link

## Usage

To use this filter on its own

```ruby
require 'html/pipeline/nico_link'

filter = HTML::Pipeline::NicoLinkFilter.new('伝説の動画: sm9')
filter.call.to_s # => '伝説の動画: <a href="http://www.nicovideo.jp/watch/sm9">sm9</a>'
```

To use this filter with HTML::Pipeline

```ruby
pipeline = HTML::Pipeline.new [
  HTML::Pipeline::MarkdownFilter,
  HTML::Pipeline::NicoLinkFilter,
]
pipeline.call('**伝説の動画はこちら→** sm9') # => '<b>伝説の動画はこちら→</b> <a href="http://www.nicovideo.jp/watch/sm9">sm9</a>'
```

## Contributing

1. Fork it ( https://github.com/rutan/html-pipeline-nico_link/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
