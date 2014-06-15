require 'sprockets/context'

Sprockets::Context.class_eval do
  def require_implicit_asset(path)
    require_asset(Sprockets::AssetAttributes.wrap_for_format(
      resolve(path), @environment.attributes_for(pathname).format_extension
    ))
  end

  def resolve_with_implicit_wrapping(path, *args, &block)
    attributes = environment.attributes_for(path)
    unless attributes.implicitly_wrapped?
      return resolve_without_implicit_wrapping(path, *args, &block)
    end

    real_path = attributes.real_logical_path
    Sprockets::AssetAttributes.wrap_for_format(
      environment.resolve(real_path, {base_path: pathname.dirname}),
      attributes.implicit_format_extension
    )
  end
  alias_method :resolve_without_implicit_wrapping, :resolve
  alias_method :resolve, :resolve_with_implicit_wrapping
end
