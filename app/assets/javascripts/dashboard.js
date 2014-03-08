var apiVer = 'v1';
Jarviis = new Backbone.Marionette.Application();

Jarviis.addRegions({
  header: '#nav',
  main: '#main',
  modal: '#modal'
});

Jarviis.navigate = function(route, options){
  options || (options = {});
  Backbone.history.navigate(route, options);
};

Jarviis.getCurrentRoute = function(){
  return Backbone.history.fragment
};

Jarviis.on("initialize:after", function(){
  if(Backbone.history){
    Backbone.history.start();
  }
});

$(document).ready(function() {
  Jarviis.start();
});

