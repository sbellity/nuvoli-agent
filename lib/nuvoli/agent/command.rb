#!/usr/bin/env ruby -wKU

require "optparse"
require "logger"
require "fileutils"

module Nuvoli
  module Agent
    class Command
      def self.user
        @user ||= ENV["USER"] || ENV["USERNAME"] || "root"
      end

      def self.program_name
        @program_name ||= File.basename($PROGRAM_NAME)
      end

      def self.program_path
        @program_path ||= File.expand_path($PROGRAM_NAME)
      end

      def self.usage
        @usage
      end

      def self.parse_options(argv)
        options = { }

        op = OptionParser.new do |opts|
          opts.banner = "Usage:"

          opts.separator "--------------------------------------------------------------------------"
          opts.separator "  Check for modifications with the Nuvoli server:"
          opts.separator "    #{program_name} [OPTIONS]"
          opts.separator " "
          opts.separator "Note: This agent is meant to be installed and"
          opts.separator "invoked through cron or any other scheduler."
          opts.separator " "
          opts.separator "Specific Options:"
          opts.separator "--------------------------------------------------------------------------"
          opts.on( "-s", "--server SERVER", String,
                   "The URL for the server to report to." ) do |url|
            options[:server] = url
          end

          opts.on( "-l", "--level LEVEL",
                   Logger::SEV_LABEL.map { |l| l.downcase },
                   "The level of logging to report. Use -ldebug for most detail." ) do |level|
            options[:level] = level
          end

          opts.separator " "
          opts.separator "Common Options:"
          opts.separator "--------------------------------------------------------------------------"
          opts.on( "-h", "--help",
                   "Show this message." ) do
            puts opts
            exit
          end
          opts.on( "-v", "--[no-]verbose",
                   "Turn on logging to STDOUT" ) do |bool|
            options[:verbose] = bool
          end

          opts.on( "-V", "--version",
                   "Display the current version") do |version|
            puts Nuvoli::Agent::VERSION
            exit
          end

        end

        begin
          op.parse!(argv)
          @usage = op.to_s
        rescue
          puts op
          exit
        end
        options
      end
      private_class_method :parse_options

      def self.dispatch(argv)
        # capture help command
        argv.push("--help") if argv.first == 'help'
        options = parse_options(argv)
        command = Nuvoli::Agent::Run.new(options, argv).run
      end

      def initialize(options, args)
        @server  = options[:server]  || "192.168.1.26:3000"   # "https://api.nuvo.li/"
        @verbose = options[:verbose] || false
        @level   = options[:level]   || "info"
        @args    = args
      end

      attr_reader :server

      def verbose?
        @verbose
      end

      def log
        return @log if defined? @log
        @log = if verbose?
                 log                 = Logger.new($stdout)
                 log.datetime_format = "%Y-%m-%d %H:%M:%S "
                 log.level           = level
                 log
               else
                 nil
               end
      end

      def level
        Logger.const_get(@level.upcase) rescue Logger::INFO
      end

      def user
        @user ||= Command.user
      end

      def program_name
        @program_name ||= Command.program_name
      end

      def program_path
        @program_path ||= Command.program_path
      end

      def usage
        @usage ||= Command.usage
      end

    end
  end
end

require 'nuvoli/agent/command/run'