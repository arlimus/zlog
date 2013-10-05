require 'minitest_helper'

describe Zlog do
  it "can initialize itself to STDOUT" do
    Zlog.must_respond_to :init_stdout
  end
end
