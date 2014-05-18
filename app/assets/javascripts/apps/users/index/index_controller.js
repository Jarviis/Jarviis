Jarviis.module("Users.Index", function (Index, Jarviis, Backbone, Marionette, $, _) {
  var users;

  Index.Controller = {
    indexUsers: function () {
      users = Jarviis.request("users:entity", {});
    }
  };
});
