#encoding: utf-8
module Statistics
  class Contacts
    attr_accessor :attendance
    def initialize args = {}
      #args.with_defaults(range: "week", date: Time.now)
      @attendance = args
    end
  end
end
