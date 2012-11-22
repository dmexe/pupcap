require 'pupcap/action'
require 'pupcap/command'
require 'pupcap/lsb_release'

class Pupcap::Action::Prepare < Pupcap::Action::Base
  def initialize
    check_puppetfile!
    check_prepare_script!
  end

  def start
    cap = create_cap_for(parsed_options[:file])
    cap_load_and_run_task(cap, "prepare")
  end

  def check_prepare_script!
    unless File.exists?(parsed_options[:script])
      $stderr.puts "File #{parsed_options[:script]} does not exists"
      exit 1
    end
  end

  def default_options
    {
      :file    => File.expand_path("Pupcapfile"),
      :script  => File.expand_path("prepare.sh.erb"),
    }
  end
end

