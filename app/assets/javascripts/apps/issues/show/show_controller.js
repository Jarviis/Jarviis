Jarviis.module("Issues.Show", function(Show, Jarviis, Backbone, Marionette, $, _){

  Show.Controller = {
    showIssue: function(id) {
      var fetchingIssue = Jarviis.request("issue:entity", id),
          fetchingComments = Jarviis.request("comment:entity", id),
          layout = new Jarviis.Issues.Show.Layout();

      Jarviis.mainRegion.show(layout);

      $.when(fetchingIssue, fetchingComments).done(function(issue, comments){
        var breadcrumbs = new Backbone.Collection([
              {step: "Product"},
              {step: "Milestone 2"},
              {step: "Sprint 8"},
              {step: "Ticket #2"}
            ]),
            issueView,
            breadcrumbsView = new Show.Breadcrumbs({
              collection: breadcrumbs
            });

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

        Jarviis.mainRegion.show(layout);
        layout.breadcrumbs.show(breadcrumbsView);
        layout.details.show(issueView);
        layout.comments.show(new Jarviis.Comments.List.Comments({
          collection: comments
        }));
      });
    }
  };

});

