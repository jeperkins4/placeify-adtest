# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
# Type here!
$(document).ready ->
  site_code = $(".site_code").attr('id')
  code = undefined
  extent = undefined
  ids = undefined
  loadPlaylist = undefined
  loadResources = undefined
  resource = undefined
  resources = undefined
  $.getJSON "http://placeify.herokuapp.com/things/" + site_code + ".js?callback=?", (json) ->
    i = undefined
    obj = undefined
    _results = undefined
    i = 0
    _results = []
    while i < json.length
      obj = json[i]
      resources[i] = obj.ad_resource
      _results.push i++
    _results

  $.getJSON "http://placeify.herokuapp.com/playlists/" + site_code + ".js?callback=?", (data) ->
    area_tag = undefined
    code = undefined
    extent = undefined
    i = undefined
    ids = undefined
    j = undefined
    obj = undefined
    resource = undefined
    resource_data = undefined
    _results = undefined
    if data.combinations.length > 0
      obj = data.combinations[Math.floor(Math.random() * data.combinations.length)][0]
      extent = obj.combination.extent
      code = obj.combination.code
      ids = obj.combination.ids.split(",")
      i = 0
      _results = []
      while i < ids.length
        j = 0
        while j < resources.length
          resource = resources[j]
          if (parseInt(ids[i]) is resource.id) and (resource.area.code is code)
            resource_data = resource.resource_data
            area_tag = "#" + resource.area.code
            $(area_tag).append resource_data
          j++
        _results.push i++
      _results

  extent = 0
  resource = undefined
  ids = []
  resources = []
  code = ""
