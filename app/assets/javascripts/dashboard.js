var apiVer = 'v1';

Jarviis = new Backbone.Marionette.Application();

Jarviis.states = [
  'Open',
  'Resolved',
  'Closed',
  'Wontfix'
];

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
    Backbone.history.start({pushState: true});
  }
});

$(document).ready(function() {
  Jarviis.start();
});

