Jarviis.addRegions({
  navbar: '#nav',
  assigned: "#assigned",
  reported: "#reported",
  modal: Jarviis.Regions.Modal
});

Jarviis.addInitializer(function() {
  Jarviis.b.assigned_issues = new Jarviis.Collections.Issues({type: "assignee", username: current_username});
  Jarviis.b.assigned_issues.fetch();

  Jarviis.b.reported_issues = new Jarviis.Collections.Issues({type: "reporter", username: current_username});
  Jarviis.b.reported_issues.fetch();

  Jarviis.navbar.attachView(new Jarviis.Views.NavView({el: $(".navbar")}));
  Jarviis.assigned.show(new Jarviis.Views.IssuesView({collection: Jarviis.b.assigned_issues}));
  Jarviis.reported.show(new Jarviis.Views.IssuesView({collection: Jarviis.b.reported_issues}));
});

$(document).ready(function() {
  Jarviis.start();
});
