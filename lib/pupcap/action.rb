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

    def check_tasks!
      if parsed_options[:tasks].empty?
        $stderr.puts "Please specify tasks"
        exit 1
      end
    end

    def create_cap_for(file)
      cap = Capistrano::Configuration.new
      cap.logger.level = Capistrano::Logger::DEBUG
      set_cap_vars!(cap, file)
      cap.load file
      parsed_options[:tasks].each do |task|
        cap.find_and_execute_task(task)
      end
      cap
    end

    def lib_root
      File.dirname(File.expand_path __FILE__) + "/action"
    end

    def cap_load_and_run_task(cap, task)
      cap.load "deploy"
      cap.load "#{lib_root}/#{task}/Capfile"
      cap.find_and_execute_task(task, :before => :start, :after => :finish)
    end

    private
      def parsed_options
        unless @parsed_options
          options = default_options.dup
          OptionParser.new do |opts|
            opts.banner = "Usage: #{File.basename($0)} <command> [options] <tasks>"

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
          :file    => File.expand_path("Pupcapfile"),
        }
      end

      def set_cap_vars!(cap, file)
        app = ENV['app'] || File.basename(File.dirname(file))
        cap.set :application,       app
        cap.set :local_root,        File.dirname(file)
        cap.set :pupcap_root,       File.dirname(File.expand_path __FILE__)
        cap.set :provision_key,     "#{cap.local_root}/.keys/provision"
        cap.set :provision_key_pub, "#{cap.local_root}/.keys/provision.pub"
        cap.set :deploy_to,         "/tmp/pupcap"
        cap.set :pupcap_options,    parsed_options
        cap.ssh_options[:keys]          = cap.provision_key
        cap.ssh_options[:forward_agent] = true
        cap.default_run_options[:pty]   = true

        cap.set :repository, "."
        cap.set :scm, :none
        cap.set :deploy_via, :copy

        cap.set :copy_exclude,  [".git", ".keys"]
        cap.set :repository,    "."
        cap.set :use_sudo,      false
        cap
      end
  end
end
