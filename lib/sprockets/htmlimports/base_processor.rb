require 'tilt'
require 'sprockets/htmlimports/doc_parser'

module Sprockets
  module HTMLImports
    class BaseProcessor < Tilt::Template
      def prepare
        @doc = Sprockets::HTMLImports::DocParser.new(data, parsed_tags)
      end

      def evaluate(context, locals, &block)
        @context = context
        @logical_path = Pathname.new(context.logical_path)

        doc.replace(dependency_matchers) do |node, filter_type|
          send(:"replace_#{filter_type}_node", node)
        end

        doc.to_html
      end

      protected

      attr_reader :context, :doc, :logical_path

      def parsed_tags
        dependency_matchers.values.map(&:first).uniq
      end

      def relative_path(path)
        # TODO(imac): Deal with absolute paths.
        logical_path.dirname.join(path)
      end

      def remove_node(node)
        # TODO(imac): Actually remove; only comment in debug mode.
        "<!-- sprockets-htmlimports: #{node.original_tag} -->"
      end
    end
  end
end
