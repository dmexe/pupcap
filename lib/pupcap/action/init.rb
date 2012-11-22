require 'thor'
require 'thor/actions'
require 'thor/group'

require 'pupcap/action'

class Pupcap::Action::Init < Thor::Group

  include Thor::Actions

  argument :dir, :type => :string, :desc => "The directory"
  desc "Initializes in the DIR"
  class_option :ip, :type => :string, :default => "192.168.44.10"

  def create_pupcap_directories
    directory("action/init", dir)
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

  private
    def ip
      options["ip"]
    end

end
