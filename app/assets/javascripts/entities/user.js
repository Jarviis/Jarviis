Jarviis.module("Entities", function(Entities, Jarviis, Backbone, Marionette, $, _) {
  Entities.User = Backbone.Model.extend({
    urlRoot: '/api/'+apiVer+'/users'
  });

  Entities.UserCollection = Backbone.Collection.extend({
    model: Jarviis.Entities.User,
    url: '/api/'+apiVer+'/users'
  });

  var API = {
    getUsersEntity: function () {
      var defer = $.Deferred();
      var users = new Jarviis.Entities.UserCollection();
      users.fetch({
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

  Jarviis.reqres.setHandler("users:entity", function () {
    return API.getUsersEntity();
  });
});
