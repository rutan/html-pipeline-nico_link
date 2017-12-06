require 'html/pipeline'
require 'erb'

module HTML
  class Pipeline
    class NicoLinkFilter < Filter
      def initialize(doc, context = nil, result = nil)
        super
        @context = context || {}
      end

      def call
        doc.xpath('.//text()').each do |node|
          next if has_ancestor?(node, IGNORE_PARENTS)
          content = node.to_html
          html = apply_filter(content)
          next if html == content
          node.replace(html)
        end
        doc
      end

      def apply_filter(content)
        content = content.dup
        content.gsub!(merged_pattern) do |text|
          index = $~.captures.index { |n| n }
          pattern_set = patterns[index]
          value = pattern_set[:convert] ? pattern_set[:convert].call(text) : text
          url = pattern_set[:link].gsub('%s', value)
          "<a href=\"#{ERB::Util.html_escape(url)}\">#{ERB::Util.html_escape(text)}</a>"
        end
        content
      end

      def patterns
        @patterns ||= (@context[:nico_link] || DEFAULT_PATTERNS).map do |pattern_set|
          {
            pattern: pattern_set[:pattern],
            link: pattern_set[:link],
            convert: pattern_set[:convert],
          }
        end
      end

      def merged_pattern
        @merged_pattern ||= /\b(?:(#{patterns.map { |n| n[:pattern] }.join(')|(')}))\b/
      end

      IGNORE_PARENTS = %w(pre code a style script).to_set

      DEFAULT_PATTERNS = [
        {
          pattern: /(?:sm|nm|so|ca|ax|yo|nl|ig|na|cw|z[a-e]|om|sk|yk)\d{1,14}/,
          link: 'http://www.nicovideo.jp/watch/%s',
        },
        {
          pattern: %r{(?:watch|user|myvideo|mylist)/\d{1,10}},
          link: 'http://www.nicovideo.jp/%s',
        },
        {
          pattern: /co\d{1,14}/,
          link: 'http://com.nicovideo.jp/%s',
        },
        {
          pattern: /ch\d{1,14}/,
          link: 'http://ch.nicovideo.jp/%s',
        },
        {
          pattern: /ar\d{1,14}/,
          link: 'http://ch.nicovideo.jp/article/%s',
        },
        {
          pattern: /td\d+/,
          link: 'http://3d.nicovideo.jp/works/%s',
        },
        {
          pattern: /nc\d{1,14}/,
          link: 'http://commons.nicovideo.jp/material/%s',
        },
        {
          pattern: /(?:dw\d+|az[A-Z0-9]{10}|ys[a-zA-Z0-9-]+_[a-zA-Z0-9-]+|ga\d+|ip[\d_]+|gg[a-zA-Z0-9]+-[a-zA-Z0-9-]+)/,
          link: 'http://ichiba.nicovideo.jp/item/%s',
        },
        {
          pattern: /lv\d{1,14}/,
          link: 'http://live.nicovideo.jp/watch/%s',
        },
        {
          pattern: /[sm]g\d{1,14}/,
          link: 'http://seiga.nicovideo.jp/watch/%s',
        },
        {
          pattern: /bk\d{1,14}/,
          link: 'http://seiga.nicovideo.jp/watch/%s',
        },
        {
          pattern: /im\d{1,14}/,
          link: 'http://seiga.nicovideo.jp/seiga/%s',
        },
        {
          pattern: %r{commons\.nicovideo\.jp/user/\d+},
          link: 'http://%s',
        },
        {
          pattern: %r{niconicommons\.jp/user/\d+},
          link: 'http://www.%s',
        },
        {
          pattern: %r{user/illust/\d+},
          link: 'http://seiga.nicovideo.jp/%s',
        },
        {
          pattern: %r{clip/\d+},
          link: 'http://seiga.nicovideo.jp/%s',
        },
        {
          pattern: %r{ch\.nicovideo\.jp/[a-zA-Z0-9][-_a-zA-Z0-9]+(?=[^\-_A-Za-z0-9/]|$)},
          link: 'http://%s',
        },
        {
          pattern: /jps\d{1,14}/,
          link: 'http://jpstore.dwango.jp/products/detail.php?product_id=%s',
          convert: -> (str) { str.sub('jps', '') },
        },
        {
          pattern: /kn\d+/,
          link: 'https://niconare.nicovideo.jp/watch/%s',
        },
        {
          pattern: /gm\d+/,
          link: 'https://game.nicovideo.jp/atsumaru/games/%s',
        },
        {
          pattern: /mt\d+/,
          link: 'https://mtm.nicovideo.jp/watch/%s',
        },
      ].freeze
    end
  end
end
