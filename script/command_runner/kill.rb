require_relative 'base'
require 'sshkit'
require 'sshkit/dsl'
include SSHKit::DSL
require 'aws-sdk-ec2'

module CommandRunner
  class Kill < Base

    def command_name
      "<kill>"
    end

    def do_staging_servers
      log :info, 'Looking for feature servers...'
      get_feature_ip_addresses
      log :info, "Found #{ip_addresses.count} feature servers..."

      log :info, 'Setting up SSH...'
      configure_ssh

      log :info, 'Checking for feature branch age on all servers...'
      detect_and_terminate_old_feature_servers

      log :info, 'Done!'
    end

    private

    attr_reader :ec2_client, :ip_addresses

    def detect_and_terminate_old_feature_servers
      on ip_addresses do |host|
        within 'app' do
          date = capture :git, 'log -1 --format=%cd'
          # We're selecting feature branches with commits older than 3 days
          if (Date.today - Date.parse(date)).to_i > 3
            as 'root' do
              puts "Shutting down #{host}..."
              execute :shutdown, '-h now'
            end
          end
        end
      end
    end

    def configure_ssh
      SSHKit::Backend::Netssh.configure do |ssh|
        ssh.ssh_options = {
          user: instance_user
        }
      end
    end

    def get_feature_ip_addresses
      @ip_addresses ||= list_feature_instances.map { |i| i.public_ip_address }
    end

    def list_feature_instances
      ec2_client.instances(filters: [{ name: 'tag:ENV', values: [ec2_tag] }])
    end

    def ec2_tag
      'feature'
    end

    def aws_region
      'ap-southeast-1'
    end

    def instance_user
      'ec2-user'
    end

    def ec2_client
      @ec2_client ||= Aws::EC2::Resource.new(region: aws_region)
    end

  end
end
