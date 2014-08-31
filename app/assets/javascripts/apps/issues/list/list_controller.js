Jarviis.module("Issues.List", function(List, Jarviis, Backbone, Marionette, $, _){
  var assigned_issues, reported_issues;
  List.Controller = {
    listIssues: function () {
      assigned_issues = Jarviis.request("issues:entity", {assignee_username: current_username});
      reported_issues = Jarviis.request("issues:entity", {reporter_username: current_username});

      Jarviis.layout = new Jarviis.Issues.List.Layout();
      Jarviis.main.show(Jarviis.layout);

      Jarviis.layout.assigned.show(new Jarviis.Issues.List.Issues({collection: assigned_issues}));
      Jarviis.layout.reported.show(new Jarviis.Issues.List.Issues({collection: reported_issues}));
    }
  };

  Jarviis.commands.setHandler("issues:new", function(data) {
    reported_issues.add(data);
  });

});
