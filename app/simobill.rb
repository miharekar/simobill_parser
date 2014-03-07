require 'bundler/setup'
require 'sinatra/base'

class Simobill < Sinatra::Base
  get '/' do
    'Upload your bill'
  end
end
