require 'pupcap'

class Pupcap::Command
  class << self
    def ensure_local_dir(dir, mode = "0755")
      run_local("mkdir -p #{dir} && chmod #{mode} #{dir}")
    end

    def run_local(cmd)
      system cmd
      fail "#{cmd} fail" if $?.to_i != 0
    end

    def server_port(cap, server)
      server.port || cap.ssh_options[:port] || 22
    end

    def server_host(cap, server)
      u = server.user || cap.fetch(:user)
      u ? "#{u}@#{server.host}" : server.host
    end
  end
end
