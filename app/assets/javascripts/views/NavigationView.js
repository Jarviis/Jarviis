Jarviis.Views.NavView = Backbone.Marionette.ItemView.extend({
  events: {
    'click .add-issue': 'addIssue',
  },
  addIssue: function(ev) {
    console.log(ev)
    Jarviis.modal.show(new Jarviis.Views.CreateIssue())
  }
});

