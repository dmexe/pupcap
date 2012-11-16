require 'pupcap/action'

class Pupcap::Action::Cook < Pupcap::Action::Base
  def start
    cap.load "#{root}/cook/Capfile"
    cap.trigger(:load)
    cap.find_and_execute_task("cook", :before => :start, :after => :finish)
    cap.trigger(:exit)
  end

  def root
    File.dirname(File.expand_path __FILE__)
  end
end
