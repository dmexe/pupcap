# Pupcap


Pupcap gem was created to use puppet without puppet master server. Pupcap uses [capistrano](https://github.com/capistrano/capistrano) to manage remote server, [hiera](http://projects.puppetlabs.com/projects/hiera) to make puppet configuration easier, has ability to use different roles (app, db) and multistaging (production, stage). It also use [librarian-puppet](https://github.com/rodjek/librarian-puppet) to manage puppet modules.

## Installation

    $ gem install pupcap

### Init

To init pupcap project and create file structure:

    $ mkdir demo && cd demo && pupcap init .

After executing of this command you will have such file structure:

    .keys/                   # ssh keys to remote hosts
    hieradata/               # hiera data
      common.yaml            # attributes shared for all environments
      development.yaml       # attributes for development
    manifests/               # puppet manifests
      site.pp                # configuration example
    modules/                 # librarian-puppet modules
    site-modules/            # puppet modules
    Capfile                  # deploy config
    Puppetfile               # list of librarian-puppet modules
    Vagrantfile              # vagrant config to test the pupcap project configuration
    hiera.yaml               # hiera config
    prepare.sh.erb           # script to prepare remote server




### Prepare

This command installs ruby, rubygems, puppet and librarian-puppet on remote server. It's not necessary if such software is already installed on your server.

    $ puppcap <captask> prepare

It will:

* generate ssh keys pair and save them into `.keys`
* add public key from `.keys` to the host's `.authorized_keys` if there is no pubkey yet
* execute prepare.sh.erb



### Apply

Executes installation of the Puppet confiration on remote server.

    #Capfile

    task :production do
      set :environment, 'production'
      role :app, 'app.example.com'
      role :db,  'db.example.com'
    end


    $ pupcap production apply

Configurations from manifests/{app,db}.pp will be deployed on app.example.com and db.example.com with production environment.



## Vagrant

After pupcap initialization you will have `Vagrantfile` and `Capfile` already configured to deploy Puppet configuration to Vagrant VM.

    $ pupcap vagrant prepare
    $ pupcap vagrant apply

