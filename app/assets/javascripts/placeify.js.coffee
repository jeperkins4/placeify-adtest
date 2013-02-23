# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
window.loadResources = (json) ->
  i = 0

  while i < json.length
    obj = json[i]
    resources[i] = obj.ad_resource
    i++
window.loadPlaylist = (data) ->
  if data.combinations.length > 0
    obj = data.combinations[Math.floor(Math.random() * data.combinations.length)][0]
    extent = obj.combination.extent
    code = obj.combination.code
    ids = obj.combination.ids.split(",")
    i = 0

    while i < ids.length
      j = 0

      while j < resources.length
        resource = resources[j]
        if (parseInt(ids[i]) is resource.id) and (resource.area.code is code)
          resource_data = resource.resource_data
          area_tag = "#" + resource.area.code
          $(area_tag).append resource_data
        j++
      i++
extent = 0
resource = undefined
ids = []
resources = []
code = ""
