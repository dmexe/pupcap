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
    create_puppetfile
    create_pp
  end

  def create_vagrantfile
    out = "#{work_dir}/Vagrantfile"
    if !File.exists?(out) || force?
      erb = ERB.new(File.read("#{lib_root}/init/Vagrantfile.erb"))
      rs = erb.result(binding)
      File.open(out, "w+"){ |io| io.write rs }
    else
      puts "Skip file #{out}"
    end
  end

  def create_puppetfile
    out = "#{work_dir}/Puppetfile"
    if !File.exists?(out) || force?
      erb = ERB.new(File.read("#{lib_root}/init/Puppetfile.erb"))
      rs = erb.result(binding)
      File.open(out, "w+"){ |io| io.write rs }
    else
      puts "Skip file #{out}"
    end
  end

  def create_pp
    out = "#{work_dir}/puppet/manifests/default.pp"
    if !File.exists?(out) || force?
      erb = ERB.new(File.read("#{lib_root}/init/default.pp.erb"))
      rs = erb.result(binding)
      File.open(out, "w+"){ |io| io.write rs }
    else
      puts "Skip file #{out}"
    end
  end

  def create_directories
    FileUtils.mkdir_p("#{work_dir}/puppet/modules")
    FileUtils.mkdir_p("#{work_dir}/puppet/manifests")
    system("touch #{work_dir}/puppet/modules/.gitkeep")
    system("touch #{work_dir}/puppet/manifests/.gitkeep")
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
