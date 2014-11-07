Jarviis.module("Comments.List", function(List, Jarviis, Backbone, Marionette, $, _){
  List.Controller = function(issue_id) {
    var fetchingComments = Jarviis.request("comment:entity", issue_id);
    $.when(fetchingComments).done(function(comments) {
      Jarviis.layout.comments.show(new Jarviis.Comments.List.Comments({ collection: comments }))
    });
  }
});
