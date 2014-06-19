require 'zlog'

class Zlog::CLI
  def initialize opts = {}
    @layout = case opts[:layout]
      when :named
        Zlog::Layouts.named
      else
        Zlog::Layouts.simple
      end
  end

  def convert_line line, opts = {}
    e = Zlog::json_2_event(line)
    if not e.nil?
      @layout.format(e)
    end
  end

  def convert_stdin opts = {}, &handler
    # collect all results to an array which will be returned
    # in case that no block is given for processing
    res = []
    handler = lambda{|line| res.push line} if not block_given?

    # process each line
    while line = STDIN.gets do
      handler.( convert_line line, opts )
    end

    # return the result, in case we have any
    res
  end
end

