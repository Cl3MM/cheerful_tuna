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

  def time_it_function
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil

    date = "2012-06-28".to_date
    runs = [5,10,50,100,500,1000]
    # run the functions
    stats = runs.inject({optimized: {}, normal: {}}) do |data, time|
      start = Time.now
      time.times do |run|
        User.optimized date
      end
      stop = Time.now - start
      data[:optimized][time] = stop

      start = Time.now
      time.times do |run|
        User.contacts_per_user_stats date
      end
      stop = Time.now - start
      data[:normal][time] = stop

      data
    end

    ActiveRecord::Base.logger = old_logger

    # display results
    #
    puts "    \t|" + runs.map{|r| "#{r.to_s.size < 4 ? "   " : "  " }#{r.to_s}"}.join("\t|") + "\t|  avg |\n"
    row1, row2 = ["opti"], ["norm"]
    runs.each do |key|
      row1 << "#{"%5.2fs" % stats[:optimized][key]}"
      row2 << "#{"%5.2fs" % stats[:normal][key]}"
    end
    row1 << "%5.2fs" % stats[:optimized].values.instance_eval { reduce(:+) / size.to_f }.to_s
    row2 << "%5.2fs" % stats[:normal].values.instance_eval { reduce(:+) / size.to_f }.to_s

    puts row1.join("\t|") + "|\n"
    puts row2.join("\t|") + "|\n"

    stats
  end
  module_function :time_it_function
end
