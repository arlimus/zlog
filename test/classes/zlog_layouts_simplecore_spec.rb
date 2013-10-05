require 'minitest_helper'

describe Zlog::Layouts::SimpleCore do
  before :each do
    @iclass = Class.new do include Zlog::Layouts::SimpleCore end
    @i = @iclass.new
  end

  it "must provide a method for creating simple log messages" do
    @i.must_respond_to :format_simple
  end
end