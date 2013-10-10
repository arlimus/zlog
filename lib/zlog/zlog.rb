module Zlog
  VERSION = "0.7"
  extend self

  def init_stdout opts = {named: false, loglevel: nil}
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
end
