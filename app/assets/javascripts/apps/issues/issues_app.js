Jarviis.module("Issues", function(Issues, Jarviis, Backbone, Marionette, $, _){
  Issues.Router = Marionette.AppRouter.extend({
    appRoutes: {
      "": "listIssues",
      "issues/:id": "showIssue"
    }
  });

  var Controller = {
    showIssue: function(id) {
      Jarviis.Issues.Show.Controller.showIssue(id)
    },
    listIssues: function() {
      Jarviis.Issues.List.Controller.listIssues();
    }
  };

  Jarviis.addInitializer(function(){
    new Issues.Router({
      controller: Controller
    });
  });
});
