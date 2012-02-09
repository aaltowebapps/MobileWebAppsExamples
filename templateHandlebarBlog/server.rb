require 'sinatra'
require 'json'
require 'haml'

$articles = [{ :title => "Welcome", 
               :content => "My first post",
               :email => "hello@blog.com",
               :timestamp => "1.1.2012 10:20:30",
               :id => 0}]

def timestamp
  Time.now.strftime("%d.%m.%Y %H:%M:%S")
end

get '/' do 
  #Renders the haml template index.html.haml
  #with the default layout layout.html.haml
  haml :index, :layout => :layout
end

get '/articles' do
  content_type :json
  {:articles => $articles}.to_json
end

post '/new' do
  #Symbolize the params keys
  article = params.inject({}) { |h,(k,v)| h[k.to_sym] = v; h }
  
  article[:timestamp] = timestamp
  article[:id] = $articles.length
  $articles << article

  puts $articles
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

