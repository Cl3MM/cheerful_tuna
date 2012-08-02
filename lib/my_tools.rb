#encoding: utf-8
module MyTools

  # this turns a unique hash suitable for obfuscating the URL of an otherwise
  # publicly viewable attachment.
  def hash_hash(hash_data, hash_digest = "SHA1", hash_secstr = "NSWGbjMdPUAt2XV6hyJCKDgwQzi73vBe8Rlcmf95FpLk4YuxrHqZoaTEns")
    #raise ArgumentError, "Unable to generate hash without :hash_secstr" unless @hash_secstr
    require 'openssl' unless defined?(OpenSSL)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.const_get(hash_digest).new, hash_secstr, hash_data)
  end

  def friendly_user_name str
    begin
      str.strip
      #blow away apostrophes
      str.gsub! /['`]/,""
      # @ --> at, and & --> and
      str.gsub! /@/, " at "
      str.gsub! /&/, " and "
      str.gsub! /\b\.\b/, ""
      str.gsub! /\bgmbh|ltd|corp|sarl|sas|sl|sa|inc\b/i, ""
      Hash[*%w(ä a Ä A ö o Ö O ü u Ü U ß B é e è e à a ù u ë e ê e î i û u â a ç c')].each_pair do |k,v|
        str.gsub!(/#{k}/, v)
      end
      #replace all non alphanumeric, underscore or periods with underscore
      str.gsub! /\s*[^A-Za-z0-9\-\.\-]\s*/, '_'
      #convert double underscores to single
      str.gsub! /_+/,"_"
      #strip off leading/trailing underscore
      str.gsub! /\A[_\.]+|[_\.]+\z/,""
    rescue
      str = "An error occured, please generate a new username"
    end
    str.downcase
  end
  module_function :friendly_user_name

  def generate_random_string len
    require 'digest/sha1'
    Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by{rand}.join)[0..len]
  end
  module_function :generate_random_string

end
