require 'highline'

module Zlog

  STDOUT_PATTERN_NOCOLORS = {
    :info     => "-- %s",
    :error    => "ee %s",
    :warning  => "ww %s",
    :debug    => ".. %s",
    :ok       => "++ %s",
    :section  => "\n== %s"
  }

  STDOUT_PATTERN_8COLORS = {
    :info    => "\033[0m-- %s\033[0m",
    :error   => "\033[1;31mee %s\033[0m",
    :warning => "\033[1;33mww %s\033[0m",
    :debug   => "\033[1;30m.. %s\033[0m",
    :ok      => "\033[1;32m++ %s\033[0m",
    :section => "\n\033[1;34m== %s\033[0m"
  }

  STDOUT_PATTERN_256COLORS = {
    :info    => "\033[38;5;255m-- %s\033[0m",
    :error   => "\033[38;5;196mee %s\033[0m",
    :warning => "\033[38;5;226mww %s\033[0m",
    :debug   => "\033[38;5;241m.. %s\033[0m",
    :ok      => "\033[38;5;046m++ %s\033[0m",
    :section => "\n\033[38;5;033m== %s\033[0m"
  }

  NOTHING   = 0
  ERROR     = 20
  OK        = 20
  WARNING   = 40
  INFO      = 50
  VERBOSE   = 60
  DEBUG     = 100

  @@level   = WARNING
  def self.level=( v )
    @@level = v
  end

  def self.info(msg, continuous = false)
    write @@pattern[:info] % msg, continuous if @@level >= INFO
  end

  def self.error(msg)
    write @@pattern[:error] % msg if @@level >= ERROR
  end

  def self.warning(msg)
    write @@pattern[:warning] % msg if @@level >= WARNING
  end

  def self.debug(msg, continuous = false)
    write @@pattern[:debug] % msg, continuous if @@level >= DEBUG
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
  UNPRINTABLE_CHARACTERS = /(\e\[[^m]*m|[^[:print:]])/

  # format contents so they fit into a certain width
  # supports escaped characters
  def self.format_line( width, contents )
    s = 0
    l = width - 1
    m = UNPRINTABLE_CHARACTERS.match contents[s..l]
    until m.nil?
      s += m[0].length + m.begin(0)
      l += m[0].length
      m = UNPRINTABLE_CHARACTERS.match contents[s..l]
    end
    "%-#{l}s" % contents[0..l]
  end

  # format a message correctly in a continuous environment
  # ie. lines that may have been written normally ("some\n")
  #     and lines that are continuous ("at 92%\r")
  # it returns a string that correctly behaves in the context
  # of the current terminal
  def self.format_continuous(msg, continuous = false)
    w = HighLine::SystemExtensions.terminal_size[0]

    if not continuous
      m = ( @@dirty_line ) ? "%#{w-1}s\r%s\n" % ["",msg] : msg+"\n"
      @@dirty_line = false
      m
    else
      @@dirty_line = true
      "%s\r" % format_line( w - 1 , msg )
    end
  end

  def self.write(msg, continuous = false)
    print format_continuous(msg, continuous)
  end


  TERMINALS_WITH_256_COLORS = ["gnome-terminal"]

  def self.detect_terminal_colors()
    col = `tput colors`.to_i
    colorterm = ENV["COLORTERM"]
    return 256 if TERMINALS_WITH_256_COLORS.include?(colorterm)
    return col
  end

  def self.get_pattern_for_colors(colors)
    return STDOUT_PATTERN_256COLORS if colors >= 256
    return STDOUT_PATTERN_8COLORS if colors >= 8
    STDOUT_PATTERN_NOCOLORS
  end

  def self.get_stdout_pattern(colors = nil)
    cc = colors || self.detect_terminal_colors
    self.get_pattern_for_colors cc
  end

  @@pattern = get_stdout_pattern


end

