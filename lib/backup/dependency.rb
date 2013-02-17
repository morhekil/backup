# encoding: utf-8

module Backup

  ##
  # A little self-contained gem manager for Backup.
  # Rather than specifying hard dependencies in the gemspec, forcing users
  # to install gems they do not want/need, Backup will notify them when a gem
  # has not been installed, or when the gem's version is incorrect, and provide the
  # command to install the gem. These dependencies are dynamically loaded in the Gemfile
  class Dependency

    ##
    # Returns a hash of dependencies that Backup requires
    # in order to run every available feature
    def self.all
      {
        'fog' => {
          :require => 'fog',
          :version => '~> 1.4',
          :for     => 'Amazon S3, Rackspace Cloud Files (S3, CloudFiles Storages)'
        },

        'dropbox-sdk' => {
          :require => 'dropbox_sdk',
          :version => '~> 1.5.0',
          :for     => 'Dropbox Web Service (Dropbox Storage)'
        },

        'net-sftp' => {
          :require => 'net/sftp',
          :version => ['>= 2.0.0', '<= 2.0.5'],
          :for     => 'SFTP Protocol (SFTP Storage)'
        },

        'net-scp' => {
          :require => 'net/scp',
          :version => ['>= 1.0.0', '<= 1.0.4'],
          :for     => 'SCP Protocol (SCP Storage)'
        },

        'net-ssh' => {
          :require => 'net/ssh',
          :version => ['>= 2.3.0', '<= 2.5.2'],
          :for     => 'SSH Protocol (SSH Storage)'
        },

        'mail' => {
          :require => 'mail',
          :version => '~> 2.5.0',
          :for     => 'Sending Emails (Mail Notifier)'
        },

        'twitter' => {
          :require => 'twitter',
          :version => '~> 4.0',
          :for     => 'Sending Twitter Updates (Twitter Notifier)'
        },

        'httparty' => {
          :require => 'httparty',
          :version => '~> 0.10.2',
          :for     => 'Sending Http Updates (Campfire Notifier)'
        },

        'prowler' => {
          :require => 'prowler',
          :version => '~> 1.3.1',
          :for     => 'Sending iOS push notifications (Prowl Notifier)'
        },

        'hipchat' => {
          :require => 'hipchat',
          :version => '~> 0.7.0',
          :for => 'Sending notifications to Hipchat'
        },

        'parallel' => {
          :require => 'parallel',
          :version => '~> 0.6.0',
          :for => 'Adding concurrency to Cloud-based syncers.'
        }
      }
    end

    ##
    # Attempts to load the specified gem (by name and version).
    # If the gem with the correct version cannot be found, it'll display a message
    # to the user with instructions on how to install the required gem
    def self.load(name)
      gem(name, *Array(all[name][:version]))
      require(all[name][:require])
    rescue LoadError
      raise Errors::Dependency::LoadError, <<-EOS
        Dependency missing
        Dependency required for:
        #{ all[name][:for] }
        To install the gem, issue the following command:
        > gem install #{ name } -v '#{ Array(all[name][:version]).last }'
        Please try again after installing the missing dependency.
      EOS
    end

  end
end
