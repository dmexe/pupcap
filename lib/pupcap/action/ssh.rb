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
end
