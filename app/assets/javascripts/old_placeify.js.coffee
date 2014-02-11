# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
# Type here!
renderMedia = undefined
selectPlaylist = undefined
getUrlVars = undefined
methodCalled = false
pushList = []
renderMedia = (resources, areas) ->
  ad_placement = undefined
  area_tag = undefined
  article = undefined
  article_length = undefined
  code = undefined
  code_found = undefined
  displayed_ids = undefined
  extent = undefined
  i = undefined
  ids = undefined
  j = undefined
  k = undefined
  obj = undefined
  playlist = undefined
  resource = undefined
  resource_data = undefined
  _results = undefined
  _results1 = undefined
  k = 0
  _results1 = []
  article = jQuery(".content p")
  article_length = jQuery(".content").text().length
  if (article.length > 4) and (article_length > 1200)
    ad_placement = "<div id=\"channel\"></div>"
    jQuery(".content p:nth-child(3)").after ad_placement
    jQuery("#channel").css("border-top", "solid #CCC 1px").css("border-bottom", "solid #CCC 1px").css("padding", "5px").css "margin-bottom", "10px"
    jQuery("#channel").append "<ul id=\"channel-ads\"></ul>"
    jQuery("ul#channel-ads").css("margin", "0px").css "padding", "5px"
  while k < areas.length
    code_found = false
    obj = areas[k]
    extent = obj.combination.extent
    code = obj.combination.code
    playlist = obj.combination.ids
    ids = playlist.split(",")
    displayed_ids = []
    i = 0
    obj = undefined
    k++
    _results = []
    if code is "channel"
      while i < ids.slice(0, parseInt(extent)).length
        j = 0
        while j < resources.length
          resource = resources[j]
          if (parseInt(ids[i]) is parseInt(resource.id)) and (resource.area.code is code)
            displayed_ids.push ids[i]
            jQuery("#channel-ads").append "<li>" + resource.resource_data + "</li>"
            code_found = true
          j++
        i++
      jQuery("ul#channel-ads li").css("display", "inline-block").css("padding", "0px").css "margin", "0px"
    else
      while i < ids.slice(0, parseInt(extent)).length
        j = 0
        area_resources = jQuery.grep(resources, (obj, i) ->
          obj.area.code is code
        )
        while j < area_resources.length
          resource = area_resources[j]
          if (parseInt(ids[i]) is parseInt(resource.id)) and (resource.area.code is code)
            area_tag = "#" + resource.area.code
            if jQuery(area_tag).is("*")
              resource_data = resource.resource_data
              code_found = true
              if jQuery.inArray(ids[i],pushList) < 0
                pushList.push ids[i]
                displayed_ids.push ids[i]
                console.log "Working " + playlist + " area "+resource.area.code
                console.log "Pushed "+ids[i]+" matches "+resource.id
                #jQuery(area_tag).append resource_data
                postscribe(area_tag, resource_data)
                jQuery(area_tag + " div").css("padding", "5px").css "text-align", "center"
            false
          j++
        i++
    if (code_found is true) and (playlist?)
      console.log "Sending " + playlist
      _results1.push jQuery.ajax(
        type: "POST"
        url: "http://localhost:5000/sites/traffic.json"
        dataType: "json"
        data:
          code: "Demo"
          playlist: displayed_ids.join()

        success: (msg) ->
          console.log "Did it"

        failure: (msg) ->
          console.log "Failed"
      )
    else
      _results1.push undefined
  _results1

selectPlaylist = (resources, site_code) ->
  playlist = []
  tags = getUrlVars()["tag"]
  unless tags?
    url = document.location.pathname.substring(1)
    url = url.split("/")
    url = jQuery.grep(url, (n) ->
      n
    )
    console.log "URL is "+url
    tags = url[url.length - 1]
  jQuery.getJSON "http://localhost:5000/playlists/" + site_code + ".js?callback=?&tags=" + tags, (data) ->
    console.log data
    if data.combinations.length > 0
      playlist = data.combinations[Math.floor(Math.random() * data.combinations.length)]
      renderMedia resources, playlist


buildResources = (site_code) ->
  methodCalled = true
  resources = []
  console.log "Calling resources..."
  jQuery.getJSON "http://localhost:5000/things/" + site_code + ".js?callback=?", (json) ->
    i = undefined
    obj = undefined
    obj = undefined
    i = 0
    while i < json.length
      obj = json[i]
      resources[i] = obj.ad_resource
      i++
    selectPlaylist resources, site_code

getUrlVars = ->
  hash = undefined
  hashes = undefined
  i = undefined
  vars = undefined
  vars = []
  hash = undefined
  hashes = window.location.href.slice(window.location.href.indexOf("?") + 1).split("&")
  i = 0
  while i < hashes.length
    hash = hashes[i].split("=")
    vars.push hash[0]
    vars[hash[0]] = hash[1]
    i++
  vars

jQuery(document).ready ->
  site_code = jQuery(".site_code").attr("id")
  site_code = "Demo"
  buildResources site_code unless methodCalled
