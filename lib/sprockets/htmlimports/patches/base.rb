require 'sprockets/base'
require 'sprockets/htmlimports/wrapped_asset'

Sprockets::Base.class_eval do
  def find_asset_with_implicit_wrapping(path, options = {})
    puts "find_asset(#{path.inspect}, #{options.inspect})"
    attributes = attributes_for(path)
    unless attributes.implicitly_wrapped?
      return find_asset_without_implicit_wrapping(path, options)
    end

    real_path = attributes.real_logical_path
    asset = find_asset_without_implicit_wrapping(real_path, options)
    Sprockets::HTMLImports::WrappedAsset.new(self, attributes, asset)
  end
  alias_method :find_asset_without_implicit_wrapping, :find_asset
  alias_method :find_asset, :find_asset_with_implicit_wrapping

end
