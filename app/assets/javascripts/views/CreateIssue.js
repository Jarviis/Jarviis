Jarviis.Views.CreateIssue = Backbone.Marionette.ItemView.extend({
  template: _.template($('#add-issue-modal').text()),
  events: {
    'click .close': 'exit',
    'click button': 'create'
  },
  ui: {
    name: '#name',
    assignee: '#assignee',
    reporter: '#reporter',
    due_date: '#due-date',
    description: '#description'
  },
  create: function (ev) {
    ev.preventDefault();
    var data = Backbone.Syphon.serialize(this);
    console.log(data);
    var newIssue = new Jarviis.Models.Issue(data);
    newIssue.save();
    Jarviis.b.issues.push(newIssue)
    Jarviis.modal.close();
  },
  exit: function () {
    Jarviis.modal.close();
  },
});
