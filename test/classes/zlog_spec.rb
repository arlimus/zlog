require 'minitest_helper'
require 'tmpdir'

describe Zlog do
  it "can initialize itself to STDOUT" do
    Zlog.must_respond_to :init_stdout
  end

  describe 'get_writable_logfile' do

    before :each do
      @random_writable = File::join( Dir::tmpdir, Dir::Tmpname.make_tmpname( "", nil ) )
      @random_non_writable = File::join( '/dev', Dir::Tmpname.make_tmpname("",nil) )
    end

    it "must give a working writable log file" do
      Zlog.get_writable_logfile( @random_writable ).
        must_equal @random_writable
    end

    it "must give return the first actually writable log file" do
      Zlog.get_writable_logfile( @random_non_writable, @random_writable ).
        must_equal @random_writable
    end

    it "must provide a random file if none of the provided candidates are writable" do
      f = Zlog.get_writable_logfile( @random_non_writable, @random_writable )
      f.must_be_instance_of String
      f.wont_be_empty
    end

  end

  describe 'json_2_event' do
    before :each do
      template = '{"timestamp":"2013-10-10T18:37:38.513438+02:00","level":"%level","logger":"Mocker%level","message":"mock message %level"}'
      names = ["DEBUG","INFO","WARN","OK","SECTION","ERROR","FATAL"]
      @examples = (0..(names.length-1)).
        map do |level|
          {
            raw: template.gsub( '%level', names[level] ),
            level: level,
            name: names[level]
          }
        end
    end

    it "must give nil on incorrect json" do
      Zlog.json_2_event( "" ).must_be_nil
    end

    it "must convert a logging json to a logevent" do
      @examples.each do |e|
        r = Zlog.json_2_event e[:raw]
        r.must_be_instance_of Logging::LogEvent
        r.level.must_equal e[:level]
        r.logger.must_equal "Mocker#{e[:name]}"
        r.data.must_equal "mock message #{e[:name]}"
      end
    end

  end
end
