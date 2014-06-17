require 'sprockets'

require 'sprockets/htmlimports/patches/asset_attributes'
require 'sprockets/htmlimports/patches/base'
require 'sprockets/htmlimports/patches/compressing'
require 'sprockets/htmlimports/patches/context'

require 'sprockets/htmlimports/base_processor'
require 'sprockets/htmlimports/bundle_reprocessor'
require 'sprockets/htmlimports/postprocessor'
require 'sprockets/htmlimports/simple_html_compressor'
require 'sprockets/htmlimports/wrapped_asset'

Sprockets.register_mime_type 'text/html', '.html'
Sprockets.register_postprocessor 'text/html', Sprockets::HTMLImports::Postprocessor
Sprockets.register_bundle_processor 'text/html', Sprockets::HTMLImports::BundleReprocessor
Sprockets.register_compressor 'text/html', :simple, Sprockets::HTMLImports::SimpleHTMLCompressor

begin
  require 'action_view'
rescue LoadError
end
if defined? ::ActionView
  require 'sprockets/htmlimports/action_view/asset_tag_helper'
  require 'sprockets/htmlimports/action_view/asset_url_helper'
end

begin
  require 'rails/railtie'
rescue LoadError
end
if defined? ::Rails::Railtie
  require 'sprockets/htmlimports/rails/railtie'
end
