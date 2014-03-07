Jarviis.module("Issues.Show", function(Show, Jarviis, Backbone, Marionette, $, _){
  Show.MissingIssue = Marionette.ItemView.extend({
    template: "#missing-issue-template"
  });

  Show.Issue = Marionette.ItemView.extend({
    template: "#show-issue-template",
  });
});
