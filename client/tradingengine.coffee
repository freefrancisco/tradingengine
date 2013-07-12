Handlebars.registerHelper 'fillerText', ->
  $.getJSON "http://hipsterjesus.com/api/", (data) ->
    $("#fillerText").html data.text
  "<p id='fillerText'></p>"
    
Handlebars.registerHelper 'fillerImage', (options)->
  width = options.hash.width or 200
  height = options.hash.height or 50
  console.log "fillerImage params: options: #{options}, width: #{width}, height: #{height}", options, width, height
  "<img src='http://placekitten.com/g/#{width}/#{height}'/>"
  