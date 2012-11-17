require 'pupcap/action/apply'

class Pupcap::Action::Noop < Pupcap::Action::Apply
  def start
    cap = create_cap_for(parsed_options[:file])
    cap.pupcap_options[:noop] = true
    cap_load_and_run_task(cap, "apply")
  end
end
