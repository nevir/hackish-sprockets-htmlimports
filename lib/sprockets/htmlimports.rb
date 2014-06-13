require 'sprockets'

require 'sprockets/htmlimports/postprocessor'

Sprockets.register_mime_type 'text/html', '.html'
Sprockets.register_postprocessor 'text/html', Sprockets::HTMLImports::Postprocessor

begin
  require 'action_view'
  require 'sprockets/htmlimports/action_view/asset_tag_helper'
  require 'sprockets/htmlimports/action_view/asset_url_helper'
rescue LoadError
end
