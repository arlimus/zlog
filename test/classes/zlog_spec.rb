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
end
