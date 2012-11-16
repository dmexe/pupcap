require 'optparse'
require 'pupcap'

class Pupcap::CLI
  class << self
    def start
      action = ARGV.last
      if !action || !valid_actions.include?(action)
        $stderr.puts "Please specify a action to run: #{valid_actions.join("|")}"
        exit 1
      end

      ARGV.pop
      require "pupcap/action/#{action}"
      klass = Pupcap::Action.const_get(action.capitalize)
      inst = klass.new
      inst.start
    end

    def valid_actions
      %w{ prepare cook ssh }
    end
  end
end
