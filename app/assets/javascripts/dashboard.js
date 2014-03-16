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
  modal: Marionette.Region.Modal.extend({el: '#modal'})
});

Jarviis.navigate = function(route, options){
  options || (options = {});
  Backbone.history.navigate(route, options);
};

Jarviis.getCurrentRoute = function(){
  return Backbone.history.fragment
};

Jarviis.on("initialize:after", function(){
  Jarviis.header.attachView(new Jarviis.Header.View({el: $(".navbar")}));
  if(Backbone.history){
    Backbone.history.start({pushState: true});
  }
});
