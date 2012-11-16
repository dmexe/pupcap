require 'pupcap'
require 'capistrano'
require 'capistrano/cli'

module Pupcap::Action
  class Base

    def initialize(file, options = {})
      @file = file
      @options = options
      set_default_vars
      ENV["ROLES"] = @options[:role]
    end


    class << self
      def ensure_local_dir(dir, mode = "0755")
        run_local("mkdir -p #{dir} && chmod #{mode} #{dir}")
      end

      def run_local(cmd)
        system cmd
        fail "#{cmd} fail" if $?.to_i != 0
      end
    end

    def load_recipes(config) #:nodoc:
      # load the standard recipe definition
      cap.load "standard"
    end

    private
      def set_default_vars
        app = ENV['app'] || File.basename(File.dirname(@file))
        cap.set :application,       app
        cap.set :local_root,         File.dirname(@file)
        cap.set :provision_key,     "#{cap.local_root}/.keys/provision"
        cap.set :provision_key_pub, "#{cap.local_root}/.keys/provision.pub"
        cap.ssh_options[:keys]          = cap.provision_key
        cap.ssh_options[:forward_agent] = true
        cap.default_run_options[:pty]   = true
        cap.load @file
      end

      def cap
        unless @cap
          @cap = Capistrano::Configuration.new
          @cap.logger.level = Capistrano::Logger::DEBUG
        end
        @cap
      end
  end
end
