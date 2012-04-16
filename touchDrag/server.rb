require 'sinatra'
require 'haml'

set :public_folder, settings.root

get '/' do
  puts request.user_agent
  send_file 'index.html'
end


