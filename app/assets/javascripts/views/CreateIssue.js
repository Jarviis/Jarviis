Jarviis.Views.CreateIssue = Backbone.Marionette.ItemView.extend({
  template: _.template($('#add-issue-modal').text()),
  events: {
    'click .close': 'exit'
  },
  exit: function () {
    Jarviis.modal.close();
  },
});
