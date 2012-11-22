require 'pupcap'
require 'capistrano'
require 'capistrano/cli'

module Pupcap::Capistrano
  def cap_execute_tasks(file, tasks)
    cap = cap_create_instance
    cap = yield(cap) if block_given?
    ["deploy", pupcap_capfile, file].each{|f| cap.load f }
    tasks.each do |task|
      cap.find_and_execute_task(task)
    end
    cap
  end

  def cap_create_instance
    cap = Capistrano::Configuration.new

    cap.logger.level                = Capistrano::Logger::DEBUG

    cap.set :application,             application
    cap.set :pupcap_root,             pupcap_root
    cap.set :provision_key,           provision_key
    cap.set :provision_key_pub,       provision_key_pub
    cap.set :deploy_to,               "/tmp/pupcap"
    cap.set :use_sudo,                false
    cap.set :pupcap_options,          options
    cap.ssh_options[:keys]          = cap.provision_key
    cap.ssh_options[:forward_agent] = true
    cap.default_run_options[:pty]   = true

    cap.set :repository,              "."
    cap.set :scm,                     :none
    cap.set :deploy_via,              :copy

    cap.set :copy_exclude,            [".git", ".keys"]
    cap
  end
end
