require 'sinatra'
require 'json'
require 'pusher'

Pusher.app_id = '13324'
Pusher.key = '8dc1dcd216474ec35b02'
Pusher.secret = '6ae6292fa86e2a559643'

def timestamp
  Time.now.strftime("%H:%M:%S")
end

get '/' do 
  #Serve the chat client
  File.read('index.html')
end

post '/say' do
  message = params.merge( {'timestamp' => timestamp}).to_json

  #Use the REST Pusher API so pass the message that needs to be broadcasted
  #to all clients that are connected to the chat channel
  Pusher['chat'].trigger('say', message)
end
