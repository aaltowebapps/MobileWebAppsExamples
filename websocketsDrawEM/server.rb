require 'em-websocket'
require 'json'
require 'sinatra/base'

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
   }

    ws.onmessage { |msg|
      
      #append the message at the end of the queue
      @messages << msg
      @messages.shift if @messages.length > 10

      #Broadcast the message to all users connected to the channel
      @channel.push msg
    }

    ws.onclose { 
      @channel.unsubscribe(@users[ws.object_id])
      @users.delete(ws.object_id)
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
