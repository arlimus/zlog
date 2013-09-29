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

  NOTHING   = 0
  ERROR     = 20
  OK        = 20
  WARNING   = 40
  INFO      = 50
  VERBOSE   = 60
  DEBUG     = 100

  @@level   = INFO
  def self.level=( v )
    @@level = v
  end

  def self.error(msg)
    write @@pattern[:error] % msg, stream: $stderr if @@level >= ERROR
  end

  def self.warning(msg)
    write @@pattern[:warning] % msg, stream: $stderr if @@level >= WARNING
  end

  def self.info(msg, continuous = false)
    write @@pattern[:info] % msg, continuous: continuous if @@level >= INFO
  end

  def self.debug(msg, continuous = false)
    write @@pattern[:debug] % msg, continuous: continuous if @@level >= DEBUG
  end

  def self.ok(msg)
    write @@pattern[:ok] % msg if @@level >= OK
  end

  def self.abort(msg)
    self.error msg
    exit
  end

  class << self
    alias_method :log, :info
    alias_method :warn, :warning
  end

  def self.section(msg)
    puts @@pattern[:section] % msg if @@level >= OK
  end

  def self.initialize_stdout_colors(colors = nil)
    @@pattern = self.get_stdout_pattern(colors)
  end


  private

  # true if the last line is a dirty-line i.e.
  # if the the carriege point is at the beginning but
  # the line still contains characters
  # this typically happens in continuous mode
  @@dirty_line = false
  ANSI_ESCAPE_CHARACTERS = /\e\[[^m]*m/

  # format contents so they fit into a certain width
  # supports escaped characters
  def self.format_line( width, contents )
    str = contents # contents.gsub(UNPRINTABLE_CHARACTERS,"")
    s = 0
    l = width - 1
    m = ANSI_ESCAPE_CHARACTERS.match str[s..-1]
    until m.nil? or (s+m.begin(0)) > l
      s += m[0].length + m.begin(0)
      l += m[0].length
      m = ANSI_ESCAPE_CHARACTERS.match str[s..-1]
    end
    reset_style = ( s > 0 ) ? "\e[0m" : ""
    "%-#{l}s%s" % [str[0..l], reset_style]
  end

  # format a message correctly in a continuous environment
  # ie. lines that may have been written normally ("some\n")
  #     and lines that are continuous ("at 92%\r")
  # it returns a string that correctly behaves in the context
  # of the current terminal
  def self.format_continuous(msg, continuous = false)
    w = HighLine::SystemExtensions.terminal_size[0]

    if not continuous
      m = ( @@dirty_line ) ? "%#{w}s\r%s\n" % ["",msg] : msg+"\n"
      @@dirty_line = false
      m
    else
      @@dirty_line = true
      format_line( w , msg ) + "\r"
    end
  end

  def self.write(msg, opts = {} )
    o = { continuous: false, stream: $stdout }.merge(opts)
    o[:stream].print format_continuous(msg, o[:continuous])
  end

  def self.get_pattern_for_colors(colors)
    return STDOUT_PATTERN_256COLORS if colors >= 256
    return STDOUT_PATTERN_8COLORS if colors >= 8
    STDOUT_PATTERN_NOCOLORS
  end

  def self.get_stdout_pattern(colors = nil)
    cc = colors || 256
    self.get_pattern_for_colors cc
  end

  @@pattern = get_stdout_pattern


end

