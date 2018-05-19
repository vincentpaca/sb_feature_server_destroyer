module CommandRunner
  module Util

    module Logging

      def fail(message)
        log :error, message
        raise message
      end

      def log(level, message)
        message.to_s.split("\n").each do |line|
          logger.add(LEVEL_MAP[level], line.rstrip, log_progname)
        end
      end

      private

      LEVEL_MAP = {
        debug: Logger::DEBUG,
        info: Logger::INFO,
        warn: Logger::WARN,
        error: Logger::ERROR,
        fatal: Logger::FATAL,
      }

      def action_name
        raise 'abstract method: action_name'
      end

      def command_name
        raise 'abstract method: command_name'
      end

      def log_progname
        command_name.gsub(/(^<|>$)/, '') + '#' + action_name
      end

      def logger
        @logger ||= Logger.new(STDOUT)
      end
    end
  end
end
