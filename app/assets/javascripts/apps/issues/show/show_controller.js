Jarviis.module("Issues.Show", function(Show, Jarviis, Backbone, Marionette, $, _){
  Show.Controller = {
    showIssue: function(id){
      var fetchingIssue = Jarviis.request("issue:entity", id);
      $.when(fetchingIssue).done(function(issue){
        var issueView;
        if(issue !== undefined){
          issueView = new Show.Issue({
            model: issue
          });

          issueView.on("issue:edit", function(issue){
            Jarviis.trigger("issue:edit", issue.get("id"));
          });
        }
        else{
          issueView = new Show.MissingIssue();
        }

        Jarviis.main.show(issueView);
      });
    }
  }
});
