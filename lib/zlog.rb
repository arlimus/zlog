require 'highline'
require 'logging'

# custom log level
# http://stackoverflow.com/questions/2281490/how-to-add-a-custom-log-level-to-logger-in-ruby
module Logging
  class Logger
    def ok msg; self.add 5, msg end
    def section msg; self.add 6, msg end
  end
end

module Zlog
  def self.init_stdout opts = {named: false, loglevel: nil}
    Logging.logger.root.appenders = Logging.appenders.stdout(
      level: opts[:loglevel],
      layout: (opts[:named]) ? Zlog::Layouts.named : Zlog::Layouts.simple
      )
    Logging.logger.root.level = opts[:loglevel] if not opts[:loglevel].nil?
  end

  module Layouts
    # Accessor / Factory for Simple layout
    def self.simple( *args )
      ::Zlog::Layouts::Simple.new(*args)
    end

    def self.named( *args )
      ::Zlog::Layouts::SimpleNamed.new(*args)
    end

    # Simple layout for easy readability
    class Simple < ::Logging::Layout
      # format log events
      def format( event )
        # Logging::LogEvent logger="zlog", level=2, data="warn me", time=2013-09-29 23:36:12 +0200, file="", line="", method=""
        level = LOGLEVEL2NAME[event.level]
        pattern = STDOUT_PATTERN_256COLORS[level]
        obj = format_obj(event.data)
        ( pattern % obj ) + "\n"
      end
    end

    # Simple layout for easy readability
    class SimpleNamed < ::Logging::Layout
      # format log events
      def format( event )
        # Logging::LogEvent logger="zlog", level=2, data="warn me", time=2013-09-29 23:36:12 +0200, file="", line="", method=""
        level = LOGLEVEL2NAME[event.level]
        pattern = STDOUT_PATTERN_256COLORS[level]
        obj = format_obj(event.data)
        ( STDOUT_PATTERN_256COLORS[:name] % event.logger ) + ( pattern % obj ) + "\n"
      end
    end
  end

  # standard order: ["DEBUG", "INFO", "WARN", "ERROR", "FATAL"]

  LOGLEVEL2NAME = [:debug, :info, :warning, :error, :fatal, :ok, :section]

  STDOUT_PATTERN_NOCOLORS = {
    :debug    => ".. %s",
    :info     => "-- %s",
    :warning  => "ww %s",
    :error    => "ee %s",
    :fatal    => "ff %s",
    :ok       => "++ %s",
    :section  => "\n== %s",
    :name     => "%s: "
  }

  STDOUT_PATTERN_8COLORS = {
    :debug   => "\033[37m.. %s\033[0m",
    :info    => "\033[0m-- %s\033[0m",
    :warning => "\033[1;33mww %s\033[0m",
    :error   => "\033[1;31mee %s\033[0m",
    :fatal   => "\033[1;41mff\033[0m\033[1;31 %s\033[0m",
    :ok      => "\033[1;32m++ %s\033[0m",
    :section => "\n\033[1;34m== %s\033[0m",
    :name    => "\033[37m%s: "
  }

  STDOUT_PATTERN_256COLORS = {
    :debug   => "\033[38;5;246m.. %s\033[0m",
    :info    => "\033[38;5;255m-- %s\033[0m",
    :warning => "\033[38;5;226mww %s\033[0m",
    :error   => "\033[38;5;196mee %s\033[0m",
    :fatal   => "\033[48;5;196mff\033[0m\033[38;5;196m %s\033[0m",
    :ok      => "\033[38;5;46m++ %s\033[0m",
    :section => "\n\033[38;5;33m== %s\033[0m",
    :name    => "\033[38;5;246m%s: "
  }

end