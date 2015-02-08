Jarviis.module("Issues", function(Issues, Jarviis, Backbone, Marionette, $, _){

  var IssuesController = Marionette.Controller.extend({
    showIssue: function(id) {
      console.log(id);
      Jarviis.Issues.Show.Controller.showIssue(id)
    },
    listIssues: function() {
      Jarviis.Issues.List.Controller.listIssues();
    }
  });

  var controller = new IssuesController();

  Issues.Router = new Marionette.AppRouter({
    controller: controller,
    appRoutes: {
      "": "listIssues",
      "issues/:id": "showIssue"
    }
  });

});
