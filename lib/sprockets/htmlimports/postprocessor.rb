require 'tilt'
require 'sprockets/htmlimports/doc_parser'

module Sprockets
  module HTMLImports
    # TODO(imac): Support minification.
    class Postprocessor < Tilt::Template
      IMPORT_MATCHER = [:link, {rel: 'import', href: true}]
      REMOTE_SCRIPT_MATCHER = [:script, {src: true, type: false}, {src: true, type: 'text/javascript'}]
      REMOTE_STYLE_MATCHER = [:link, {rel: 'stylesheet', href: true}]
      # All the tags expressed by the matchers we will run.
      PARSED_TAGS = [:link, :script]

      def prepare
        @doc = Sprockets::HTMLImports::DocParser.new(data, PARSED_TAGS)
      end

      def evaluate(context, locals, &block)
        @context = context
        @logical_path = Pathname.new(context.logical_path)

        # TODO(imac): Set context.__LINE__ appropriately.
        process_imports
        process_javascripts
        process_stylesheets

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

      def process_imports
        doc.replace(*IMPORT_MATCHER) do |link|
          # TODO(imac): Deal with imports nested within templates/etc?
          parent_name = link.parent.tag
          next unless parent_name == :head || parent_name == :body

          context.require_asset(relative_path(link.attribute('href').value))

          remove_node(link)
        end
      end

      def process_javascripts
        doc.replace(*REMOTE_SCRIPT_MATCHER) do |script|
          asset_path = relative_path(script.attribute('src').value)
          context.depend_on(asset_path)
          content = context.evaluate(asset_path)

          # TODO(imac): Support path rewriting in addition to inlining.
          # TODO(imac): Rewrite sourceMappingURL comments.
          remove_node(script) + %Q{\n<script>#{content}</script>}
        end
      end

      def process_stylesheets
        doc.replace(*REMOTE_STYLE_MATCHER) do |link|
          asset_path = relative_path(link.attribute('href').value)
          context.depend_on(asset_path)
          content = context.evaluate(asset_path)

          # TODO(imac): Support path rewriting in addition to inlining.
          # TODO(imac): Rewrite sourceMappingURL comments.
          remove_node(link) + %Q{\n<style>#{content}</style>}
        end
      end
    end
  end
end
