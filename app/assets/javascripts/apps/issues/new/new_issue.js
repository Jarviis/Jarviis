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
    initialize: function () {
      var fetchingUsers = Jarviis.request('users:entity');
      var self = this;
      $.when(fetchingUsers).done(function(users){
        self.users = users;
        self.render();
      });
    },
    create: function (ev) {
      ev.preventDefault();
      var data = Backbone.Syphon.serialize(this);
      if(data) {
        var newIssue = new Jarviis.Entities.Issue();
        newIssue.save(data, {success: function (model) {
          Jarviis.execute("issues:new", model, data);
        }});
      }
      this.exit();
    },
    onRender: function () {
      this.ui.assignee.chosen({allow_single_deselect: true});
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
      Jarviis.modalRegion.reset();
    },
    serializeData: function () {
      var users = this.users ? this.users.toJSON() : [];
      return {
        users: users
      };
    }
  });
});
