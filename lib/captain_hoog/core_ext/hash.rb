class Hash
  def stringify_keys
    reduce({}) do |hash, (key, value)|
      new_value = if value.respond_to?(:stringify_keys)
        value.stringify_keys
      else
        value
      end
      hash.merge(key.to_s => new_value)
    end
  end
end
