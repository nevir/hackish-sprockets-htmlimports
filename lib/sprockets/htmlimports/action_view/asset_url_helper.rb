::ActionView::Helpers::AssetUrlHelper.module_eval do
  def htmlimport_path(source, options = {})
    path_to_asset(source, {type: :htmlimport}.merge!(options))
  end
  alias_method :path_to_htmlimport, :htmlimport_path # aliased to avoid conflicts with an htmlimport_path named route

  def htmlimport_url(source, options = {})
    url_to_asset(source, {type: :htmlimport}.merge!(options))
  end
  alias_method :url_to_htmlimport, :htmlimport_url # aliased to avoid conflicts with an htmlimport_url named route

  def compute_asset_path_with_htmlimports(source, options = {})
    if options[:type] == :htmlimport
      File.join('/components', source)
    else
      compute_asset_path_without_htmlimports(source, options)
    end
  end
  alias_method_chain :compute_asset_path, :htmlimports

  def compute_asset_extname_with_htmlimports(source, options = {})
    unless options[:extname].nil? && options[:type] == :htmlimport
      return compute_asset_extname_without_htmlimports(source, options)
    else
      File.extname(source) == '.html' ? nil : '.html'
    end
  end
  alias_method_chain :compute_asset_extname, :htmlimports
end
