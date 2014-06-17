require 'sprockets/htmlimports/base_processor'

module Sprockets
  module HTMLImports
    class Postprocessor < BaseProcessor
      protected

      def dependency_matchers
        {
          import: [:link, {rel: 'import', href: true}],
          script: [:script,
            {src: true, type: false},
            {src: true, type: 'text/javascript'},
          ],
          style:  [:link, {rel: 'stylesheet', href: true}],
        }
      end

      def replace_import_node(node)
        # TODO(imac): Deal with imports nested within templates/etc?
        parent_name = node.parent.tag
        return unless parent_name == :head || parent_name == :body

        context.require_asset(relative_path(node.attribute('href').value))
        remove_node(node)
      end

      def replace_script_node(node)
        asset_path = relative_path(node.attribute('src').value)
        context.require_implicit_asset(asset_path)

        # TODO(imac): Rewrite sourceMappingURL comments.
        remove_node(node)
      end

      def replace_style_node(node)
        asset_path = relative_path(node.attribute('href').value)
        context.depend_on(asset_path)
        content = context.evaluate(asset_path)

        # TODO(imac): Support requiring in addition to inlining.
        # TODO(imac): Rewrite sourceMappingURL comments.
        bundle_processors = context.environment.bundle_processors
        context.evaluate(asset_path,
          data: content,
          processors: bundle_processors['text/css'],
        )

        remove_node(node) + %Q{\n<style>#{content}</style>}
      end
    end
  end
end
