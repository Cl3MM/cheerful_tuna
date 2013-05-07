def debug msg, sep = "*", width = 100
  with = (width.is_a?(Integer) ? with : 100)
  Rails.logger.debug "#{sep}" * width
  puts "#{sep}" * width
  if msg.is_a? Array
    msg.each do |m|
      #m = m.ljust(50).truncate(50)
      Rails.logger.debug "#{sep}#{m.center(width - 2)}#{sep}"
      puts "#{sep}#{m.center(width - 2)}#{sep}"
    end
  else
    Rails.logger.debug "#{sep}#{msg.center(width - 2)}#{sep}"
    puts "#{sep}#{msg.center(width - 2)}#{sep}"
  end
  Rails.logger.debug "#{sep}" * width + "\n"
  puts "#{sep}" * width + "\n"
end
