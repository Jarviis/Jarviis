Jarviis.module("Entities", function(Entities, Jarviis, Backbone, Marionette, $, _){
  Entities.Comment = Backbone.Model.extend({});

  Entities.CommentCollection = Backbone.Collection.extend({
    initialize: function(options) {
      this.issue_id = options.issue_id
    },

    url: function() {
      return '/api/v1/issues/' + this.issue_id + '/comments';
    },

    parse: function(data) {
      return data;
    }
  });

  var API = {
    getCommentEntity: function(issue_id) {
      var comments = new Jarviis.Entities.CommentCollection({"issue_id": issue_id})
      return comments.fetch();
    }
  };

  Jarviis.reqres.setHandler("comment:entity", function(issue_id) {
    return API.getCommentEntity(issue_id);
  });
});

