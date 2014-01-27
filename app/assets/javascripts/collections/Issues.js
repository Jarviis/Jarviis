Jarviis.Collections.Issues = Backbone.Collection.extend({
  model: Jarviis.Models.Issue,
  url: '/api/'+apiVer+'/issues'
});
