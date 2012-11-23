require 'thor'
require 'thor/actions'
require 'pupcap'
require 'pupcap/capistrano'

class Pupcap::CLI < Thor
  include Thor::Actions
  include Pupcap::Capistrano

  desc "init DIR", "Initialize pupcap into DIR"
  method_option :ip, :type => :string, :default => "192.168.44.11", :alias => "-i",
                :desc => "Generate Vagrantfile with that ip address"
  def init(dir)
    directory("action/init", dir)
    inside(dir) do
      append_to_file(".gitignore", ".vagrant\n", :verbose => false)
      append_to_file(".gitignore", "*.swp\n", :verbose => false)
      run("librarian-puppet init")
    end
  end

  desc "[TASKS] prepare", "Prepare target host"
  method_option :file, :type => :string, :default => File.expand_path("Capfile"),
                :desc => "Capfile"
  method_option :script, :type => :string, :default => File.expand_path("prepare.sh.erb"),
                :desc => "The shell script who be execute in target host"
  def prepare(*tasks)
    error "#{options[:file]} does not exists"   unless File.exists?(options[:file])
    error "#{options[:script]} does not exists" unless File.exists?(options[:script])

    unless File.exists?(provision_key)
      inside pupcap_root do
        empty_directory(".keys")
        chmod(".keys", 0700)
        run("ssh-keygen -q -b 1024 -t rsa -C \"#{application} provision key\" -f #{provision_key}")
        chmod(provision_key, 0600)
        chmod(provision_key_pub, 0600)
      end
    end
    cap_execute_tasks(capfile("prepare"), tasks << "prepare")
  end

  desc "[TASKS] apply", "Puppet apply"
  method_option :file, :type => :string, :default => File.expand_path("Capfile"),
                :desc => "Capfile"
  def apply(*tasks)
    cap_execute_tasks(capfile("apply"), tasks << "apply")
  end

  desc "[TASKS] noop", "Puppet noop"
  method_option :file, :type => :string, :default => File.expand_path("Capfile"),
                :desc => "Capfile"
  def noop(*tasks)
    ENV['NOOP'] = '1'
    apply(*tasks)
  end

  desc "[TASKS] ssh", "Open remote console"
  method_option :file, :type => :string, :default => File.expand_path("Capfile"),
                :desc => "Capfile"
  def ssh(*tasks)
    cap_execute_tasks(capfile("ssh"), tasks << "ssh")
  end

  def self.source_root
    File.dirname(__FILE__)
  end

  def self.revert_argv_and_start(argv = ARGV)
    need_to_revert = %w{ noop apply init prepare ssh }
    if need_to_revert.include?(argv.last) && argv.size > 1
      last = argv.pop
      argv = [last] + argv
    end
    begin
      start(argv)
    rescue Exception => e
      if ENV['THOR_DEBUG'] == '1'
        raise e
      else
        $stderr.puts e.message
        exit 1
      end
    end
  end

  private
    def capfile(name)
      self.class.source_root + "/action/#{name}/Capfile"
    end

    def pupcap_capfile
      options[:file]
    end

    def pupcap_root
      Pathname.new(File.dirname(pupcap_capfile))
    end

    def provision_key
      pupcap_root.join(".keys/provision").to_s
    end

    def application
      pupcap_root.basename.to_s
    end

    def provision_key_pub
      "#{provision_key}.pub"
    end
end
