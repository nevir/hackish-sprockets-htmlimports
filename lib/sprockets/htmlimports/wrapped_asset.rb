require 'sprockets/asset'

module Sprockets
  module HTMLImports
    class WrappedAsset < Sprockets::Asset
      def initialize(environment, attributes, asset)
        @environment = environment
        @attributes  = attributes
        @asset       = asset

        @root         = environment.root
        @logical_path = attributes.logical_path
        @pathname     = attributes.pathname
        @content_type = attributes.content_type
        @mtime        = asset.mtime
        @digest       = asset.digest

        # byebug

        # See ProcessedAsset#build_required_assets.
        @required_assets = [self]

        wrap_source
      end

      attr_reader :source, :environment

      protected

      def short_type(content_type)
        content_type.split('/').last
      end

      def wrap_source
        to_type   = @attributes.content_type
        from_type = @asset.content_type
        sym       = :"wrap_#{short_type(from_type)}_in_#{short_type(to_type)}"
        unless methods.include? sym
          fail "Don't know how to wrap #{from_type} in #{to_type} - #{sym}"
        end
        @source = send(sym)
        @length = Rack::Utils.bytesize(@source)
      end

      def wrap_javascript_in_html
        "<script>#{bundle_process_asset(@asset)}</script>"
      end

      def wrap_css_in_html
        "<style>#{bundle_process_asset(@asset)}</style>"
      end

      def bundle_process_asset(asset)
        context = environment.context_class.new(environment, logical_path, pathname)
        context.evaluate(@asset.pathname,
          data:       asset.to_s,
          processors: environment.bundle_processors[asset.content_type],
        )
      end
    end
  end
end
