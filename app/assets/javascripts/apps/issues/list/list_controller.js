Jarviis.module("Issues.List", function(List, Jarviis, Backbone, Marionette, $, _){

  var assigned_issues, reported_issues;

  List.Controller = {
    listIssues: function () {
      var fetchingAssigned = Jarviis.request("issues:entity", {assignee_username: current_username}),
          fetchingReported = Jarviis.request("issues:entity", {reporter_username: current_username});

      $.when(fetchingAssigned, fetchingReported).done(function (assigned, reported) {
        assigned_issues = assigned;
        reported_issues = reported;

        Jarviis.layout = new Jarviis.Issues.List.Layout();
        Jarviis.mainRegion.show(Jarviis.layout);

        Jarviis.layout.assigned.show(new Jarviis.Issues.List.Issues({collection: assigned_issues}));
        Jarviis.layout.reported.show(new Jarviis.Issues.List.Issues({collection: reported_issues}));
      });
    }
  };

  Jarviis.commands.setHandler("issues:new", function(model, data) {
    if (data.assignee_id == CURRENT_USER) {
      assigned_issues.add(model);
    }
    reported_issues.add(model);
  });

});

