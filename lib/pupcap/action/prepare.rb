require 'pupcap/action'
require 'pupcap/command'
require 'pupcap/lsb_release'

class Pupcap::Action::Prepare < Pupcap::Action::Base
  def initialize
    check_puppetfile!
  end

  def start
    cap = create_cap_for(parsed_options[:file])
    lsb = Pupcap::LsbRelease.new(cap)
    prepare_proc = lambda{ "#{lib_root}/prepare/#{lsb.name.downcase}/#{lsb.codename.downcase}.sh" }
    cap.set :pupcap_prepare_command, prepare_proc
    cap_load_and_run_task(cap, "prepare")
  end

  def parsed_options
    unless @parsed_options
      options = default_options.dup
      OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename($0)} prepare [options] <tasks>"

        opts.on("-h", "--help", "Displays this help info") do
          puts opts
          exit 0
        end

        opts.on("-F", "--force", "Force prepare") do
          options[:force] = true
        end

        opts.on("-f", "--file FILE", "A recipe file to load") do |file|
          options[:file] = File.expand_path(file)
        end

        opts.on("-n", "--hostname NAME", "Set hostname") do |name|
          options[:hostname] = name
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
      :force   => false,
      :upgrade => false
    }
  end
end

