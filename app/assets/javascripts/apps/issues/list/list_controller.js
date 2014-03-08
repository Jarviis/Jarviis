Jarviis.module("Issues.List", function(List, Jarviis, Backbone, Marionette, $, _){
  List.Controller = {
    listIssues: function () {
      var assigned_issues = new Jarviis.Entities.IssueCollection();
      assigned_issues.fetch({data: {assignee_username: current_username}});

      window.reported_issues = new Jarviis.Entities.IssueCollection();
      reported_issues.fetch({data: {reporter_username: current_username}});

      // Jarviis.navbar.attachView(new Jarviis.Views.NavView({el: $(".navbar")}));

      var layout = new Jarviis.Issues.List.Layout();
      Jarviis.main.show(layout);

      layout.assigned.show(new Jarviis.Issues.List.Issues({collection: assigned_issues}));
      layout.reported.show(new Jarviis.Issues.List.Issues({collection: reported_issues}));
    }
  };

});
