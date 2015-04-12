Jarviis.module("Entities", function(Entities, Jarviis, Backbone, Marionette, $, _) {

  Entities.SearchUsersCollection = Backbone.Collection.extend({
    model: Jarviis.Entities.User,
    url: '/api/'+apiVer+'/users/search'
  });

  Entities.SearchIssuesCollection = Backbone.Collection.extend({
    model: Jarviis.Entities.Issue,
    url: '/api/'+apiVer+'/issues/search'
  });

  var API = {
    getEntity: function (id, query) {
      var defer = $.Deferred();
      var users = new Jarviis.Entities[id]();
      users.fetch({
        data: query,
        success: function(data){
          defer.resolve(data);
        },
        error: function(data){
          defer.resolve(undefined);
        }
      });
      return defer.promise();
    }
  };

  Jarviis.reqres.setHandler("users:search", function (keyword) {
    return API.getEntity('SearchUsersCollection', {username: keyword});
  });

  Jarviis.reqres.setHandler("issues:search", function (keyword) {
    return API.getEntity('SearchIssuesCollection', {keyword: keyword});
  });
});

