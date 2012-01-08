class HomeController < ApplicationController
  respond_to :html, :json
    
  def index
    
  end
  def artists
    
    data = ['Lady Gaga', 'Pink Floyd', 'Rammstein', 'REM']
    respond_to do |format|
      format.html # index.html.erb
      #format.json  { send_data JSON.pretty_generate(Place.without(:id,:_id).all.as_json(:include =>:products)), :type => :json, :filename => "backup-#{Time.now.strftime('%Y%m%d-%H%M%S')}.json" }
      format.json { render :json => data}
    end
  end
end
