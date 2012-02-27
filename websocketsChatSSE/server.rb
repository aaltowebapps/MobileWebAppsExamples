require 'json'
require 'sinatra'

def timestamp
  Time.now.strftime("%H:%M:%S")
end

set :server, 'thin'
set :public_folder, settings.root

users = []
messages = []

get '/' do
  send_file 'index.html'
end

get '/chat', provides: 'text/event-stream' do
  stream :keep_open do |out|
    users << out
    
    #callback is fired when the stream is closed. 
    out.callback { 
      users.delete(out) 
    } 
  end
end

post '/chat' do
  puts params
  #Add the timestamp to the message
  message = params.merge( {'timestamp' => timestamp}).to_json

  #append the message at the end of the queue
  messages << message
  messages.shift if messages.length > 10

  users.each { |out| out << "data: #{message}\n\n"}
end
