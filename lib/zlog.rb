
module Zlog

  STDOUT_PATTERN_NOCOLOR = {
    :info     => "-- %s",
    :error    => "ee %s",
    :warning  => "ww %s",
    :debug    => ".. %s",
    :ok       => "++ %s"
  }

  STDOUT_PATTERN_8COLORS = {
    :info    => "\033[0m-- %s\033[0m",
    :error   => "\033[1;31mee %s\033[0m",
    :warning => "\033[1;33mww %s\033[0m",
    :debug   => "\033[1;30m.. %s\033[0m",
    :ok      => "\033[1;32m++ %s\033[0m",
  }

  STDOUT_PATTERN_256COLORS = {
    :info    => "\033[38;5;255m-- %s\033[0m",
    :error   => "\033[38;5;196mee %s\033[0m",
    :warning => "\033[38;5;226mww %s\033[0m",
    :debug   => "\033[38;5;241m.. %s\033[0m",
    :ok      => "\033[38;5;046m++ %s\033[0m",
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

  def self.log(msg)
    self.info(msg)
  end

  def self.info(msg)
    puts @@pattern[:info] % msg if @@level >= INFO
  end

  def self.error(msg)
    puts @@pattern[:error] % msg if @@level >= ERROR
  end

  def self.warning(msg)
    puts @@pattern[:warning] % msg if @@level >= WARNING
  end

  def self.debug(msg)
    puts @@pattern[:debug] % msg if @@level >= DEBUG
  end

  def self.ok(msg)
    puts @@pattern[:ok] % msg if @@level >= OK
  end

  def self.initialize_stdout_colors()
    @@pattern = self.get_stdout_pattern
  end


  private


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

  def self.get_stdout_pattern()
    self.get_pattern_for_colors self.detect_terminal_colors
  end

  @@pattern = get_stdout_pattern


end

