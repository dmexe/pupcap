require 'scanf'
module Pupcap

  class Version

    MAJOR = 0
    MINOR = 2
    PATCH = 3

    def self.to_s
      "#{MAJOR}.#{MINOR}.#{PATCH}"
    end

  end

end
