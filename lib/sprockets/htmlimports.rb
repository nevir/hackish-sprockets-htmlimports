require 'sprockets'

require 'sprockets/htmlimports/patches/asset_attributes'
require 'sprockets/htmlimports/patches/base'
require 'sprockets/htmlimports/patches/context'

require 'sprockets/htmlimports/base_processor'
require 'sprockets/htmlimports/bundle_reprocessor'
require 'sprockets/htmlimports/html_compressor'
require 'sprockets/htmlimports/postprocessor'
require 'sprockets/htmlimports/wrapped_asset'

Sprockets.register_mime_type 'text/html', '.html'
Sprockets.register_postprocessor 'text/html', Sprockets::HTMLImports::Postprocessor
Sprockets.register_bundle_processor 'text/html', Sprockets::HTMLImports::BundleReprocessor
Sprockets.register_bundle_processor 'text/html', Sprockets::HTMLImports::HTMLCompressor

begin
  require 'action_view'
  require 'sprockets/htmlimports/action_view/asset_tag_helper'
  require 'sprockets/htmlimports/action_view/asset_url_helper'
rescue LoadError
end
