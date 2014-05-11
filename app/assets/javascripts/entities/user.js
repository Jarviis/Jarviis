Jarviis.module("Entities", function(Entities, Jarviis, Backbone, Marionette, $, _) {
  Entities.User = Backbone.Model.extend({
    urlRoot: '/api/'+apiVer+'/users'
  });

  Entities.UserCollection = Backbone.Collection.extend({
    model: Jarviis.Entities.User,
    url: '/api/'+apiVer+'/users',
    initialize: function (options) {
      this.options = options;
    }
  });

  var API = {
    getUsersEntity: function (data) {
      var users = new Jarviis.Entities.UserCollection();
      users.fetch({data: data});
      return users;
    }
  }

  Jarviis.reqres.setHandler("users:entity", function (data) {
    return API.getUsersEntity(data);
  });
});
