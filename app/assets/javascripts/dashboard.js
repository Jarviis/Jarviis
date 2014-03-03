Jarviis.addRegions({
  navbar: '#nav',
  issues: "#issues",
  modal: Jarviis.Regions.Modal
});

Jarviis.addInitializer(function() {
  Jarviis.b.issues = new Jarviis.Collections.Issues();
  Jarviis.b.issues.fetch();

  Jarviis.navbar.attachView(new Jarviis.Views.NavView({el: $(".navbar")}));
  Jarviis.issues.show(new Jarviis.Views.IssuesView({collection: Jarviis.b.issues}));
});

$(document).ready(function() {
  Jarviis.start();
});
