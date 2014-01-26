Jarviis.Views.NavView = Backbone.Marionette.ItemView.extend({
  events: {
    'click .add-issue': 'addIssue',
  },
  addIssue: function() {
    console.log('lalal')

    Jarviis.modal.show(new Jarviis.Views.CreateIssue())
  }
});

