Jarviis.module("Header", function(Header, Jarviis, Backbone, Marionette, $, _){
  Header.View = Marionette.ItemView.extend({
    initialize: function() {
      var searchRegion = new Backbone.Marionette.Region({
        el: this.$('#search')
      });

      searchRegion.show(new Header.SearchView());
    },
    events: {
      'click .add-issue': 'addIssue',
    },
    addIssue: function(ev) {
      Jarviis.modalRegion.show(new Jarviis.Issues.New.Issue());
    }
  });
});

