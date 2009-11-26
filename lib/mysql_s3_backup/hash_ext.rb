class Hash
  # Return a new hash with all keys converted to symbols.
  # Stolen from ActiveSupport
  def symbolize_keys()
    inject({}) do |options, (key, value)|
      options[(key.to_sym rescue key) || key] = value
      options
    end
  end
end