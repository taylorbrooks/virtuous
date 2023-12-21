module Virtuous
  ##
  # Helper methods for hashes
  class HashHelper
    ##
    # Recieves a block which is called on all of the keys of the hash,
    # including the keys nested hashes inside.
    # @param hash [Hash] the hash to call the block upon.
    # @return [Hash] A new hash with the transformed keys.
    def self.deep_transform_keys(hash, &transform)
      new_hash = {}
      hash.each_key do |key|
        value = hash[key]
        new_key = transform.call(key)
        new_hash[new_key] = if value.is_a?(Array)
                              value.map do |item|
                                item.is_a?(Hash) ? deep_transform_keys(item, &transform) : item
                              end
                            elsif value.is_a?(Hash)
                              deep_transform_keys(value, &transform)
                            else
                              value
                            end
      end
      new_hash
    end
  end
end
