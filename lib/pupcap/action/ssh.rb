require 'pupcap/action'
require 'pupcap/command'

class Pupcap::Action::Ssh < Pupcap::Action::Base
  def initialize
    check_puppetfile!
  end

  def start
    cap = create_cap_for(parsed_options[:file])
    cap_load_and_run_task(cap, "ssh")
  end

  def parsed_options
    unless @parsed_options
      options = default_options.dup
      OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename($0)} [options] ssh <role>"

        opts.on("-f", "--file FILE", "A recipe file to load") do |file|
          options[:file] = File.expand_path(file)
        end

        opts.on("-h", "--help", "Displays this help info") do
          puts opts
          exit 0
        end
      end.parse!
      options[:tasks] = ARGV
      @parsed_options = options
    end
    @parsed_options
  end

  def default_options
    {
      :file    => File.expand_path("Puppetfile"),
    }
  end
end
