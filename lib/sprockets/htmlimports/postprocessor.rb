require 'tilt'
require 'sprockets/htmlimports/doc_parser'

module Sprockets
  module HTMLImports
    # TODO(imac): Support minification.
    class Postprocessor < Tilt::Template
      DEPENDENCY_MATCHERS = {
        import: [:link, {rel: 'import', href: true}],
        script: [:script,
          {src: true, type: false},
          {src: true, type: 'text/javascript'},
        ],
        style:  [:link, {rel: 'stylesheet', href: true}],
      }
      # All the tags expressed by the matchers we will run.
      PARSED_TAGS = [:link, :script]

      def prepare
        @doc = Sprockets::HTMLImports::DocParser.new(data, PARSED_TAGS)
      end

      def evaluate(context, locals, &block)
        @context = context
        @logical_path = Pathname.new(context.logical_path)

        doc.replace(DEPENDENCY_MATCHERS) do |node, filter_type|
          send(:"visit_#{filter_type}_node", node)
        end

        doc.to_html
      end

      protected

      attr_reader :context, :doc, :logical_path

      def relative_path(path)
        # TODO(imac): Deal with absolute paths.
        logical_path.dirname.join(path)
      end

      def remove_node(node)
        # TODO(imac): Actually remove; only comment in debug mode.
        "<!-- sprockets-htmlimports: #{node.original_tag} -->"
      end

      def visit_import_node(node)
        # TODO(imac): Deal with imports nested within templates/etc?
        parent_name = node.parent.tag
        return unless parent_name == :head || parent_name == :body

        context.require_asset(relative_path(node.attribute('href').value))
        remove_node(node)
      end

      def visit_script_node(node)
        asset_path = relative_path(node.attribute('src').value)
        context.require_implicit_asset(asset_path)

        # TODO(imac): Rewrite sourceMappingURL comments.
        remove_node(node)
      end

      def visit_style_node(node)
        asset_path = relative_path(node.attribute('href').value)
        context.depend_on(asset_path)
        content = context.evaluate(asset_path)

        # TODO(imac): Support requiring in addition to inlining.
        # TODO(imac): Rewrite sourceMappingURL comments.
        remove_node(node) + %Q{\n<style>#{content}</style>}
      end
    end
  end
end
