require 'em-websocket'
require 'json'
require 'sinatra/base'

def timestamp
  Time.now.strftime("%H:%M:%S")
end

EventMachine.run {
  @channel = EM::Channel.new
  @users = {}
  @messages = []

  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
      
    ws.onopen {
      #Subscribe the new user to the channel with the callback function for the push action
      new_user = @channel.subscribe { |msg| ws.send msg }
      
      #Add the new user to the user list
      @users[ws.object_id] = new_user
      
      #Push the last messages to the user
      @messages.each do |message|
        ws.send message
      end
      
      #Broadcast the notification to all users
      @channel.push  ({
        "nickname" => '', 
        "message" => "New user joined. #{@users.length} users in chat", 
        "timestamp" => timestamp }.to_json)
   }

    ws.onmessage { |msg|
      
      #Add the timestamp to the message
      message = JSON.parse(msg).merge( {'timestamp' => timestamp}).to_json
      
      #append the message at the end of the queue
      @messages << message
      @messages.shift if @messages.length > 10

      #Broadcast the message to all users connected to the channel
      @channel.push message
    }

    ws.onclose { 
      @channel.unsubscribe(@users[ws.object_id])
      @users.delete(ws.object_id)

      #Broadcast the notification to all users
      @channel.push ({
        "nickname" => '', 
        "message" => "One user left. #{@users.length} users in chat", 
        "timestamp" => timestamp}.to_json)
    }
  end

  #Run a Sinatra server for serving index.html
  class App < Sinatra::Base
    set :public_folder, settings.root
    
    get '/' do
      send_file 'index.html'
    end
  end
  App.run!
} 


