require 'sinatra'
require 'json'
require 'haml'
require 'manifesto'

$articles = [{ :title => "Welcome", 
               :content => "My first post",
               :email => "hello@blog.com",
               :timestamp => "1.1.2012 10:20:30"}]

def timestamp
  Time.now.strftime("%d.%m.%Y %H:%M:%S")
end

get '/manifest.appcache' do
  headers 'Content-Type' => 'text/cache-manifest' # Must be served with this MIME type
  cache_control :no_cache #Disable caching of manifest file, only for demo purposes
  Manifesto.cache
end

get '/' do 
  #Renders the haml template index.html.haml
  #with the default layout layout.html.haml
  haml :index, :layout => :layout
end

post '/new' do
  #Symbolize the params keys
  article = params.inject({}) { |h,(k,v)| h[k.to_sym] = v; h }
  
  article[:timestamp] = timestamp
  $articles << article

  puts article
  redirect to ("/")
end

post '/update' do
  #Symbolize the params keys
  article = params.inject({}) { |h,(k,v)| h[k.to_sym] = v; h }

  #Update the timestamp
  article[:timestamp] = timestamp
  
  #Replace the entry in the list of articles
  $articles[article[:id].to_i].merge!(article)

  puts $articles
end

