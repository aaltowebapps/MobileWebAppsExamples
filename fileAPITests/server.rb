require 'sinatra'
require 'json'
require 'haml'
require 'base64'

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
  haml :index
end

post '/uploadText' do
  raw = request.env["rack.input"].read
  puts "Received data:" + raw
end

post '/uploadFile' do
  raw = request.env["rack.input"].read
  puts "Received data size:" + raw.length.to_s
  File.open("public/"+request.env["HTTP_X_FILE_NAME"], "w") do |f| 
    f.puts raw;    
  end 
end

post '/uploadFormData' do
  raw = request.env["rack.input"].read
  puts params
  params.each do |k,v|
    File.open("public/"+v[:filename], "w") do |f| 
      f.puts v[:tempfile].read;    
    end 
  end
  redirect to('/')
end

post '/uploadBase64' do
  raw = request.env["rack.input"].read.split(',')[1]
  puts request.env["HTTP_X_FILE_NAME"]
  
  File.open("public/"+request.env["HTTP_X_FILE_NAME"], "w") do |f| 
    f.puts Base64.decode64(raw);   
  end 
end


