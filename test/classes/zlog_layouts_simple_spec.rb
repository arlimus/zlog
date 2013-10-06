require 'minitest_helper'

describe Zlog::Layouts::Simple do
  before :each do 
    @layout = Zlog::Layouts.simple
    @logger = Logging.logger["main"]
  end

  def event level, data = "yelloo"
    Logging::LogEvent.new("SpecLog", level, data, nil)
  end

  def format level, data = "yelloo"
    @layout.format(event(level, data))
  end

  def pattern_for name, data = "yelloo"
    Zlog::Layouts::SimpleCore::STDOUT_PATTERN_256COLORS[name] % data
  end

  it "can be initialized via simple method" do
    Zlog::Layouts.simple.must_be_instance_of Zlog::Layouts::Simple
  end

  it "must add debug events" do
    format(0).must_equal (pattern_for :debug) + "\n"
  end

  it "must add info events" do
    format(1).must_equal (pattern_for :info) + "\n"
  end

  it "must add warning events" do
    format(2).must_equal (pattern_for :warning) + "\n"
  end

  it "must add ok events" do
    format(3).must_equal (pattern_for :ok) + "\n"
  end

  it "must add section events" do
    format(4).must_equal (pattern_for :section) + "\n"
  end

  it "must add error events" do
    format(5).must_equal (pattern_for :error) + "\n"
  end

  it "must add fatal events" do
    format(6).must_equal (pattern_for :fatal) + "\n"
  end

  it "must support continuous loggin, 1 step" do
    (format(1, @logger.cont("conti"))).
      must_equal "\r" + (pattern_for :info, "conti")
  end

  it "must support continuous logging, 1 step + normal" do
    (format(1, @logger.cont("conti")) + format(1)).
      must_equal "\r" + (pattern_for :info, "conti") + "\n" + (pattern_for :info) + "\n"
  end

  it "must support continuous logging, 2 steps + normal" do
    c = format(1, @logger.cont("conti"))
    oc = (pattern_for :info, "conti")
    ( c + c + format(1)).
      must_equal "\r" + oc + "\r" + oc + "\n" + (pattern_for :info) + "\n"
  end
end

