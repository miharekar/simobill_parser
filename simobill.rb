require 'sinatra/base'
require './lib/simobill_parser/bill'
require 'better_errors'

class Simobill < Sinatra::Base
  configure :development do
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
