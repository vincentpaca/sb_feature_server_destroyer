require 'shellwords'

module CommandRunner
  module Util
    module ShellSupport

      def sh(cmd)
        log :debug, "Running: #{cmd}"
        system(cmd) || raise("failed")
      end

    end
  end
end
