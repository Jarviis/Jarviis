Jarviis.module("Issues.Show", function(Show, Jarviis, Backbone, Marionette, $, _){
  Show.Controller = {
    showIssue: function(id) {
      var fetchingIssue = Jarviis.request("issue:entity", id);
      var fetchingComments = Jarviis.request("comment:entity", id);

      Jarviis.main.show(Jarviis.layout);

      $.when(fetchingIssue, fetchingComments).done(function(issue, comments){
        var issueView;
        if(issue !== undefined){
          issueView = new Show.Issue({
            model: issue
          });

          issueView.on("issue:edit", function(issue){
            Jarviis.trigger("issue:edit", issue.get("id"));
          });
        } else {
          issueView = new Show.MissingIssue();
        }

        Jarviis.main.show(issueView);
        Jarviis.addRegions({
          comments: "#comments"
        });
        Jarviis.comments.show(new Jarviis.Comments.List.Comments({ collection: comments }))
      });
    }
  }
});

