
module Zlog
  # @@pattern_info    = "-- %s"
  # @@pattern_error   = "ee %s"
  # @@pattern_warning = "ww %s"
  # @@pattern_debug   = "dd %s"
  # @@pattern_ok      = "++ %s"

  @@pattern_info    = "\033[37m-- %s\033[0m"
  @@pattern_error   = "\033[31mee %s\033[0m"
  @@pattern_warning = "\033[33mww %s\033[0m"
  @@pattern_debug   = "\033[1;30mdd %s\033[0m"
  @@pattern_ok      = "\033[32m++ %s\033[0m"

  # @@pattern_info    = "-- %s"
  # @@pattern_error   = "ee %s"
  # @@pattern_warning = "ww %s"
  # @@pattern_debug   = "dd %s"
  # @@pattern_ok      = "\033[38;5;046m++ %s\033[0m"


  NOTHING         = 0
  ERROR           = 20
  OK              = 20
  WARNING         = 40
  INFO            = 50
  VERBOSE         = 60
  DEBUG           = 100

  @@level           = WARNING
  
  def self.level=( v )
    @@level = v
  end

  def self.log(msg)
    self.info(msg)
  end

  def self.info(msg)
    puts @@pattern_info % msg if @@level >= INFO
  end

  def self.error(msg)
    puts @@pattern_error % msg if @@level >= ERROR
  end

  def self.warning(msg)
    puts @@pattern_warning % msg if @@level >= WARNING
  end

  def self.debug(msg)
    puts @@pattern_debug % msg if @@level >= DEBUG
  end

  def self.ok(msg)
    puts @@pattern_ok % msg if @@level >= OK
  end
end

