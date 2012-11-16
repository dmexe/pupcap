require 'optparse'
require 'pupcap'

class Pupcap::CLI
  class << self
    def start
      get_action
      require "pupcap/action/#{options[:action]}"
      klass = Pupcap::Action.const_get(options[:action].capitalize)
      inst = klass.new(options[:file], options)
      inst.start
    end

    private
      def get_action
        options_parser

        action = ARGV[1]
        role   = ARGV[0]
        if !action || !valid_actions.include?(action)
          $stderr.puts "Please specify a action to run: #{valid_actions.join("|")}"
          exit 1
        end

        if !role
          $stderr.puts "Please specify a role to run"
          exit 1
        end

        unless File.exists?(options[:file])
          $stderr.puts "A file #{options[:file]} does not exists"
          exit 1
        end

        options.merge!(:action => action, :role => role)
      end

      def valid_actions
        @valid_actions ||= %w{ prepare cook }
      end

      def options
        @options ||= {
          :file => File.expand_path("Puppetfile")
        }
      end

      def options_parser
        @options_parser ||= OptionParser.new do |opts|
          opts.banner = "Usage: #{File.basename($0)} [options] role #{valid_actions.join("|")}"

          opts.on("-h", "--help", "Displays this help info") do
            puts opts
            exit 0
          end

          opts.on("-f", "--file FILE", "A recipe file to load") do |file|
            options[:file] = File.expand_path(file)
          end
        end.parse!
      end
  end
end
