require_relative 'kill'
require_relative 'util/action_dispatch'
require_relative 'util/logging'

module CommandRunner
  class Command

    include CommandRunner::Util::Logging
    include CommandRunner::Util::ActionDispatch

    def command_name
      "[top level]"
    end

    def do_kill
      CommandRunner::Kill.new.run(@args)
    end

  end
end
