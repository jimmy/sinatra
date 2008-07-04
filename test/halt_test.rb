require File.dirname(__FILE__) + '/helper'

context "Halting" do

  setup do
    Sinatra.application = nil
  end

  specify "should halt immediately" do
    get '/' do
      throw :halt
      raise
    end

    get_it '/'
    should.be.ok
  end

  specify "should halt immediately from a filter" do
    before do
      throw :halt
    end

    get '/' do
      raise
    end

    get_it '/'
    should.be.ok
  end

  specify "handle helper with no args" do
    helpers do
      def name
        'Sinatra'
      end
    end

    get '/' do
      throw :halt, :name
    end

    get_it '/'
    body.should == 'Sinatra'
  end

  specify "handle helper with args" do
    helpers do
      def twice(s)
        "#{s} #{s}"
      end
    end

    get '/' do
      throw :halt, [:twice, 'hello']
    end

    get_it '/'
    body.should == 'hello hello'
  end

  specify "handle string" do
    get '/' do
      throw :halt, 'body'
    end

    get_it '/'
    body.should == 'body'
  end

  specify "handle [status, string]" do
    get '/' do
      throw :halt, [401, 'go away!']
    end

    get_it '/'
    status.should == 401
    body.should == 'go away!'
  end

  specify "handle [status, helper with args]" do
    helpers do
      def bang(word)
        word + '!'
      end
    end

    get '/' do
      throw :halt, [401, [:bang, 'shoo']]
    end

    get_it '/'
    status.should == 401
    body.should == 'shoo!'
  end

  specify "handle proc" do
    get '/' do
      throw :halt, lambda { 'body' }
    end

    get_it '/'
    should.be.ok
    body.should == 'body'
  end

  specify "handle custom to_result" do
    klass = Class.new do
      def to_result(event_context, *args)
        event_context.body = 'This will be the body!'
      end
    end

    get '/' do
      throw :halt, klass.new
    end

    get_it '/'
    should.be.ok
    body.should == 'This will be the body!'
  end

end
