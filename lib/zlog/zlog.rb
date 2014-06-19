require 'json'
require 'tmpdir'

module Zlog
  VERSION = "0.9.0"
  extend self

  def init_stdout opts = {layout: :simple, loglevel: nil}
    # determine the layout from options
    layout = case opts[:layout]
      when :named
        Zlog::Layouts.named
      else
        Zlog::Layouts.simple
      end

    # configure the default stdout appender
    Logging.appenders.stdout(
      level: opts[:loglevel],
      layout: layout
    )
    # find all non-stdout appenders
    # this prevents duplicates of stdout appender
    as = Logging.logger.root.appenders.find_all{|i| i.name != "stdout" }
    # add back all appenders + our own stdout appender
    Logging.logger.root.appenders = as + ["stdout"]
  end

  def get_writable_logfile *candidates
    ret = candidates.compact.find do |f|
      # testing if something is writable, options:
      # #1: discarged, returns false if the file doesn't exist;
      #     it would require to check the folder too... :(
      # File::writable? f
      #2 trial+error
      begin
        File.open(f,"a").close
        true
      rescue
        false
      end
    end
    # in case none of the provided logfiles is writable, create one
    if ret.nil?
      # try to get a prefix as the filename from the first provided log file
      prefix = File::basename( candidates[0].to_s )
      # determine a random filename
      File::join( Dir::tmpdir, Dir::Tmpname.make_tmpname( prefix, nil ) )
    else
      # return the found good filename
      ret
    end
  end

  def json_2_event str
    begin
      j = JSON::load str
      # LogEvent = Struct.new( :logger, :level, :data, :time, :file, :line, :method )
      # from: https://github.com/TwP/logging/blob/master/lib/logging/log_event.rb
      # json example:
      # {"timestamp":"2013-10-10T18:37:38.513438+02:00","level":"DEBUG",
      #  "logger":"Log1-debug","message":"debugging info, this won't show up on console"}
      Array(j['message']).map do |msg|
        Logging::LogEvent.new( j['logger'], Logging.level_num(j['level']), msg, j['timestamp'] )
      end
    rescue
      nil
    end
  end
end
