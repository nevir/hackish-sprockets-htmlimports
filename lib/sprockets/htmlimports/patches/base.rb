require 'sprockets/base'
require 'sprockets/htmlimports/wrapped_asset'

Sprockets::Base.class_eval do
  def find_asset_with_implicit_wrapping(path, options = {})
    attributes = attributes_for(path)
    unless attributes.implicitly_wrapped?
      return find_asset_without_implicit_wrapping(path, options)
    end

    # Make sure that we are dealing with a fully resolved path.
    unless attributes.pathname.absolute?
      real_pathname = resolve(attributes.real_pathname)
      attributes = attributes_for(Sprockets::AssetAttributes.wrap_for_format(
        real_pathname, attributes.implicit_format_extension
      ))
    end

    real_logical_path = attributes.real_logical_path
    asset = find_asset_without_implicit_wrapping(real_logical_path, options)

    Sprockets::HTMLImports::WrappedAsset.new(self, attributes, asset)
  end
  alias_method :find_asset_without_implicit_wrapping, :find_asset
  alias_method :find_asset, :find_asset_with_implicit_wrapping

end
