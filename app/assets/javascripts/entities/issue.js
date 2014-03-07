Jarviis.module("Entities", function(Entities, Jarviis, Backbone, Marionette, $, _){
  Entities.Issue = Backbone.Model.extend({
    // url: 'api/'+apiVer+'/issues'
  });
  Entities.IssueCollection = Backbone.Collection.extend({
    model: Jarviis.Entities.Issue,
    url: function() {
      return '/api/v1/issues';
    },
    initialize: function (options) {
      this.options = options;
    }
  });

  Jarviis.reqres.setHandler("issue:entity", function(id){
    return reported_issues.where({id: id})[0]
  });
});

