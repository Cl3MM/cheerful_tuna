module VestalVersions
  # The ActiveRecord model representing versions.
  class Version < ActiveRecord::Base
    attr_accessible :tag
  end
end
