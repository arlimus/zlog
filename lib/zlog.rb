require 'logging'

# custom log level
# http://stackoverflow.com/questions/2281490/how-to-add-a-custom-log-level-to-logger-in-ruby
module Logging
  class Logger
    def ok msg;       add 5, msg    end
    def section msg;  add 6, msg    end
    def abort msg, exit_code = 1
      fatal msg
      exit exit_code
    end

    def cont msg
      "\r" + msg
    end

  end
end

module Zlog
  VERSION = "0.4"

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
        # handle continuous logging lines
        if (event.data.start_with? "\r")
          # this is a continuous message
          # there are 2 cases which need to be covered:
          # A: the last line was a regular log line,
          #    the cursor caret is at position 0
          # B: the last line was a continuous log line,
          #    the cursor caret is at the end of the last message
          # For case B we want to go back to the beginning of the line (via "\r")
          # then insert the message and the amount of white space needed to
          # overwrite any visible characters from the last message
          obj = format_obj(event.data[1..-1])
          msg = pattern % obj
          # determine the length of the last message
          len = (@has_last_line_newline == false) ? @last.length : 0
          # calculate the amount of white spaces we need to overwrite
          # remnants of the last log message
          rem_len = len - msg.length
          rem_len = 0 if rem_len < 0
          # create the resulting string
          ret = "\r" + msg + (' '*rem_len)
          # make sure to update state parameters
          @last = msg
          @has_last_line_newline = false
          # return the result
          ret
        else
          # format the object
          obj = format_obj(event.data)
          # check if we need to add a newline at the start of the line
          # this only happens when the last message was a continuous message
          # and thus didn't set a \n at the end
          sl =
            if (@has_last_line_newline == false)
              @has_last_line_newline = true
              "\n"
            else "" end
          # return the resulting pattern
          sl + (pattern % obj ) + "\n"
        end
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
