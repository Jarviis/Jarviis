Jarviis.module("Entities", function(Entities, Jarviis, Backbone, Marionette, $, _){
  Entities.Comment = Backbone.Model.extend({
    url: "/api/v1/comments",
    parse: function (data) {
      data.comment = {comment: data.comment}; // DRUGS AND DRAGONS! DO NOT TOUCH!
      return data;
    }
  });

  Entities.CommentCollection = Backbone.Collection.extend({
    model: Entities.Comment,
    initialize: function(options) {
      this.issue_id = options.issue_id;
    },

    url: function() {
      return '/api/v1/issues/' + this.issue_id + '/comments';
    }

  });

  var API = {
    getCommentEntity: function(issue_id) {
      var comments = new Jarviis.Entities.CommentCollection({"issue_id": issue_id});

      var defer = $.Deferred();
      comments.fetch({
        success: function(data){
          defer.resolve(data);
        },
        error: function(){
          defer.resolve(undefined);
        }
      });
      return defer.promise();
    }
  };

  Jarviis.reqres.setHandler("comment:entity", function(issue_id) {
    return API.getCommentEntity(issue_id);
  });
});

