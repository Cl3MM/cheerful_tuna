module MyTools

  # Returns a unique hash suitable for obfuscating the URL of an otherwise
  # publicly viewable attachment.
  def hash_hash(hash_data, hash_digest = "SHA1", hash_secret = "NSWGbjMdPUAt2XV6hyJCKDgwQzi73vBe8Rlcmf95FpLk4YuxrHqZoaTEns")
    #raise ArgumentError, "Unable to generate hash without :hash_secret" unless @hash_secret
    require 'openssl' unless defined?(OpenSSL)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.const_get(hash_digest).new, hash_secret, hash_data)
  end
  def hash(a = 1, b = 2)
    a + b
  end
end
