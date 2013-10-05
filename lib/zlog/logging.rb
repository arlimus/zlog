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
