require_relative 'base'

module CommandRunner
  class Kill < Base

    def command_name
      "<kill>"
    end

    def do_staging_servers
      log :info, 'Killing servers...'
    end

  end
end
