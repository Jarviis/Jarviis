Jarviis.module("Entities", function(Entities, Jarviis, Backbone, Marionette, $, _){

  Entities.IssueCollection = Backbone.Collection.extend({
    model: Jarviis.Entities.Issue,
    url: function() {
      return '/api/v1/issues';
    },
    initialize: function (options) {
      this.options = options;
    }
  });

  var API = {
    getIssueEntity: function(issueId){
      var issue = new Entities.Issue({id: issueId}),
          defer = $.Deferred();

      issue.fetch({
        success: function(data){
          defer.resolve(data);
        },
        error: function(){
          defer.resolve(undefined);
        }
      });

      return defer.promise();
    },
  };

  Jarviis.reqres.setHandler("issue:entity", function(id){
    return API.getIssueEntity(id);
  });

});
