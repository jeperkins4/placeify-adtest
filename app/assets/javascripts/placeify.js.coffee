# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
loadPlaylist = (data) ->
  console.log data[0]
  extent = data[0].display[0].area.area_extent
  console.log extent
loadResources = (json) ->
  console.log json
  resource_data = json[0].ad_resource.resource_data
  area_tag = "#" + json[0].ad_resource.area.code
  console.log resource_data
  $(area_tag).html resource_data
