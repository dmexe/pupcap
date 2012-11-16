require 'pupcap'
require 'capistrano'
require 'capistrano/cli'

module Pupcap::Action
  class Base

    def parsed_options
      {}
    end

    def check_puppetfile!
      unless File.exists?(parsed_options[:file])
        $stderr.puts "File #{parsed_options[:file]} does not exists"
        exit 1
      end
    end

    def check_role!
      unless parsed_options[:role]
        $stderr.puts "Please specify role"
        exit 1
      end
    end

    def create_cap_for(file)
      cap = Capistrano::Configuration.new
      cap.logger.level = Capistrano::Logger::DEBUG
      set_cap_vars!(cap, file)
      cap.load file
      cap
    end

    def lib_root
      File.dirname(File.expand_path __FILE__) + "/action"
    end

    def cap_load_and_run_task(cap, task)
      cap.set :pupcap_options, parsed_options
      cap.load "#{lib_root}/#{task}/Capfile"
      cap.trigger(:load)
      cap.find_and_execute_task(task, :before => :start, :after => :finish)
      cap.trigger(:exit)
    end

    private

      def set_cap_vars!(cap, file)
        app = ENV['app'] || File.basename(File.dirname(file))
        cap.set :application,       app
        cap.set :local_root,         File.dirname(file)
        cap.set :provision_key,     "#{cap.local_root}/.keys/provision"
        cap.set :provision_key_pub, "#{cap.local_root}/.keys/provision.pub"
        cap.ssh_options[:keys]          = cap.provision_key
        cap.ssh_options[:forward_agent] = true
        cap.default_run_options[:pty]   = true
        cap
      end

  end
end
