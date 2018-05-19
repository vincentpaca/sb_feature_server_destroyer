require 'optparse'
require_relative 'util/logging'
require_relative 'util/action_dispatch'
require_relative 'util/shell_support'

module CommandRunner
  class Base

    include Util::Logging
    include Util::ActionDispatch
    include Util::ShellSupport

    def arg_error(parser, message)
      parser.warn(message)
      log :error, parser.help
      exit(1)
    end

  end
end
