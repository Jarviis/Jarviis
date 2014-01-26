// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//


Jarviis.addRegions({
  main: "#main"
});

Jarviis.addInitializer(function() {
  Jarviis.issues = new Jarviis.Collections.Issues();

  Jarviis.main.show(new Jarviis.Views.IssuesView({collection: Jarviis.issues, el: '#issues'}));
});

$(document).ready(function() {
  Jarviis.start();
});
