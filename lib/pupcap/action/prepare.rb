require 'thor'
require 'thor/actions'
require 'thor/group'

require 'pupcap/action'

class Pupcap::Action::Prepare < Thor::Group

  include Thor::Actions

  desc "Prepare host"
  class_option :pupcapfile, :type => :string, :default => -> { File.expand_path("Capfile") }, :aliases => "-f"

  def create_pupcap_directories
    directory("init", dir)
  end

  def initialize_librarian_puppet
    inside(dir) do
      run("librarian-puppet init")
    end
  end

  def inject_into_giignore
    inside(dir) do
      append_to_file(".gitignore", ".vagrant\n", :verbose => false)
      append_to_file(".gitignore", "*.swp\n", :verbose => false)
    end
  end

  def self.source_root
    File.dirname(__FILE__)
  end

  private
    def ip
      options["ip"]
    end

end
