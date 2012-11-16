require 'pupcap/action'

class Pupcap::Action::Cook < Pupcap::Action::Base
  def initialize
    check_role!
    check_puppetfile!
    ENV["ROLES"] = parsed_options[:role]
  end

  def start
    cap = create_cap_for(parsed_options[:file])
    cap_load_and_run_task(cap, "cook")
  end

  def parsed_options
    unless @parsed_options
      options = default_options.dup
      OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename($0)} [options] <role> cook"

        opts.on("-h", "--help", "Displays this help info") do
          puts opts
          exit 0
        end

        opts.on("-d", "--debug", "Debug output") do
          options[:force] = true
        end

        opts.on("-n", "--noop", "Noop") do |file|
          options[:noop] = true
        end
      end.parse!
      options[:role] = ARGV.first
      @parsed_options = options
    end
    @parsed_options
  end

  def default_options
    {
      :file    => File.expand_path("Puppetfile"),
      :debug   => false,
      :noop    => false
    }
  end
end
