Jarviis.module("Comments.List", function(List, Jarviis, Backbone, Marionette, $, _){
  List.Comment = Marionette.ItemView.extend({
    tagName: 'li',
    className: 'list-group-item',
    template: "#comment-template"
  });

  var NoCommentView = Backbone.Marionette.ItemView.extend({
    tagName: "li",
    className: "list-group-item",
    template: _.template('No comments.')
  });

  List.Comments = Marionette.CompositeView.extend({
    template: "#comments-template",
    tagName: 'ul',
    className: 'list-group',
    childView: List.Comment,
    childViewContainer: ".list-group",
    emptyView: NoCommentView,
    events: {
      "click #save-comment": "saveComment"
    },
    saveComment: function () {
      var data,
          value = Backbone.Syphone.serialize(this);

      if (value.comment) {
        data = {
          comment: value,
          issue_id: this.collection.issue_id
        };

        this.collection.create(data);
        this.$('#comment-entry').val('');
      }
    }
  });
});

