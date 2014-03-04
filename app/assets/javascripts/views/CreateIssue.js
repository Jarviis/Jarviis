Jarviis.Views.CreateIssue = Backbone.Marionette.ItemView.extend({
  template: _.template($('#add-issue-modal').text()),
  events: {
    'click #close': 'exit',
    'click #minimize': 'minimize',
    'click #maximize': 'maximize',
    'click .create': 'create'
  },
  ui: {
    content: '.modal-content',
    minimized: '.modal-minimized',
    name: '#name',
    assignee: '#assignee',
    reporter: '#reporter',
    due_date: '#due-date',
    description: '#description'
  },
  create: function (ev) {
    ev.preventDefault();
    var data = Backbone.Syphon.serialize(this);
    if(data) {
      var newIssue = new Jarviis.Models.Issue(data);
      newIssue.save();
      Jarviis.b.issues.push(newIssue)
    }
    Jarviis.modal.close();
  },
  maximize: function () {
    this.ui.minimized.hide();
    this.ui.content.slideDown(100);
  },
  minimize: function () {
    var that = this;
    this.ui.content.slideUp(100, function () {
      that.ui.minimized.show();
    });
  },
  exit: function () {
    Jarviis.modal.close();
  },
});
