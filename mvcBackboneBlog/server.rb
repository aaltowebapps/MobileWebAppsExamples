require 'sinatra'
require 'json'
require 'haml'

$articles = [{ :title => "Welcome", 
               :content => "My first post",
               :name => "Hello",
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


#REST API for Articles
get '/articles' do
  content_type :json
  $articles.to_json
end

get '/articles/:id' do
  puts "*** get article #{params[:id]}"
  if params[:id].to_i > $articles.length
    status 404
  else
    content_type :json
    $articles[params[:id].to_i].to_json
  end
end

post '/articles' do
  puts "*** Created article: #{request.body.string}"
  data = JSON.parse(request.body.string)
  if data.nil?
    status 400
  else
    article = {}
    [:title, :content, :email, :name].each do |k|
      article[k] = data[k.to_s] || ""
    end
    article[:timestamp] = timestamp
    article[:id] = $articles.length
    $articles[article[:id].to_i] = article
    puts "    new article: #{article}"
    
    article.to_json  
  end
end

put '/articles/:id' do
  puts "*** update article #{params[:id]}"
  data = JSON.parse(request.body.string)
  if data.nil?
    status 400
  else
    article = {}
    [:title, :content, :email, :name].each do |k|
      article[k] = data[k.to_s] || ""
    end
    article[:timestamp] = timestamp
    article[:id] = params[:id].to_i
    
    #Replace the entry in the list of articles
    $articles[article[:id].to_i].merge!(article)

    puts "    new value: #{article}"
    content_type :json
    $articles[params[:id].to_i].to_json
  end
end

delete '/articles/:id' do
  puts "*** delete article #{params[:id]}"
  if params[:id].to_i >= $articles.length
    status 404
  else
    $articles.delete_at(params[:id].to_i)
  end 
end

