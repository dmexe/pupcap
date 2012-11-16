require 'pupcap/action'

class Pupcap::Action::Prepare < Pupcap::Action::Base
  def start
    cap.load "#{root}/prepare/Capfile"
    cap.trigger(:load)
    cap.find_and_execute_task("prepare", :before => :start, :after => :finish)
    prepare_dist
    cap.trigger(:exit)
  end

  def root
    File.dirname(File.expand_path __FILE__)
  end

  def prepare_dist
    rel = cap.capture("lsb_release -d")
    codename = rel.match(/^.*:\s(.*)$/)
    if codename && codename[1]
      codename = codename[1].to_s.strip[0...12]
      case codename
      when 'Ubuntu 12.04'
        cap.load "#{root}/prepare/ubuntu/precise.rb"
        cap.find_and_execute_task("prepare:ubuntu:precise")
      end
    end
  end
end
