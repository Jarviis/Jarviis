Jarviis.module("Issues.New", function(New, Jarviis, Backbone, Marionette, $, _){

  New.Issue = Marionette.ItemView.extend({
    template: '#add-issue-modal',
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
        var newIssue = new Jarviis.Entities.Issue();
        newIssue.save(data, {success: function (model) {
          Jarviis.execute("issues:new", model);
        }});
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
});
