# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

buildArtistsList = (list) -> 
  
  if list
    html = '<ul data-role="listview" data-theme="g" data-role="list-divider">'
    for artist in list
      html += '<li>' + artist + '</li>'
    html += '</ul>'
    $('#artists').html(html)
  
$ -> 
  buildArtistsList( JSON.parse(localStorage.getItem('artists_list')) )
      
  $('#update').live('click', (event) -> 
    $.ajax(
      url: "/artists"
      dataType: "json"
      ifModified: true
      success: (data, textStatus, xhr) ->
        if (textStatus == "success")
          #If the server has returned the new data, we save the etag and the data in the local storage
          localStorage.setItem('artists_etag', xhr.getResponseHeader('Etag'))
          localStorage.setItem('artists_list', JSON.stringify(data))
          buildArtistsList(data)
        else if textStatus == "notmodified"
          buildArtistsList(JSON.parse(localStorage.getItem('artists_list'))) 
        #Refresh the listivew in case it has been updated
        $('#artists ul').listview()
    )
  )
  
  $('#clear').live('click', (event) ->
    alert('ciao2')
  )
