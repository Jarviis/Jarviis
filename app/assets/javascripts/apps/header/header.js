Jarviis.module("Header", function(Header, Jarviis, Backbone, Marionette, $, _){
  Header.View = Marionette.ItemView.extend({
    events: {
      'click .add-issue': 'addIssue',
    },
    addIssue: function(ev) {
      Jarviis.modal.show(new Jarviis.Issues.New.Issue());
    }
  });
});

