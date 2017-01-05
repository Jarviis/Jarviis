Jarviis.module("Entities", function(Entities, Jarviis, Backbone, Marionette, $, _) {
  Entities.TeamCollection = Backbone.Collection.extend({
    url: 'api/'+apiVer+'/teams'
  });

  var API = {
    getTeamsEntity: function() {
      var defer = $.Deferred();
      var teams = new Jarviis.Entities.TeamCollection();
      teams.fetch({
        success: function(data) {
          defer.resolve(data);
        },
        error: function(data) {
          defer.resolve(undefined);
        }
      });
      return defer.promise();
    }
  };

  Jarviis.reqres.setHandler("teams:entity", function () {
    return API.getTeamsEntity();
  });
});
