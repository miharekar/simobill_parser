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

  helpers do
    def get_duration_value(duration)
      if duration =~ /:/
        Time.parse(duration).to_i
      else
        Filesize.from(duration.gsub(',', '.')).to_f('KB')
      end
    end
  end

  get '/' do
    haml :index
  end

  post '/show' do
    bill = SimobillParser::Bill.new(params['bill'][:tempfile])
    haml :show, locals: { bill: bill }
  end
end
