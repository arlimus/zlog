module Zlog
  VERSION = "0.7"

  def self.init_stdout opts = {named: false, loglevel: nil}
    # configure the default stdout appender
    Logging.appenders.stdout(
      level: opts[:loglevel],
      layout: (opts[:named]) ? Zlog::Layouts.named : Zlog::Layouts.simple
    )
    # find all non-stdout appenders
    # this prevents duplicates of stdout appender
    as = Logging.logger.root.appenders.find_all{|i| i.name != "stdout" }
    # add back all appenders + our own stdout appender
    Logging.logger.root.appenders = as + ["stdout"]
  end
end
