require 'sinatra/base'
require './lib/simobill_parser/bill'

class Simobill < Sinatra::Base
  configure :development do
    require 'better_errors'
    use BetterErrors::Middleware
    BetterErrors.application_root = __dir__
  end

  get '/' do
    haml :index
  end

  post '/show' do
    @bill = SimobillParser::Bill.new(params['bill'][:tempfile])
    haml :show
  end
end
