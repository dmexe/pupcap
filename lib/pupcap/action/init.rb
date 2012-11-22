require 'pupcap/action'
require 'pupcap/command'
require 'fileutils'
require 'erb'

class Pupcap::Action::Init < Pupcap::Action::Base
  def initialize
  end

  def start
    create_directories
    create_vagrantfile
    create_capfile
    create_pp
    librarian_puppet
    create_gitignore
    create_prepare_script
  end

  def create_prepare_script
    out = "#{work_dir}/prepare.sh.erb"
    if !File.exists?(out) || force?
      FileUtils.copy("#{lib_root}/init/prepare.sh.erb", "#{work_dir}/prepare.sh.erb")
      puts "create prepare.sh.erb"
    else
      puts "skip prepare.sh.erb"
    end
  end

  def create_vagrantfile
    out = "#{work_dir}/Vagrantfile"
    if !File.exists?(out) || force?
      erb = ERB.new(File.read("#{lib_root}/init/Vagrantfile.erb"))
      rs = erb.result(binding)
      File.open(out, "w+"){ |io| io.write rs }
      puts "create Vagrantfile"
    else
      puts "skip #{out}"
    end
  end

  def create_capfile
    out = "#{work_dir}/Pupcapfile"
    if !File.exists?(out) || force?
      erb = ERB.new(File.read("#{lib_root}/init/Pupcapfile.erb"))
      rs = erb.result(binding)
      File.open(out, "w+"){ |io| io.write rs }
      puts "create Capfile"
    else
      puts "skip #{out}"
    end
  end

  def create_pp
    out = "#{work_dir}/manifests/site.pp"
    if !File.exists?(out) || force?
      erb = ERB.new(File.read("#{lib_root}/init/site.pp.erb"))
      rs = erb.result(binding)
      File.open(out, "w+"){ |io| io.write rs }
      puts "create manifests/site.pp"
    else
      puts "skip #{out}"
    end
  end

  def create_directories
    FileUtils.mkdir_p("#{work_dir}/modules")
    FileUtils.mkdir_p("#{work_dir}/site-modules")
    FileUtils.mkdir_p("#{work_dir}/manifests")
    system("touch #{work_dir}/manifests/.gitkeep")
    system("touch #{work_dir}/site-modules/.gitkeep")
  end

  def librarian_puppet
    Pupcap::Command.run_local("(cd #{work_dir} && librarian-puppet init)")
  end

  def create_gitignore
    if !File.exists?("#{work_dir}.gitignore")
      FileUtils.copy("#{lib_root}/init/gitignore", "#{work_dir}/.gitignore")
      puts "create .gitignore"
    else
      puts "skip .gitignore"
    end
  end

  def work_dir
    parsed_options[:directory]
  end

  def ip
    parsed_options[:ip]
  end

  def force?
    parsed_options[:force]
  end

  def parsed_options
    unless @parsed_options
      options = default_options.dup
      OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename($0)} init [options] <directory>"
        opts.on("-h", "--help", "Displays this help info") do
          puts opts
          exit 0
        end
        opts.on("-i", "--ip IP", "Address for vagrant host, default 192.168.44.10") do |ip|
          options[:ip] = ip
        end
        opts.on("-f", "--force", "Always create a Vagrantfile and Puppetfile") do
          options[:force] = true
        end
      end.parse!
      options[:directory] = ARGV[0]
      unless options[:directory]
        $stderr.puts "You must specify a directory"
        exit 1
      end
      @parsed_options = options
    end
    @parsed_options
  end

  def default_options
    {
      :ip => "192.168.44.10",
      :force => false
    }
  end
end
