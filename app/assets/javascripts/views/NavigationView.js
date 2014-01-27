Jarviis.Views.NavView = Backbone.Marionette.ItemView.extend({
  events: {
    'click .add-issue': 'addIssue',
  },
  addIssue: function() {
    Jarviis.modal.show(new Jarviis.Views.CreateIssue())
  }
});

