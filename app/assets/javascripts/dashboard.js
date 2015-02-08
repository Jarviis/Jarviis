(function() {
  var JarviisApp = Marionette.Application.extend({
    initialize: function () {
      this.addRegions({
        mainRegion: '#main',
        headerRegion: '#nav',
        modalRegion: Marionette.Region.Modal.extend({el: '#modal'})
      });
    },

    states: function () {
      return [
        'Open',
        'Resolved',
        'Closed',
        'Wontfix'
      ];
    },

    navigate: function(route, options){
      options || (options = {});
      Backbone.history.navigate(route, options);
    },

    currentRoute: function(){
      return Backbone.history.fragment
    }
  });

  window.apiVer = 'v1';
  window.Jarviis = new JarviisApp();

  Jarviis.on('start', function(){
    Jarviis.headerRegion.attachView(new Jarviis.Header.View({el: $(".navbar")}));
    if(Backbone.history){
      Backbone.history.start({pushState: true});
    }
  });
})();
