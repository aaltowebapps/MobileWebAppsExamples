require 'sinatra'
require 'json'
require 'haml'

$articles = [{:title => "Welcome", 
               :content => "My first post",
               :email => "hello@blog.com",
               :timestamp => "1.1.2012 10:20:30"}]

def timestamp
  Time.now.strftime("%d.%m.%Y %H:%M:%S")
end

get '/' do 
  #Renders the haml template index.html.haml
  #with the default layout layout.html.haml
  haml :index, :layout => :layout
end

get '/new' do 
  haml :new
end

post '/new' do
  #Symbolize the params keys
  article = params.inject({}) { |h,(k,v)| h[k.to_sym] = v; h }
  
  article[:timestamp] = timestamp
  $articles << article

  puts article
  redirect to ("/")
end
