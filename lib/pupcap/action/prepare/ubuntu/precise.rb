namespace :prepare do
  namespace :ubuntu do
    task :precise do
      run("#{sudo} [ ! -f /root/.prepare_locale_ok ] && #{sudo} locale-gen && #{sudo} update-locale LANG=en_US.UTF8 && #{sudo} touch /root/.prepare_locale_ok || true")

      tmp_list = "/tmp/sources.list.#{Time.now.to_i}"
      sources_list = "/etc/apt/sources.list"

      dist_upgraded = false
      current_list = capture("md5sum #{sources_list}").split(" ")[0].to_s.strip
      if current_list != "1f722c129d80782e4fa323a6a70dee59"
        sudo("cp #{sources_list} #{sources_list}.back#{Time.now.to_i}")
        put(precise_sources_list, tmp_list)
        sudo("cp #{tmp_list} #{sources_list}")
        sudo("chown root:root #{sources_list}")
        sudo("chmod 0644 #{sources_list}")
        run("rm -f #{tmp_list}")
        sudo("apt-get -qy update > /dev/null")
        if ENV['upgrade']
          run("echo \"grub-pc hold\" | #{sudo} dpkg --set-selections")
          sudo("apt-get -qy upgrade")
          run("echo \"grub-pc install\" | #{sudo} dpkg --set-selections")
          dist_upgraded = true
        end
      end

      sudo("apt-get install -qy rsync wget rubygems vim git-core build-essential > /dev/null")
      sudo("/usr/bin/gem install -q --no-ri --no-rdoc --version '~> 2.7.1' puppet")
      sudo("reboot") if dist_upgraded
    end
  end
end

UBUNTU_PRECISE_SOURCES_LIST = <<-CODE
#############################################################
################### OFFICIAL UBUNTU REPOS ###################
#############################################################

###### Ubuntu Main Repos
deb mirror://mirrors.ubuntu.com/mirrors.txt precise main
deb-src mirror://mirrors.ubuntu.com/mirrors.txt precise main

###### Ubuntu Update Repos
deb mirror://mirrors.ubuntu.com/mirrors.txt precise-security main
deb mirror://mirrors.ubuntu.com/mirrors.txt precise-updates main
deb-src mirror://mirrors.ubuntu.com/mirrors.txt precise-security main
deb-src mirror://mirrors.ubuntu.com/mirrors.txt precise-updates main
CODE
