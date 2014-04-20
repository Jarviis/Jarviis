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
      "change": "render"
    },
    resolveIssue: function () {
      this.model.resolve();
    },
    openIssue: function() {
      this.model.open();
    },
    closeIssue: function() {
      this.model.close();
    }
  });
});

