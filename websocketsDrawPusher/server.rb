require 'sinatra'
require 'json'
require 'pusher'

Pusher.app_id = '13324'
Pusher.key = '8dc1dcd216474ec35b02'
Pusher.secret = '6ae6292fa86e2a559643'

get '/' do 
  File.read('index.html')
end

post '/move' do
  puts params
  Pusher['draw'].trigger('move', params)
end
