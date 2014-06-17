module Sprockets
  module HTMLImports
    module Rails
      class Railtie < ::Rails::Railtie
        initializer :configure_sprockets_for_htmlimports, group: :all do |app|
          app.assets.html_compressor = app.config.assets.html_compressor
        end
      end
    end
  end
end
