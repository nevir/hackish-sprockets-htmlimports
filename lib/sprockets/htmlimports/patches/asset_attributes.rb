require 'sprockets/asset_attributes'

Sprockets::AssetAttributes.class_eval do
  IMPLICIT_WRAP_EXTENSION = '.WRAP_IN:'

  def self.wrap_for_format(path, format_extension)
    Pathname.new(path.to_s + IMPLICIT_WRAP_EXTENSION + format_extension)
  end

  def implicitly_wrapped?
    extensions[-2] == IMPLICIT_WRAP_EXTENSION
  end

  def implicit_extensions
    implicitly_wrapped? ? extensions[-2..-1] : []
  end

  def implicit_format_extension
    extensions.last
  end

  def real_logical_path
    return logical_path unless implicitly_wrapped?
    logical_path[0...-implicit_extensions.map(&:size).reduce(:+)]
  end

  def real_pathname
    return pathname unless implicitly_wrapped?
    Pathname.new(pathname.to_s[0...-implicit_extensions.map(&:size).reduce(:+)])
  end
end
