require 'sinatra'
require 'haml'

set :public_folder, settings.root

get '/' do
  send_file 'index.html'
end

