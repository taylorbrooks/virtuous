##
# Extensions of the String class.
class String
  ##
  # Transform a String from `CamelCase` to `snake_case`
  def underscore
    gsub('::', '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr('-', '_')
      .downcase
  end
end
