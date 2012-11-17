require 'pupcap/action'
require 'pupcap/command'

class Pupcap::Action::Apply < Pupcap::Action::Base
  def initialize
    check_puppetfile!
  end

  def start
    cap = create_cap_for(parsed_options[:file])
    cap_load_and_run_task(cap, "apply")
  end

  def parsed_options
    unless @parsed_options
      options = default_options.dup
      OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename($0)} cook [options] <role>"

        opts.on("-f", "--file FILE", "A recipe file to load") do |file|
          options[:file] = File.expand_path(file)
        end

        opts.on("-h", "--help", "Displays this help info") do
          puts opts
          exit 0
        end

        opts.on("-d", "--debug", "Debug output") do
          options[:debug] = true
        end

        opts.on("-n", "--noop", "Noop") do |file|
          options[:noop] = true
        end

        opts.on("-w", "--without-librarian-puppet", "Deploy without librarian-puppet") do
          options[:without_librarian_puppet] = true
        end
      end.parse!
      options[:tasks] = ARGV
      @parsed_options = options
    end
    @parsed_options
  end

  def default_options
    {
      :file    => File.expand_path("Pupcapfile"),
      :debug   => false,
      :noop    => false
    }
  end
end
