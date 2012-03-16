require 'sinatra'
require 'json'
require 'haml'
require 'net/http'
require 'base64'


get '/' do 
  #Renders the haml template index.html.haml
  #with the default layout layout.html.haml
  haml :index, :layout => :layout
end

get '/fetch' do
  #Fetch the image from the URL and encodes it as a data URI
  base_image = Net::HTTP.get(URI.parse(params['url']))
  puts "Fetched image: " + params['url']
  "data:image/png;base64,#{Base64.encode64(base_image)}"
end

