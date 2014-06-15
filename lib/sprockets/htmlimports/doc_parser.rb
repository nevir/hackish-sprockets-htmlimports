require 'gumbo'

module Sprockets
  module HTMLImports
    class DocParser
      Replacement = Struct.new(:node, :new_content)
      FilterMatch = Struct.new(:node, :filter_type)

      # WARNING: Modifies `data`!
      def initialize(data, interesting_tag_names)
        @nodes_by_tag_name = Hash.new { |h,k| h[k] = [] }
        @replacements = []

        @data = data.encode('UTF-8')
        @doc = Gumbo::parse(@data)

        index_interesting_tags(@doc, interesting_tag_names)
      end

      def select(filter_map, &block)
        matches = filter_map.map do |filter_type, filter|
          tag_name, attr_filters = filter[0], filter[1..-1]
          nodes = @nodes_by_tag_name[tag_name].select do |node|
            attr_filters_match? attr_filters, node
          end

          nodes.map { |n| FilterMatch.new(n, filter_type) }
        end.flatten

        matches.sort_by! { |m| m.node.offset_range.min }
        matches.each do |match|
          block.call(match.node, match.filter_type)
        end
      end

      def replace(filter_map, &block)
        select(filter_map) do |node, filter_type|
          new_content = block.call(node, filter_type)
          next unless new_content
          @replacements << Replacement.new(node, new_content) if new_content
        end
      end

      def to_html
        # Offsets are bytes, so we need to work with a raw string.
        @data.force_encoding('ASCII-8BIT')

        @replacements.sort_by! { |r| -r.node.offset_range.min }
        @replacements.each do |replacement|
          @data[replacement.node.offset_range] = replacement.new_content
        end

        @data.force_encoding('UTF-8')
        @data
      end

      protected

      def attr_filters_match?(attr_filters, node)
        attr_filters.any? do |attr_filter|
          attr_filter.all? do |key, value|
            attribute = node.attribute(key.to_s)

            case value
            when TrueClass then !!attribute
            when FalseClass then !attribute
            else attribute && attribute.value == value
            end
          end
        end
      end

      # TODO(imac): Recursion is probably a bad idea. Flatten out to a stack.
      def index_interesting_tags(node, interesting_tag_names)
        if node.is_a?(Gumbo::Element) && node.original_tag_name
          name = node.original_tag_name.downcase.to_sym
          if interesting_tag_names.include? name
            @nodes_by_tag_name[name] << node
          end
        end

        if node.respond_to? :children
          node.children.each do |child|
            index_interesting_tags(child, interesting_tag_names)
          end
        end
      end
    end
  end
end
