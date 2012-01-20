require 'sinatra'
require 'json'

$articles = []

def timestamp
  Time.now.strftime("%H:%M:%S")
end

get '/' do 
  File.read('index.html')
end

get '/articles' do
  content_type :json
  {:articles => $articles}.to_json
end

post '/articles' do
  article = params.merge( {'timestamp' => timestamp}).to_json
  puts article
  $articles << article
end
