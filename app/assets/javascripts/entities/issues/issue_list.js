Jarviis.module("Entities", function(Entities, Jarviis, Backbone, Marionette, $, _){

  Entities.IssueCollection = Backbone.PageableCollection.extend({
    model: Jarviis.Entities.Issue,
    state: {
      pageSize: 5
    },
    mode: "client",
    url: "/api/v1/issues"
  });

  var API = {
    getIssuesEntity: function (data) {
      var issues = new Jarviis.Entities.IssueCollection(),
          defer = $.Deferred();

      issues.fetch({
        data: data,
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

  Jarviis.reqres.setHandler("issues:entity", function (data) {
    return API.getIssuesEntity(data);
  });

});
