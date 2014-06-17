require 'set'
require 'sprockets/htmlimports/base_processor'

module Sprockets
  module HTMLImports
    class HTMLCompressor < BaseProcessor
      COPYRIGHT_MATCHER = /copyright/i

      def prepare
        super
        @seen_copyrights = {}
      end

      protected

      # TODO(imac): Whitespace compression.
      def dependency_matchers
        {
          comment: [Gumbo::Comment],
        }
      end

      def replace_comment_node(node)
        if node.text =~ COPYRIGHT_MATCHER
          "<!--#{copyright_text(node.text)}-->"
        else
          ''
        end
      end

      # TODO(imac): IANAL, but this seems reasonable?
      def copyright_text(text)
        text = text.strip
        if seen_id = @seen_copyrights[text]
          text = "See #{notice_label(seen_id)} above"
        else
          seen_id = @seen_copyrights.size + 1
          @seen_copyrights[text] = seen_id
          text = "#{notice_label(seen_id)}:\n#{text}"
        end

        text
      end

      def notice_label(id)
        "NOTICE #{id}"
      end
    end
  end
end
