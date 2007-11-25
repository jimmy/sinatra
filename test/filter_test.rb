require File.dirname(__FILE__) + '/helper'

class CustomResult
  
  def to_result(cx, *args)
    cx.status 404
    cx.body "Can't find this shit!"
  end
  
end

context "Filters" do
  
  setup do
    Sinatra.filters.clear
    Sinatra.routes.clear
    Sinatra.config = nil
  end

  specify "halts when told" do
  
    before do
      throw :halt, 'fubar'
    end
  
    get '/' do
      'not this'
    end
    
    get_it '/'
    
    should.be.ok
    body.should.equal 'fubar'
    
  end
  
  specify "halts with status" do
    
    before do
      throw :halt, [401, 'get out dude!']
    end
    
    get '/auth' do
      "you're in!"
    end
    
    get_it '/auth'
    
    status.should.equal 401
    body.should.equal 'get out dude!'
    
  end
  
  specify "halts with custom result" do
    
    before do
      throw :halt, CustomResult.new
    end
    
    get '/custom' do
      'not this'
    end
    
    get_it '/custom'
    
    should.be.not_found
    body.should.equal "Can't find this shit!"
    
  end
  
end
