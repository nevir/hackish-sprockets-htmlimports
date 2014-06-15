require 'sprockets/asset'

module Sprockets
  module HTMLImports
    class WrappedAsset < Sprockets::Asset
      def initialize(environment, attributes, asset)
        @attributes = attributes
        @asset      = asset

        @root         = environment.root
        @logical_path = attributes.logical_path
        @pathname     = attributes.pathname
        @content_type = attributes.content_type
        @mtime        = asset.mtime
        @digest       = asset.digest

        # See ProcessedAsset#build_required_assets.
        @required_assets = [self]

        wrap_source
      end

      attr_reader :source

      protected

      def wrap_source
        unless @attributes.content_type == 'text/html'
          fail 'Only know how to wrap assets with html'
        end

        @source = case @asset.content_type
        when 'application/javascript'
          "<script>#{@asset.to_s}</script>"
        when 'text/css'
          "<style>#{@asset.to_s}</style>"
        else
          fail 'Only know how to wrap js or css assets'
        end
        @length = Rack::Utils.bytesize(@source)
      end
    end
  end
end
