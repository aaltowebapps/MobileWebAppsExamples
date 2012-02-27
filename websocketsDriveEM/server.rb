require 'em-websocket'
require 'json'
require 'sinatra/base'

EventMachine.run {
  @channel = EM::Channel.new
  @users = {}
  @location = {}

  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
    ws.onopen {
      #Subscribe the new user to the channel with the callback function for the push action
      #The callback sends the location of the other users
      new_user = @channel.subscribe { |locs|
        ws.send (locs.select { |k,v| k != ws.object_id }).to_json
      }
      
      #Add the new user to the user and location list
      @users[ws.object_id] = new_user
      @location[ws.object_id] = {}
    }

    ws.onmessage { |msg|
      message = JSON.parse(msg)

      #update the location of the user
      @location[ws.object_id].merge!(message)
    }

    ws.onclose { 
      @channel.unsubscribe(@users[ws.object_id])
      @users.delete(ws.object_id)
      @location.delete(ws.object_id)
    }
  end

  #Periodically broadcast the current locations to all the users
  EventMachine::run {
    EventMachine::add_periodic_timer( 0.5 ) { 
      puts @location

      #Broadcast the message to all users connected to the channel
      @channel.push @location

      #Store the old location of the users
      @location.each { |k, v| 
        if v
          @location[k].merge! ({'oldX' => v['x'], 'oldY' => v['y']} )
        end
      }
    }
  }

  #Run a Sinatra server for serving index.html
  class App < Sinatra::Base
    set :public_folder, settings.root
    
    get '/' do
      send_file 'index.html'
    end
  end
  App.run!
} 
