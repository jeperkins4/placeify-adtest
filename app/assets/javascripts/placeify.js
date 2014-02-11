var buildResources, getUrlVars, methodCalled, renderMedia, selectPlaylist, pushList;

renderMedia = void 0;

selectPlaylist = void 0;

getUrlVars = void 0;

methodCalled = false;

pushList = [];

renderMedia = function(resources, areas) {
  var ad_placement, area_resources, area_tag, article, article_length, code, code_found, displayed_ids, extent, i, ids, j, k, obj, playlist, resource, resource_data, _results, _results1;
  ad_placement = void 0;
  area_tag = void 0;
  article = void 0;
  article_length = void 0;
  code = void 0;
  code_found = void 0;
  displayed_ids = void 0;
  extent = void 0;
  i = void 0;
  ids = void 0;
  j = void 0;
  k = void 0;
  obj = void 0;
  playlist = void 0;
  resource = void 0;
  resource_data = void 0;
  _results = void 0;
  _results1 = void 0;
  k = 0;
  _results1 = [];
  article = jQuery(".content p");
  article_length = jQuery(".content").text().length;
  if ((article.length > 4) && (article_length > 1200) && (findArea('channel', areas).length > 0)) {
    ad_placement = "<div id=\"channel\"></div>";
    jQuery(".content p:nth-child(3)").after(ad_placement);
    jQuery("#channel").css("border-top", "solid #CCC 1px").css("border-bottom", "solid #CCC 1px").css("padding", "5px").css("margin-bottom", "10px");
    jQuery("#channel").append("<ul id=\"channel-ads\"></ul>");
    jQuery("ul#channel-ads").css("margin", "0px").css("padding", "5px");
  }
  while (k < areas.length) {
    code_found = false;
    obj = areas[k];
    extent = obj.combination.extent;
    code = obj.combination.code;
    playlist = obj.combination.ids;
    ids = playlist.split(",");
    displayed_ids = [];
    i = 0;
    obj = void 0;
    k++;
    _results = [];
    if (code === "channel") {
      while (i < ids.slice(0, parseInt(extent)).length) {
        j = 0;
        while (j < resources.length) {
          resource = resources[j];
          if ((parseInt(ids[i]) === parseInt(resource.id)) && (resource.area.code === code)) {
            displayed_ids.push(ids[i]);
            jQuery("#channel-ads").append("<li>" + resource.resource_data + "</li>");
            code_found = true;
          }
          j++;
        }
        i++;
      }
      jQuery("ul#channel-ads li").css("display", "inline-block").css("padding", "0px 5px").css("margin", "0px");
    } else {
      while (i < ids.slice(0, parseInt(extent)).length) {
        j = 0;
        area_resources = jQuery.grep(resources, function(obj, i) {
          return obj.area.code === code;
        });
        while (j < area_resources.length) {
          resource = area_resources[j];
          if ((parseInt(ids[i]) === parseInt(resource.id)) && (resource.area.code === code)) {
            area_tag = "#" + resource.area.code;
            if (jQuery(area_tag).is("*")) {
              resource_data = resource.resource_data;
              code_found = true;
              if (jQuery.inArray(ids[i], pushList) < 0) {
                pushList.push(ids[i]);
                displayed_ids.push(ids[i]);
                console.log("Working " + playlist + " area " + resource.area.code);
                console.log("Pushed " + ids[i] + " matches " + resource.id);
                postscribe(area_tag, resource_data);
              }
            }
            jQuery(area_tag+" div").css("padding", "11px 0px").css("text-align", "center");
            false;
          }
          j++;
        }
        i++;
      }
    }
    if ((code_found === true) && (playlist != null)) {
      /* console.log("Sending " + playlist); */
      _results1.push(jQuery.ajax({
        type: "POST",
        url: "http://placeify.herokuapp.com/sites/traffic.json",
        dataType: "json",
        data: {
          code: "SecureIDNews",
          playlist: displayed_ids.join()
        },
        success: function(msg) {
          return true; /* console.log("Did it"); */
        },
        failure: function(msg) {
          return false; /* console.log("Failed"); */
        }
      }));
    } else {
      _results1.push(void 0);
    }
  }
  return; /* _results1; */
};

selectPlaylist = function(resources, site_code) {
  var playlist, tags, url;
  playlist = [];
  tags = getUrlVars()["tag"];
  if (tags == null) {
    url = document.location.pathname.substring(1);
    url = url.split("/");
    url = jQuery.grep(url, function(n) {
      return n;
    });
    /* console.log("URL is " + url); */
    tags = url[url.length - 1];
  }
  return jQuery.getJSON("http://placeify.herokuapp.com/playlists/" + site_code + ".js?callback=?&tags=" + tags, function(data) {
    if (data.combinations.length > 0) {
      playlist = data.combinations[Math.floor(Math.random() * data.combinations.length)];
      return renderMedia(resources, playlist);
    }
  });
};

buildResources = function(site_code) {
  var resources;
  methodCalled = true;
  resources = [];
  /* console.log("Calling resources..."); */
  return jQuery.getJSON("http://placeify.s3.amazonaws.com/production/things/" + site_code + ".js?callback=jsonp", function(json) {
    var i, obj;
    i = void 0;
    obj = void 0;
    obj = void 0;
    i = 0;
    while (i < json.length) {
      obj = json[i];
      resources[i] = obj;
      i++;
    }
    return selectPlaylist(resources, site_code);
  });
};

getUrlVars = function() {
  var hash, hashes, i, vars;
  hash = void 0;
  hashes = void 0;
  i = void 0;
  vars = void 0;
  vars = [];
  hash = void 0;
  hashes = window.location.href.slice(window.location.href.indexOf("?") + 1).split("&");
  i = 0;
  while (i < hashes.length) {
    hash = hashes[i].split("=");
    vars.push(hash[0]);
    vars[hash[0]] = hash[1];
    i++;
  }
  return vars;
};

function findArea(area, areas){
    return jQuery.grep(areas, function(item){
      return item.combination.code == area;
    });
};

jQuery(document).ready(function() {
  var site_code;
  site_code = jQuery(".site_code").attr("id");
  site_code = "SecureIDNews";
  if (!methodCalled) {
    return buildResources(site_code);
  }

});

