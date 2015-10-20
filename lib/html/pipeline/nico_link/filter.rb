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
        doc.search('.//text()').each do |node|
          next if has_ancestor?(node, IGNORE_PARENTS)
          content = node.to_html
          has_prev_node = !!(node.previous_element)
          html = apply_filter(content, has_prev_node)
          next if html == content
          node.replace(html)
        end
        doc
      end

      def apply_filter(content, has_prev_node = false)
        content = content.dup
        self.patterns.each do |pattern_set|
          content.gsub!(pattern_set[:pattern]) do
            space = $1
            text = $2
            url = pattern_set[:link].gsub('%s', text)
            "#{space.size > 0 ? space : (has_prev_node ? ' ' : '')}<a href=\"#{ERB::Util.html_escape(url)}\">#{ERB::Util.html_escape(text)}</a>"
          end
        end
        content
      end

      def patterns
        @patterns ||= (@context[:nico_link] || DEFAULT_PATTERNS).map do |pattern_set|
          {
            pattern: create_pattern(pattern_set[:pattern]),
            link: pattern_set[:link],
          }
        end
      end

      def create_pattern(key)
        /
          (^|\W)
          (#{key})
          (?=
            \.+[ \t\W]|
            \.+$|
            [^0-9a-zA-Z_.]|
            $
          )
        /ix
      end

      IGNORE_PARENTS = %w[pre code a style script].to_set

      DEFAULT_PATTERNS = [
        {
          pattern: /(?:sm|nm|so|ca|ax|yo|nl|ig|na|cw|z[a-e]|om|sk|yk)\d{1,14}/,
          link: 'http://www.nicovideo.jp/watch/%s'
        },
        {
          pattern: /(?:watch|user|myvideo|mylist)\d{1,14}/,
          link: 'http://www.nicovideo.jp/%s'
        },
        {
          pattern: /(?:co)\d{1,14}/,
          link: 'http://com.nicovideo.jp/%s'
        },
        {
          pattern: /(?:ch)\d{1,14}/,
          link: 'http://ch.nicovideo.jp/%s'
        },
        {
          pattern: /(?:ar)\d{1,14}/,
          link: 'http://ch.nicovideo.jp/article/%s'
        },
        {
          pattern: /(?:td)\d+/,
          link: 'http://3d.nicovideo.jp/works/%s',
        },
        {
          pattern: /(?:nc)\d{1,14}/,
          link: 'http://commons.nicovideo.jp/material/%s',
        },
        {
          pattern: /(?:dw\\d+|az[A-Z0-9]{10}|ys[a-zA-Z0-9-]+_[a-zA-Z0-9-]+|ga\\d+|ip[\\d_]+|gg[a-zA-Z0-9]+-[a-zA-Z0-9-]+)/,
          link: 'http://ichiba.nicovideo.jp/item/%s',
        },
        {
          pattern: /(?:lv)\d{1,14}/,
          link: 'http://live.nicovideo.jp/watch/%s',
        },
        {
          pattern: /(?:[sm]g)\d{1,14}/,
          link: 'http://seiga.nicovideo.jp/watch/%s',
        },
        {
          pattern: /(?:bk)\d{1,14}/,
          link: 'http://seiga.nicovideo.jp/watch/%s',
        },
        {
          pattern: /(?:im)\d{1,14}/,
          link: 'http://seiga.nicovideo.jp/seiga/%s',
        },
        {
          pattern: /commons\.nicovideo\.jp\/user\/\d+/,
          link: 'http://%s',
        },
        {
          pattern: /niconicommons\.jp\/user\/\d+/,
          link: 'http://www.%s',
        },
        {
          pattern: /user\/illust\/\d+/,
          link: 'http://seiga.nicovideo.jp/%s',
        },
        {
          pattern: /clip\/\d+/,
          link: 'http://seiga.nicovideo.jp/%s',
        },
        {
          pattern: /ch\.nicovideo\.jp\/[a-zA-Z0-9][-_a-zA-Z0-9]+(?=[^\-_A-Za-z0-9\/]|$)/,
          link: 'http://%s',
        },
      ]
    end
  end
end
