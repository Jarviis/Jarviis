Jarviis.Views.CreateIssue = Backbone.Marionette.ItemView.extend({
  template: _.template($('#add-issue-modal').text()),
  events: {
    'click .close': 'exit',
    'click button': 'create'
  },
  ui: {
    name: '#name',
    assignee: '#assignee',
    due_date: '#due-date',
    description: '#description'
  },
  create: function (ev) {
    ev.preventDefault();
    var newIssue = new Jarviis.Models.Issue({
      name: this.ui.name.val(),
      assignee: this.ui.assignee.val(),
      due_date: this.ui.due_date.val(),
      description: this.ui.description.val()
    });
    newIssue.save({wait:true});
    Jarviis.b.issues.push(newIssue)
    Jarviis.modal.close();
  },
  exit: function () {
    Jarviis.modal.close();
  },
});
