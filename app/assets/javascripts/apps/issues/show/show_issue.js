Jarviis.module("Issues.Show", function(Show, Jarviis, Backbone, Marionette, $, _){

  Show.MissingIssue = Marionette.ItemView.extend({
    template: "#missing-issue-template"
  });

  Show.Issue = Marionette.ItemView.extend({
    template: "#show-issue-template",
    events: {
      'click button#resolve': 'resolveIssue',
      'click button#open': 'openIssue',
      'click button#close': 'closeIssue'
    },
    modelEvents: {
      "change": "onModelChange"
    },
    resolveIssue: function () {
      this.model.resolve();
    },
    openIssue: function() {
      this.model.open();
    },
    closeIssue: function() {
      this.model.close();
    },
    onModelChange: function () {
      this.$('.issue-title .label').text(this.model.get('status'));
    },
    onRender: function () {
      var self = this;
      this.$(".editable").editable({
        mode: "inline",
        type: 'text',
        success: function(response, newValue) {
          self.model.save($(this).data('name'), newValue); //update backbone model
        }
      })
    }
  });
});

