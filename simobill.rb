require 'sinatra/base'

class Simobill < Sinatra::Base
  configure do
    $LOAD_PATH << "#{File.dirname(__FILE__)}/lib"
  end

  configure :development do
    require 'better_errors'
    use BetterErrors::Middleware
    BetterErrors.application_root = __dir__
    BetterErrors.use_pry!
  end

  configure :production do
    require 'newrelic_rpm'
  end

  require 'simobill_parser/bill'
  require 'haml'

  get '/' do
    haml :index
  end

  post '/show' do
    @bill = SimobillParser::Bill.new(params['bill'][:tempfile])
    haml :show
  end
end
