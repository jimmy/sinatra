require File.dirname(__FILE__) + '/helper'

context "Halting" do

  specify "handles a proc" do
    get '/' do
      throw :halt, lambda { 'body' }
    end

    get_it '/'
    should.be.ok
    body.should == 'body'
  end

end
