require 'sinatra'
require 'base64'

set :public_folder, settings.root

get '/' do
  send_file 'index.html'
end

post '/uploadBase64' do
  raw = request.env["rack.input"].read.split(',')[1]
  puts request.env["HTTP_X_FILE_NAME"]
  
  File.open("public/"+request.env["HTTP_X_FILE_NAME"], "w") do |f| 
    f.puts Base64.decode64(raw);   
  end 
end