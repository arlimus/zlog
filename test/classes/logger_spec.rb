require 'minitest_helper'

describe Logging::Logger do
  before :each do
    @log = Logging.logger["main"]
  end

  it "provides a method for logging 'ok' messages" do
    @log.must_respond_to :ok
  end

  it "provides a method for logging 'section's" do
    @log.must_respond_to :section
  end

  it "provides a method for logging 'abort's" do
    @log.must_respond_to :abort
  end

  it "provides a method for logging 'cont'inuous messages" do
    @log.must_respond_to :cont
  end
end
