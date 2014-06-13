::ActionView::Helpers::AssetTagHelper.module_eval do
  def import_tag(*sources)
    options = sources.extract_options!.stringify_keys
    path_options = options.extract!('protocol', 'extname').symbolize_keys

    sources.uniq.map { |source|
      tag_options = {
        'rel' => 'import',
        'href' => path_to_htmlimport(source, path_options)
      }.merge!(options)
      tag(:link, tag_options)
    }.join("\n").html_safe
  end

  # Override htmlimport tag helper to provide debugging support.
  #
  # TODO(imac): Remove and just use source maps. See:
  #  * https://github.com/rails/sprockets-rails/blob/master/lib/sprockets/rails/helper.rb#L122-165
  #  * https://github.com/sstephenson/sprockets/pull/311
  def import_tag_with_debugging(*sources)
    options = sources.extract_options!.stringify_keys

    if options["debug"] != false && request_debug_assets?
      sources.map { |source|
        check_errors_for(source, :type => :htmlimport)
        if asset = lookup_asset_for_path(source, :type => :htmlimport)
          asset.to_a.map do |a|
            import_tag_without_debugging(path_to_htmlimport(a.logical_path, :debug => true), options)
          end
        else
          import_tag_without_debugging(source, options)
        end
      }.flatten.uniq.join("\n").html_safe
    else
      sources.push(options)
      import_tag_without_debugging(*sources)
    end
  end
  alias_method_chain :import_tag, :debugging
end
