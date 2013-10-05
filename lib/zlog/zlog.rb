module Zlog
  VERSION = "0.5"

  def self.init_stdout opts = {named: false, loglevel: nil}
    Logging.logger.root.appenders = Logging.appenders.stdout(
      level: opts[:loglevel],
      layout: (opts[:named]) ? Zlog::Layouts.named : Zlog::Layouts.simple
      )
    Logging.logger.root.level = opts[:loglevel] if not opts[:loglevel].nil?
  end
end
