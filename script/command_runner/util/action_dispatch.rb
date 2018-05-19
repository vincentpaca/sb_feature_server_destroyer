require_relative 'argument_definition'

module CommandRunner
  module Util
    module ActionDispatch

      class CommandNotFound < RuntimeError; end
      class NoCommandSpecified < RuntimeError; end
      class CommandArgumentError < RuntimeError; end
      class CommandFailed < RuntimeError; end

      def self.included(other)
        super
        other.extend(ClassMethods)
      end

      def arguments(&block)
        definition = Util::ArgumentDefinition.define(&block)
        definition.arguments.each do |arg|
          value = Util::ArgumentDefinition::Value.new(arg, @args.shift)
          raise CommandArgumentError, "Missing argument: #{arg.name}\n#{definition.argument_info}" if value.missing?
          parsed_arguments[arg.name] = value.value
        end
      end

      def parsed_arguments
        @parsed_arguments ||= {}
      end

      def run(args)
        @action_name = "<error>"
        args = args.dup
        command = args.shift
        raise NoCommandSpecified, "no command specified" if command.nil? || command == ""
        if respond_to?("do_#{command}")
          @action_name = command
          @args = args.dup
          before if respond_to?(:before)
          send("do_#{command}")
        else
          raise CommandNotFound, "invalid command: #{command}"
        end
      rescue CommandArgumentError => e
        log :error, e.message
        exit 1
      rescue NoCommandSpecified => e
        log :error, "valid commands for #{command_name}:"
        command_list
        exit 1
      rescue CommandNotFound => e
        log :error, "invalid command #{command.inspect}; valid commands for #{command_name}:"
        command_list
        exit 1
      rescue CommandFailed => e
        log :error, e.message
        exit 1
      end

      def validate_argument(name, message, &block)
        valid = block.call(parsed_arguments[name])
        raise ArgumentError, "#{name} #{message}" unless valid
      end

      def transform_argument(name, &block)
        @parsed_arguments[name] = block.call(parsed_arguments[name])
      end

      private

      attr_reader :action_name

      def commands
        self.class.instance_methods(false).map(&:to_s).select { |m| m =~ /^do_/ }.map { |m| m.gsub(/^do_/, '') }
      end

      def command_name
        self.class.name
      end

      def command_list
        commands.each do |key|
          log :info, "  - #{key}"
        end
      end

      module ClassMethods
        def run(*args)
          new.run(*args)
        end
      end

    end
  end
end
