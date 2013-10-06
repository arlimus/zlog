# custom log level
# http://stackoverflow.com/questions/2281490/how-to-add-a-custom-log-level-to-logger-in-ruby
module Logging
  class Logger
    def abort msg, exit_code = 1
      fatal msg
      exit exit_code
    end

    def cont msg
      "\r" + msg
    end

  end
end

Logging.init :debug, :info, :warn, :ok, :section, :error, :fatal
