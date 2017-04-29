require "concurrent"

module Hanami
  module Cli
    require "hanami/cli/version"

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def call(arguments: ARGV)
        command = Hanami::Cli.command(arguments)
        if command.nil?
          render_commands_description(arguments)
          exit(1)
        end

        command.new.call
      end

      # This is only for temporary integration with
      # hanami gem
      def run(arguments: ARGV)
        command = Hanami::Cli.command(arguments)
        if command.nil?
          render_commands_description(arguments)
          return false
        end

        command.new.call
        true
      end

      def register(*names, command)
        names.each { |name| Hanami::Cli.register(name, command) }
      end

      private

      def render_commands_description(arguments)
        commands = if arguments.empty?
          commands_grouped.keys
        else
          commands_grouped[arguments.join(' ')].to_a
        end
        commands.each do |command|
          next if command.nil?
          puts "#{binary_file} #{command}"
        end
      end

      def commands_grouped
        Hanami::Cli.commands.keys.group_by do |key|
          key = key.split(' ').first
          unless key[0] == '-'
            key
          end
        end
      end

      def binary_file
        $0.split("/").last
      end
    end

    @__commands = Concurrent::Hash.new

    def self.register(name, command)
      @__commands[name] = command
    end

    def self.command(arguments)
      command = arguments.join(" ")
      @__commands.fetch(command, nil)
    end

    def self.commands
      @__commands
    end
  end
end
