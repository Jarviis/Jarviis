var apiVer = 'v1';
Jarviis = new Backbone.Marionette.Application();

Jarviis.addRegions({
  header: '#nav',
  main: '#main',
  modal: '#modal'
});

Jarviis.on("initialize:after", function(){
  var assigned_issues = new Jarviis.Entities.IssueCollection();
  assigned_issues.fetch({data: {assignee_username: current_username}});

  var reported_issues = new Jarviis.Entities.IssueCollection();
  reported_issues.fetch({data: {reporter_username: current_username}});

  // Jarviis.navbar.attachView(new Jarviis.Views.NavView({el: $(".navbar")}));

  var dashboard = new Jarviis.Layouts.DashboardLayout();
  Jarviis.main.show(dashboard);

  dashboard.assigned.show(new Jarviis.Issues.List.Issues({collection: assigned_issues}));
  dashboard.reported.show(new Jarviis.Issues.List.Issues({collection: reported_issues}));
});

$(document).ready(function() {
  Jarviis.start();
});

