require 'pupcap/action'
require 'pupcap/lsb_release'

class Pupcap::Action::Prepare < Pupcap::Action::Base
  def initialize
    check_role!
    check_puppetfile!
    ENV["ROLES"] = parsed_options[:role]
  end

  def start
    cap = create_cap_for(parsed_options[:file])
    lsb = Pupcap::LsbRelease.new(cap)
    prepare_script = "#{lib_root}/prepare/#{lsb.name.downcase}/#{lsb.codename.downcase}.sh"
    if File.exists?(prepare_script)
      cap.set :pupcap_prepare_script, prepare_script
    end
    cap_load_and_run_task(cap, "prepare")
  end

  def parsed_options
    unless @parsed_options
      options = default_options.dup
      OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename($0)} [options] <role> prepare"

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
      end.parse!
      options[:role] = ARGV.first
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

