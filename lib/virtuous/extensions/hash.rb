##
# Extensions of the Hash class.
class Hash
  ##
  # Recieves a block which is called on all of the keys of the hash,
  # including the keys nested hashes inside.
  # Returns a new hash with the transformed keys.
  def deep_transform_keys(&transform)
    new_hash = {}
    keys.each do |key|
      value = self[key]
      new_key = transform.call(key)
      new_hash[new_key] = if value.is_a?(Array)
                            value.map do |item|
                              item.is_a?(Hash) ? item.deep_transform_keys(&transform) : item
                            end
                          elsif value.is_a?(Hash)
                            value.deep_transform_keys(&transform)
                          else
                            value
                          end
    end
    new_hash
  end
end
