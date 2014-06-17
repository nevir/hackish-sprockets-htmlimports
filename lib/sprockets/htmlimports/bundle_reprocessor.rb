require 'sprockets/htmlimports/base_processor'

module Sprockets
  module HTMLImports
    class BundleReprocessor < BaseProcessor
      protected

      def dependency_matchers
        {
          script: [:script, {src: false}],
          style:  [:style],
        }
      end

      def replace_script_node(node)
        wrap_node(node, 'application/javascript')
      end

      def replace_style_node(node)
        wrap_node(node, 'text/css')
      end

      def wrap_node(node, content_type)
        return node.original_tag unless node.original_end_tag
        content = bundle_process_content(data[node.content_range], content_type)

        node.original_tag + content + node.original_end_tag
      end

      def bundle_process_content(content, content_type)
        bundle_processors = context.environment.bundle_processors

        context.evaluate(context.pathname,
          data:       content,
          processors: bundle_processors[content_type],
        )
      end
    end
  end
end
